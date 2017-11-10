******************************
**          cpairs          **
**       Marc Thevenin      ** 
**         Ined-Sms         **
******************************

* version 1.0 October 2016

capture program drop cpairs
program define cpairs
syntax varlist(min=1 max=1) 
preserve

tokenize `varlist'
tempvar p 
tempfile b p0 p1

qui lroc, nograph
local auc `r(area)'
qui des
local n `r(N)'

qui predict `p'
qui drop if `p'==.
qui save `b', replace
keep `1' `p'

qui levelsof `1', local(l)

foreach l2 of local l {
qui use `b', clear
qui keep if `1'==`l2'
rename `1'  y`l2'
rename `p'  p`l2'
qui bysort p`l2': gen N`l2'=_N
qui bysort p`l2': keep if _n==1
qui save   `p'`l2', replace
}

clear
qui use `p'0
cross using `p'1

qui gen N=N0*N1
qui expand N

qui gen conc=0
qui gen disc=0
qui gen tied=0

qui replace conc=1 if p1>p0
qui replace disc=1 if p0>p1
qui replace tied=1 if conc==0 & disc==0

di ""
di as result "Association of Predicted Probabilities and Observed Responses"
di ""
qui des
display as text "      Number of pairs =" %8.0f as result r(N)
di ""
qui sum conc
local tc `r(sum)'
display as text "Proportion Concordant =" %8.3f as result r(mean)
qui sum disc
local td `r(sum)'
display as text "Proportion Discordant =" %8.3f as result r(mean)
qui sum tied
local tt `r(sum)'
display as text "      Proportion Tied =" %8.3f as result r(mean)

di ""

* Somer's D
display as text "            Somer's D ="  %8.3f  as result (`tc'-`td')/(`tc'+`td'+`tt')
display as text "                Gamma ="  %8.3f  as result (`tc'-`td')/(`tc'+`td')
display as text "                Tau-a ="  %8.3f  as result (`tc'-`td')/((`n'*(`n'-1))/2)
display as text "                c-AUC ="  %8.3f  as result `auc'

restore

end

