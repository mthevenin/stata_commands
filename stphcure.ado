capture program drop stphcure
capture program drop emdistcure   

* Version 1.0 aout 2018 - Marc Thevenin (Ined Sms) 

program  define stphcure
	syntax varlist(min=2 max=2) [if] [in],                                          ///
		MODel(string) id(name) [TForm(string)] timing(varlist fv) cure(varlist fv) ///
		[boot] [expand] [NBoot(integer 100)] [MAXIter(integer 1000)]

	di ""
	di "Marc Thevenin - Ined-Sms"
	di "Version 1.0 - Aout 2018"
	di ""
	
	di as text "Nombre maximum d'itérations = `maxiter'"
	di ""

	if "`boot'"!="" {
		di as text   "Nombre de bootstraps = `nboot'"
		di as result "Soyez patient.e ...... Voire très patient.e ......."
		di ""
		di as text "---------------"
		di as text "|  Bootstrap  |"
		di as text "---------------"
	}

	tokenize `varlist'
	marksample touse

	local base $S_FN
	macro drop i

	qui keep if `touse'
	*qui compress   

	fvexpand `timing' `cure'
	local fv = "`r(varlist)'"
	foreach x of local fv {
		local x= substr("`x'", strpos("`x'", ".") + 1, .)
		qui drop if `x'>=.
	}

	if "`expand'"!="" {
		qui expand `2'
	}
    
  	if "`model'"=="dist" {
	qui sort   `id' `2'         
	qui bysort `id': gen _t=_n  
	qui gen _t2=_t^2            
    }

	qui bysort `id': gen _rank=_n
	
	***************************************
	*******     Initialisation    *********
	***************************************
    
	
	
	qui glm `1' `stub' if _rank==1, family(binomial) link(logit) 
	qui predict _p
    drop _rank
	qui gen _w=`1'

	if "`model'"=="dist" {
		qui gen _e=`1'
		qui bysort id: replace _e=0 if _t<t
    }

	fvrevar `timing', stub(stub)
    local stub `r(varlist)'

	if "`model'"=="dist" {
		if "`tform'"=="t" {
			qui glm _e _t `stub' [iw=_w], family(binomial) link(logit)
		}
		if "`tform'"=="tt2" {
			qui glm _e _t _t2 `stub' [iw=_w], family(binomial) link(logit)
		}
	}

	if "`model'"=="cox" {
	    qui gen _e =`1'
		qui gen _ft=`2' 
		qui gen _lw=log(_w)
		qui stset _ft, failure(_e) id(`id')  	
		qui stsplit, at(failure)
	
		
		qui stcox `stub', nohr  offset(_lw) 	
		qui stjoin
	}

    foreach x of local stub {
		gen _B`x' = _b[`x']*`x'
		local _xbs `_xbs' _B`x'
    }
    egen _XB = rowtotal(`_xbs')
    drop _B* stub*	



	if "`boot'"=="" & "`model'"=="dist" {
		emdistcure `varlist', model(`model') id(`id') tform(`tform') timing(`timing') cure(`cure') maxiter(`maxiter')
	}
	if "`boot'"=="" & "`model'"=="cox"  {
		emdistcure `varlist', model(cox) id(`id') timing(`timing') cure(`cure') maxiter(`maxiter')	
	}

	    qui sort `id' 
		qui save temp_boot, replace
	
	***************************************
	*******        BOOTSTRAP      *********
	*************************************** 
	
    if "`boot'"!= "" {
	if "`model'"=="dist" {

		 local bs = `nboot'
		
		forv k = 1(1)`bs' {
		  *tab `1'
			qui capt preserve
			*des
			qui keep if _t==1
			qui keep `id' `1'
			qui bsample _N, strata(`1')
			qui bysort `id': gen _count=_N

			qui sort `id'
			qui merge `id' using temp_boot
			qui drop _merge

			qui drop if _count==.
			qui expand _count
			qui drop _count
			
			qui emdistcure `varlist', model(dist) id(`id') tform(`tform') timing(`timing') cure(`cure') maxiter(`maxiter')
            			
			if "`tform'"=="t" {
				qui glm _e _t `timing' [iw=_w], family(binomial) link(logit)
			}
			if "`tform'"=="tt2" {
			    qui glm _e _t _t2 `timing' [iw=_w], family(binomial) link(logit)
			}
 
			mata theta1`k' = st_matrix("e(b)")

			if `k'==1 {
				mata theta1 = theta1`k'
			}

			if $i < `maxiter' {
				if `k'>1 {
					mata theta1 = theta1\theta1`k'
				}
			}
			qui glm _w `cure' if _t==1, family(binomial) link(logit) scale(dev) irls nolog
			mata theta2`k' = st_matrix("e(b)")

			if `k'==1 {
				mata theta2 = theta2`k'
			}

			if  $i < `maxiter' {
				if `k'>1 {
					mata theta2 = theta2\theta2`k'
				}
			}

			di _c "."
			if (int(`k'/10)==`k'/10) di _c "|"
			if (int(`k'/50)==`k'/50) di " " `k'

			restore
		}
		di ""

		qui emdistcure `varlist', model(dist) id(`id') tform(`tform') timing(`timing') cure(`cure') maxiter(`maxiter')
		}
	

	if  "`model'"=="cox" {

		* nombre de réplications
        local bs = `nboot'

        forv k = 1(1)`bs' {
			qui preserve
			
			bsample _N, strata(e)
			qui emdistcure `varlist', model(cox) id(`id') timing(`timing') cure(`cure') maxiter(`maxiter')

			qui stcox `timing', nohr offset(_lw) 

            mata theta1`k' = st_matrix("e(b)")

			if `k'==1 {
				mata theta1 = theta1`k'
			}

			if $i < `maxiter' {
				if `k'>1 {
					mata theta1 = theta1\theta1`k'
				}
			}

			qui glm _w `cure', family(binomial) link(logit) scale(dev) irls nolog

			mata theta2`k' = st_matrix("e(b)")
			if `k'==1 {
				mata theta2 = theta2`k'
			}

			if  $i < `maxiter' {
				if `k'>1 {
					mata theta2 = theta2\theta2`k'
				}
			}	
			di _c "."
			if (int(`k'/10)==`k'/10) di _c "|"
			if (int(`k'/50)==`k'/50) di " " `k'		


			qui restore
		}
		di ""

		qui emdistcure `varlist', model(cox) id(`id') timing(`timing') cure(`cure') maxiter(`maxiter')

		}
    
	

	***************FAILURE**************
	*di "SE POUR FAILURE"
		mata bs_var1 = variance(theta1)
		mata bs_var1
		mata bs_se1  = diag(bs_var1):^.5
		mata se1     = diagonal(bs_se1)
		
		* recup variable
		fvexpand `timing'
		local fv = "`r(varlist)'"
		foreach x of local fv {
			local _x = subinstr("`x'",".","",1)
			local t_out `t_out' `_x'
		} 
		if "`tform'"=="t" {
			local t_out _t `t_out' intercept
		}
		if "`tform'"=="tt2" {
			local t_out _t _t2 `t_out' intercept
		}
		local t : word count `t_out'

		*di "Z POUR FAIL"
		mata z1     = b1:/bs_se1
		mata z1     = diagonal(z1)
		mata az1    = abs(z1)
		*di " P-VALUE POUR FAIL 
		mata I      = diagonal(I(`t'))
		mata p1    = (I - normal(az1))*2
		mata logitdt  = b1,se1,z1,p1
		mata st_matrix("logitdt",logitdt)	

		***************GLM**************
		*di "SE POUR LOGIT CURE"
		mata bs_var2 = variance(theta2)
		mata bs_se2  = diag(bs_var2):^.5
		mata se2     = diagonal(bs_se2)

		* recup variable
		fvexpand `cure'
		local fv = "`r(varlist)'"
		foreach x of local fv {
			local _x = subinstr("`x'",".","",1)
			local c_out `c_out' `_x'
		} 
		local c_out `c_out' intercept
		local c : word count `c_out'

		*di "Z POUR GLM"
		mata z2     = b2:/bs_se2
		mata z2     = diagonal(z2)
		mata az2    = abs(z2)
		*di " P-VALUE POUR GLM 
		mata I      = diagonal(I(`c'))
		mata p2    = (I - normal(az2))*2
		mata logit  = b2,se2,z2,p2
		mata st_matrix("logit",logit)

		***matlist failure***
		qui gen _covar1 = ""
		forvalues i = 1/`t' {
			qui replace _covar1 = "`:word `i' of `t_out''" in `i'
		}
		qui svmat  logitdt
		qui rename logitdt1 _b1
		qui rename logitdt2 _se_boot1
		qui rename logitdt3 _z1
		qui rename logitdt4 _p1

		mkmat _b1 _se_boot1 _z1 _p1, matrix(logitdt) nomissing rownames(_covar1) 
		matlist logitdt, ///
		   border(rows) rowtitle(Failure time) title(TIMING) format(%9.4f) twidth(17) aligncolnames(center)

		***matlist cure***
		qui gen _covar2 = ""
		forvalues i = 1/`c' {
			qui replace _covar2 = "`:word `i' of `c_out''" in `i'
		}
		qui svmat logit
		qui rename logit1 _b2
		qui rename logit2 _se_boot2
		qui rename logit3 _z2
		qui rename logit4 _p2

		mkmat _b2 _se_boot2 _z2 _p2, matrix(logit) nomissing rownames(_covar2) 
		matlist logit, ///
			border(rows) rowtitle(Uncure proba) title(LOGIT CURE) format(%9.4f) twidth(17) aligncolnames(center)
	}
	
	qui use "`base'", clear	 
end

***************************************
*******        emdistcure     *********
***************************************

program define emdistcure
	syntax varlist(min=2), model(string) id(name) [tform(string)] timing(varlist fv) cure(varlist fv) [MAXIter(integer 1000)]

	local    maxit = 0 
	local        i = 0 
	local     eps1 = 1
	local     eps2 = 1
	local     eps  = 1

	while `eps' > 0.0000001 & `maxit'<`maxiter' {

		local        i = `i' + 1
		local maxit    = `maxit' + 1
		global i `i'


        if "`model'"=="cox" {	
			qui stsplit, at(failure) 
		}
 
		qui bysort `id': gen _nid=_n		
		qui bysort  _t:  gen  _nt=_n
		qui bysort  _t:  gen  _Nt=_N
		qui bysort  _t:  egen _A=total(_e)

		qui bysort _t:   egen _B=total(_w*exp(_XB))
 
		
		qui gen _AB=(_A/_B)
		qui sort _t
		qui gen _A0 = sum(_AB) if _nt==_Nt

		qui bysort _t: egen _a=total(_A0)
		qui drop _A0
		qui rename _a _A0
        if  "`model'"=="dist" { 
			qui sum _t if _e==1, d
		}
		if  "`model'"=="cox" { 
			qui sum _t if _e==1, d
		}

		qui gen _mt=`r(max)'
		qui replace _A0=. if _t>_mt

		qui gen _S0 = exp(-_A0)
		qui replace _S0=0 if _t>_mt
		
		qui sort   `id' _t
		qui bysort `id': gen _s = _S0^(exp(_XB)) if _n==_N
		qui bysort `id': egen _St=total(_s)
		qui drop _s

		qui drop _XB
		qui gen _w2=1 if _w==1
		qui sort   `id' _t
		qui bysort `id': replace _w2 = (_p*_St)/( _p*_St + 1 - _p) if _w2==. & _n==_N
		qui bysort `id': egen _w3 = total(_w2) if _w2!=1
		qui replace _w3=1 if _w2==1

		qui drop _p _w _w2 _A _B _AB _A0 
		qui rename _w3 _w

		if "`model'"=="cox" {
			qui bysort id: egen _e2=total(_e)
			qui drop _e
			qui rename _e2 _e
		}
		
	   qui drop _nt _Nt _S0 _St  


		if "`model'"=="dist" {
			qui glm _w `cure' if _nid==1, family(binomial) link(logit) scale(dev) irls nolog
		}
		if "`model'"=="cox" {
			qui sort `id' _ft
			qui bysort `id': keep if _n==1 
			qui glm _w `cure', family(binomial) link(logit) scale(dev) irls nolog
		}

		mata theta1`i' = st_matrix("e(b)")
		mata theta1`i' = diag(theta1`i')

		if `i'>1 {
			local j = `i' - 1
			mata diffglm = theta1`i' - theta1`j'
			mata diff2glm= diffglm*diffglm
			mata sum = trace(diff2glm)
			mata  st_matrix("eps1", sum)
			scalar eps1 = eps1[1,1]
			local  eps1 eps1
		}

		qui predict _p

		mata theta2`i' = st_matrix("e(b)")
		mata theta2`i' = diag(theta2`i')

		fvrevar `timing', stub(stub)
        local stub `r(varlist)'	

        if "`model'"=="dist" {

			if "`tform'"=="t" {
				qui glm _e _t `stub' [iw=_w], family(binomial) link(logit)
			}
			if "`tform'"=="tt2" {
				qui glm _e _t _t2 `stub' [iw=_w], family(binomial) link(logit)
			}
        }


		if "`model'"=="cox" {
			qui replace _ft=`2'
			qui drop _lw	
			qui gen _lw=log(_w)	
			qui stset _ft, failure(_e) id(`id') 
			qui stsplit, at(failure)
			qui stcox `stub', nohr  offset(_lw) 
			qui stjoin
		}


		foreach x of local stub {
			gen _B`x' = _b[`x']*`x'
			global xbs $xbs _B`x'
        }
        egen _XB = rowtotal($xbs)
        drop _B* stub*		
		macro drop xbs


		mata theta2`i' = st_matrix("e(b)")
		mata theta2`i' = diag(theta2`i')

		if `i'>1 {
			local j = `i' - 1
			mata diffcox = theta2`i' - theta2`j'
			mata diff2cox= diffcox*diffcox
			mata sum = trace(diff2cox)
			mata  st_matrix("eps2", sum)
			scalar eps2 = eps2[1,1]
			local eps2 eps2
		}

		scalar eps = `eps1' + `eps2'
		local eps eps


		qui drop _mt _nid
	}
	
	di " nombre d'itérations =" `i' 
	di " convergence =" `eps' 

	di ""
	di ""
	
	di as result "######################################"
	di as result "#           FAILURE TIME             #"
	di as result "######################################"	
	

	if "`model'"=="dist" {
		if "`tform'"=="t" {
			glm _e _t `timing'     [iw=_w], family(binomial) link(logit)
		}
		if "`tform'"=="tt2" {
			glm _e _t _t2 `timing' [iw=_w], family(binomial) link(logit)
		}
	}

	if "`model'"=="cox" {
        stcox `timing', nohr  offset(_lw)
	}

	mata b1 = st_matrix("e(b)")
	mata b1 = b1'
	

	di as result "######################################"
	di as result "#         UNCURE PROBABIITY          #"
	di as result "######################################"
	
	bysort id: gen nid=_n
    glm _w  `cure' if nid==1, family(binomial) link(logit) scale(dev) irls nolog noheader
	mata b2 = st_matrix("e(b)")
	mata b2 = b2'
	

end





*use "D:\Marc\SMS\cure model\e1684.dta" , clear
*capt gen id=_n
*gen dur =round(FAILTIME)
*gen e=FAILCENS
*stphcure e dur, model(cox) id(id)  timing(i.TRT i.SEX c.AGE) cure(i.TRT i.SEX c.AGE) boot  
