capture program drop competout
      program define competout

**********************************************
*        version 1.1 - Janv 2017             *
**********************************************
* competout  (Stata): M.Thevenin             *
**********************************************
* stcompet   (Stata): E.Coviello & M.Boggess *
* stpepemori (Stata): E.Coviello             *
* rsource    (Stata): Newson                 *
* cmprsk     (R)    : B.Gray                 *
**********************************************

* v1   :    Aout 2016 
* v1.1 : Janvier 2017: Ajout de l'option msave 
*                      Modification de l'affichage des resultats du test du log-rank


syntax varlist(min=2 max=2) [pweight fweight iweight] [if] [in], event(integer) [group(string)] [test(string)] [msave]


marksample touse      
markin if `touse'

* check if stcompet stpepemori installed, install if not

local packg stcompet stpepemori
foreach p of local packg {
capture which `p'
if _rc==111 ssc install `p'
} 

* check rsource
if "`test'"=="r" | "`test'"=="sr" {
capture which rsource
if _rc==111 {
di as error "Error:"
di as error "rsource (Newson) is needed to compute Gray's test"
di as error "Foreign & cmprsk packages are needed"

exit 111
}
}

* stcompet syntax for  compet1() compet2()... compet(6)
tokenize `varlist'
tempvar cevent

qui gen `cevent'=`2' 
qui replace `cevent'=. if `2'==`event' | `2'==0

qui levelsof `cevent', local(lcevent)
local nc: word count `lcevent'  

local p1 "("
local p2 ")"
local v ","
local a1"`"
local a2"'"

local i=0
foreach num of local lcevent {
local i=`i'+1
local l`i' `num'  
}

forvalues i = 1/`nc' {
local c `c' compet`i'`p1'`l`i''`p2'
}

tempvar n 


* weights
if "`weight'" != "" {
                     local wgt "[`weight'`exp']"
                    }
					
*** without by ***
if "`group'"==""  {

*estimates of CI with stset & stcompet
*stset

qui stset `1' `wgt' if `touse', f(`2'=`event')


* stcompet
tempvar competoutCI competoutSE competoutLO competoutHI
stcompet `competoutCI'=ci `competoutSE'=se `competoutLO'=lo `competoutHI'=hi if `touse', `c'
label variable `competoutCI' "IC"
label variable `competoutSE' "SE"
label variable `competoutLO' "95% LB"
label variable `competoutHI' "95% UB"

local var `competoutCI' `competoutSE' `competoutLO' `competoutHI' 

foreach var2 of local var {
format `var2' %9.4f
}

sort _t
qui bysort `competoutCI': gen `n'=_n

foreach var2 of local var {
qui bysort `var2': replace `var2'=. if `2'!=`event'
qui bysort `var2': replace `var2'=. if `n'>1
}
sort `competoutCI' _t

* output ic se lo hi
tabdisp _t if `competoutCI'<., cell(`competoutCI' `competoutSE' `competoutLO' `competoutHI') 
* matrix of results
if "`msave'"!="" {
  mkmat _t `competoutCI' `competoutSE' `competoutLO' `competoutHI' if _t!=., nomissing matrix(`2'`event')
}
  
* CI grap
tw (line `competoutCI' `1' , c(J) sort ylabel(0(0.1)1) title("Cumulative Incidence for `2'=`event'"))
drop _st _d _t _t0
}

*** with by ***
if "`group'"!="" {
preserve

qui keep if `touse'
qui levelsof `group', local(s)

* Estimates of CI with stset & stcompet
foreach s2 of local s {
*stset
qui stset `1' `wgt' if `group'==`s2', f(`2'=`event')

*stcompet
tempvar competoutCI`s2' competoutSE`s2' competoutLO`s2' competoutHI`s2'
qui stcompet `competoutCI`s2''=ci `competoutSE`s2''=se `competoutLO`s2''=lo `competoutHI`s2''=hi, `c'
label variable `competoutCI`s2'' "IC"
label variable `competoutSE`s2'' "SE"
label variable `competoutLO`s2'' "95% LB"
label variable `competoutHI`s2'' "95% UB"

*output
local var `competoutCI`s2'' `competoutSE`s2'' `competoutLO`s2'' `competoutHI`s2'' 

foreach var2 of local var {
format `var2' %9.4f
}

sort _t
qui bysort `competoutCI`s2'': gen `n'=_n

foreach var2 of local var {
qui bysort `var2': replace `var2'=. if `2'!=`event'
qui bysort `var2': replace `var2'=. if `n'>1
}
sort `competoutCI`s2'' _t

di ""
di as result "Cumulative incidence for `group'=`s2'"
tabdisp _t if `competoutCI`s2''<., cell(`competoutCI`s2'' `competoutSE`s2'' `competoutLO`s2'' `competoutHI`s2'') 

* matrix of results
if "`msave'"!="" {
mkmat _t `competoutCI`s2'' `competoutSE`s2'' `competoutLO`s2'' `competoutHI`s2'' if _t!=., nomissing matrix(`2'`event'`group'`s2')
}

* CI graph

qui gen `group'_`s2'=`competoutCI`s2''
local t "_"
local C "`group'`t'`s2'"
local graphCI  `graphCI' `p1' line `C' `1' `v' c`p1'J`p2' sort `p2'

drop  `competoutCI`s2'' `competoutSE`s2'' `competoutLO`s2'' `competoutHI`s2'' `n'
tw `graphCI', ylabel(0(0.1)1) title("Cumulative Incidence for `2'=`event' by `group' levels")
*drop `by'_`s2'
}

* TESTS

* test(r) Only Gray
* test(s) Pepemori & log-rank
* test(sr) All
		
if "`test'"=="s" | "`test'"=="sr"  {

di ""
di as text "{title:log-rank test (Cause specific hazards)}"
di ""
di as text " Main event failure:" as result "  `2' == `event'"  
qui stset `1', f(`2'=`event')
qui sts test `group' 
local lgpv = chi2tail(`r(df)', `r(chi2)') 
local chi2: di %8.4f `r(chi2)'
local    p: di %8.4f `lgpv'
                                                     
di as text "   Chi2(`r(df)') =" as result "`chi2'"  
di as text " Prob>Chi2 =" as result "`p'"                                                          
 
* Pepemori's test ("Weighted area between IC - Only two groups)
stpepemori `group', compet(`lcevent')
di ""
}

* Gray's test with R cmprsk package - cuminc function (Subdistribution hazards - IC)
di ""
if "`test'"=="r" | "`test'"=="sr" {

tempvar gevent
qui      gen `gevent'=0 if `2'==0 
qui  replace `gevent'=1 if `2'==`event' 
qui  replace `gevent'=2 if `2'!=`event' & `2'!=. & `2'!=0

di as txt "{title:Gray test}"
di ""
di as txt "using Rsource (Newson) & cmprsk (Gray)"
di ""
di as text "Line 1 - Test for main event failure: "  as result  " `2' == `event'
di as text "Line 2 - Test for competing event(s) failure: "  as result  " `2' == `lcevent'

qui gen cuminc_var_time =`1'
qui gen cuminc_var_event=`gevent'
qui gen cuminc_var_group=`group'

qui keep cuminc_var_time cuminc_var_event cuminc_var_group

			if "`c(version)'" >= "14" {
				 qui saveold "competout_gray_test.dta", version(11) replace
			}	
			else {
				 qui saveold "competout_gray_test.dta", replace
            }
         do "d:\ado\personal\c\competout_gray_test.do"
qui erase   "competout_gray_test.dta"

}

restore
}

end


