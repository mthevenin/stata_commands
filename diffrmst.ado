
capture program drop diffrmst
program define diffrmst

syntax varlist(min=1 max=1),  [ng]

graph drop _all


local packg colorpalette grstyle strmst2
foreach p of local packg {
capture which `p'
if _rc==111 ssc install `p'
} 

grstyle init 
grstyle set plain, horizontal grid
grstyle set mesh,  horizontal
grstyle set legend, nobox stack
grstyle set color hue, n(3) opacity(100)


qui strmst2 `varlist'
local tmax `r(tau)'

qui levelsof _t if _t<=`tmax', local(T)
local c : word count("`T'")

qui numlist "`T'"
local nlist `r(numlist)'
foreach el of local nlist {
	matrix A = nullmat(A),`el'
	matrix T = A'
}


qui gen _time = .

qui gen _rmst0=.
qui gen _rmst1=.
qui gen _diff=. 
qui gen _l=. 
qui gen _u=. 
qui gen _p=. 



forvalue i=1/`c' {

	scalar t =  T[`i',1]
	local tau = scalar(t)
	qui strmst2 `varlist', tau(`tau')

	*rmst
	matrix R0 = r(rmstarm0)
    matrix R02 = R0[1,1..4]
	scalar rmst0 = R02[1,1]
	
	matrix R1 = r(rmstarm1)
    matrix R12 = R1[1,1..4]
	scalar rmst1 = R12[1,1]
	
	
	*diff rmst
	matrix D = r(unadjustedresult1)
	matrix D2 = D[1,1..4]

	scalar rmst0 = R02[1,1]
    scalar rmst1 = R12[1,1]
	
	scalar diff = D2[1,1]
	scalar l = D2[1,2]
	scalar u = D2[1,3]
	scalar p = D2[1,4]

		
	qui replace _time=scalar(t)  in `i'
	
	qui replace _rmst0=scalar(rmst0) in `i'
	qui replace _rmst1=scalar(rmst1) in `i'
	
	qui replace _diff=scalar(diff)  in `i'
	qui replace _l=scalar(l)  in `i'
	qui replace _u=scalar(u)  in `i'
	qui replace _p=scalar(p)  in `i'

	
	qui local rmst_0 =  scalar(rmst0)
	qui local rmst_0 =  round(`rmst_0', .1)
    qui local rmst_1 =  scalar(rmst1)
	qui local rmst_1 =  round(`rmst_1', .1)

}

list _time _rmst1 _rmst0 _diff _l _u _p in 1/`c', noobs

if "`ng'"=="" {

local xy "lw(vthin) lc(black)"


qui tw (line _rmst1 _rmst0 _time ), ///
	title("Rmst") xtitle("durée")  name(g1) nodraw legend(order(1 "Rmst0" 2 "Rmst1"))

qui tw (line _diff _time ) (rarea _l _u _time, color(%20) lw(vvthin)), ///
	title("Différence Rmst") xtitle("durée")  name(g2) nodraw yline(0, `xy') legend(order(1 "Différence Rmst" 2 "IC") cols(2))

qui tw (line _p _time), ///
	ylabel(0(0.1)1) yline(0.05, `xy') title("P Values") xtitle("durée") note("Ligne de référence: p=0.05") name(g3) nodraw

local tmax    : di %6.2f `tmax'
local rmst0   : di %6.2f `rmst_0'
local rmst1   : di %6.2f `rmst_1' 	
		
qui graph twoway scatteri 1 1 "", name(g4) xlabel(,nogrid) ylabel(,nogrid) ///
mlabsize(*4) mlabpos(0) msym(i) yscale(off noline) xscale(off noline) plotregion(style(none)) ///
note("Commande {bf: strmst2}: {it:A.Cronin, L.Tian, H.Uno}" " " ///
     "A durée max {&tau}=`tmax':" " "    ///
	 "RMST0=`rmst0'" " "  ///
	 "RMST1=`rmst1'",     ///
justification(left) pos(11) size(small)) nodraw 

qui graph combine g1 g2 g3 g4
}

drop _time _rmst0 _rmst1 _diff _l _u _p
matrix drop _all

end






