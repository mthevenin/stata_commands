*! version 1.0 Aout 2015    [Marc Thevenin Ined-Sms]
*! version 1.1 Aout 2016    (correction du test pour modèle linéaire 
*! version 1.2 Octobre 2017 (correction du test pour mlogit avec v15 stata

capture program drop tmt3

program define tmt3

syntax varlist(fv)

di ""  
di as result "Type-III multiple test for categorical covariable(s) after `e(cmd)'"

if "`e(cmd)'"!="regress" & "`e(cmd)'"!="mlogit" {
di ""  
di as text   "{hline 13}{c +}{hline 35}"
di as text   "   Variables {c |}       df" /*
*/ _col(30) "Khi2      Prob>chi2"
display as text "{hline 13}{c +}{hline 35}"

foreach x  of varlist `varlist' {
qui testparm i.`x'
di as text %13s abbrev("`x'",13) "{c |}" /*
*/ as result /*
*/ %9.0g `r(df)'   "   " /*
*/ %8.0g `r(chi2)' "   " /*
*/ %8.3f `r(p)'    "   " /*
*/
}
display as text "{hline 13}{c +}{hline 35}"
}

if "`e(cmd)'"=="mlogit"{

qui levelsof `e(depvar)' if `e(depvar)'!=`e(baseout)', local(l)
foreach l2 of local l {
*local eq = `l2' 
di ""  
di as result "For `e(depvar)' = `l2'" 
di as text    "{hline 13}{c +}{hline 35}"
di as text    "   Variables {c |}       df" /*
*/ _col(30) "Khi2      Prob>chi2"
display as text "{hline 13}{c +}{hline 35}"

foreach x  of varlist `varlist' {
qui testparm i.`x' , equation(#`l2')
di as text %13s abbrev("`x'",13) "{c |}" /*
*/ as result /*
*/ %9.0g `r(df)'   "   " /*
*/ %8.0g `r(chi2)' "   " /*
*/ %8.3f `r(p)'    "   " /*
*/
}
display as text "{hline 13}{c +}{hline 35}"

}
}


if "`e(cmd)'"=="regress"{
di ""  
di as text   "{hline 13}{c +}{hline 26}"
di as text   "   Variables {c |}   df" /*
*/ _col(26) "F      Prob>F"
display as text "{hline 13}{c +}{hline 26}"

foreach x  of varlist `varlist' {
qui testparm i.`x'
local Fdf " (`r(df)',`r(df_r)')"

di as text %13s abbrev("`x'",13) "{c |}" /*
*/ as result /*
*/       "`Fdf'"  "" /*
*/ %8.3g `r(F)'  "" /*
*/ %8.3f `r(p)'  "" /*
*/
}
display as text "{hline 13}{c +}{hline 26}"
}


end



