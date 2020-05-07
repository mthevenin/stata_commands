capture program drop  gpct
program define gpct

	syntax varlist(min=2 max=2) [if] [in], [ci] [gops(string)] [mts] [keep]

	di as result   "Maj 2020 intervalles de confiances type Clopper-Pearson (OK-2020) 
	di as result   "Palette de couleur par défaut type ggplot2 (hue) pour les courbes, couleur grise pour les ic"
	di as result    "Nécessite grstyle et colorpalette de B.Jann si option mts: seront installées automatiquement"
	di as result       "Si l'option gops est renseignée, ne pas utiliser l'option legend"  


* installation de colorpalette et grstyle si nécessaire
local packg colorpalette grstyle
foreach p of local packg {
capture which `p'
if _rc==111 ssc install `p'
} 

	marksample touse
	tokenize `varlist'

	qui tab `1' `2' if `touse',  matcell(_Y) matrow(_r)
	svmat _r
	svmat _Y

	qui levelsof `2', local(val)
	local v: word count `val'

	forvalue v2=1/`v' {
		local sum `sum' _Y`v2'
	} 

	local labn: value label `2'

	local k=1

	if "`labn'"!="" {
		foreach i of local val {
			local labv: label  `labn'  `i'
			local order `order'  `k++'  `""`labv'""'
			*local o "legend(order(`order'))"
		}
	}    

	local c "|"
	local d ","
	local l "line"
	local r "rarea"

	qui egen N=rsum(`sum')
    * proportion
	foreach sum2 of local sum {
		qui qui replace `sum2'=(`sum2'/N)
		local g1 `g1' `l' `sum2' _r `c'`c'

		if "`ci'"!="" {
			*lower limit - exact clopper-pearson	
			qui gen _v1     = 2*(N - N*`sum2'+1)
			qui gen _v2     = 2*N*`sum2'  
			qui gen _c      = _v1/_v2
			qui gen _F      = invF(_v1,_v2,0.975)
			qui gen lcl_`sum2' = 1/(1 + _F*_c)
			drop _v1 _v2 _c _F 

			*upper limit - exact clopper-pearson
			qui gen _v1   = 2*(N*`sum2'+1) 			
			qui gen _v2   = 2*(N-N*`sum2')
			qui gen _c    = _v1/_v2
			qui gen _F    = invF(_v1,_v2,0.975)	
			qui gen ucl_`sum2' = (_F*_c)/(1 + _F*_c)
			qui drop _v1 _v2 _c _F 	

			local g2 `g2' `r' lcl_`sum2' ucl_`sum2'  _r `d' color(gray%16) lc(black%5) lw(vthin) `c'`c' 
		}	

	}
	
	
   if "`mts'"!="" {
   set scheme s2color
   grstyle init gpct, replace
   grstyle set legend 6, nobox stack 
   grstyle set plain, horizontal grid
   grstyle set mesh,  horizontal
   grstyle linewidth major_grid vvthin
   grstyle set color hue, opacity(100) n(`v')
   }	

tw `g1' `g2', `gops' legend(cols(`v') order(`order')) 
	
if "`keep'"==""{
	drop _r* _Y* N 
	if "`ci'"!="" {
		drop ucl* lcl*
	}
	}
	
end





