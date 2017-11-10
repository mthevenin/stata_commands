*! version 1.0 Aout 2015 [Marc Thevenin INED-SMS]

capture program drop ggof
program define ggof

syntax varlist(max=1)

tokenize `varlist'

tempvar p_ggof
tempname temp_roc y_vs_p ggof_histo0 ggof_histo1 ggof_c1 ggof_c2

qui predict `p_ggof'

quietly estat gof, g(10)
local hlpv = chi2tail(`r(df)', `r(chi2)')
local hldf   : di       `r(df)'
local hlchi2 : di %6.2f `r(chi2)'
local hlpv   : di %6.3f `hlpv' 

qui lroc                               , all name(`temp_roc') title(Roc curve) nodraw
qui twoway (scatter `varlist' `p_ggof'), ylabel(0(1)1) name(`y_vs_p') title(`1' vs probability) xtitle(Predicted probability) nodraw 
qui histogram `p_ggof' if `1'==0, name(`ggof_histo0') title(`1' = 0) xtitle(Predicted probability) nodraw
qui histogram `p_ggof' if `1'==1, name(`ggof_histo1') title(`1' = 1) xtitle(Predicted probability) nodraw

graph combine `y_vs_p'      `temp_roc'   , cols(2) name(`ggof_c1') nodraw
graph combine `ggof_histo0' `ggof_histo1', cols(2) name(`ggof_c2') nodraw ycommon
graph combine `ggof_c1'     `ggof_c2'    , rows(2)                              ///
note("Hosmer & Lemeshow's test for 10 groups :"                                 ///
     "df=`hldf'"                                                                ///
	 "chi2=`hlchi2'"                                                            ///
	 "Prob>chi2 =`hlpv'", size(vsmall) box)                                     ///
title("Goodness of Fit")

end



