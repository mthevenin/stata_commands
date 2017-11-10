capture program drop   gpct
program define gpct

	syntax varlist(min=2 max=2) [if] [in], lab(integer)

	di as text   "Version (super) provisoire: ne pas diffuser svp ;=) 
	di as text   "A prévoir: option pour les intervalles de confiances - pondération - controle du nom des variables pour matcell etc....."
	di as input   ""
	di as input   ""
	di as result  "AVERTISSEMENT: SI MSG D'ERREUR r(198)"
	di as input   "-------------------------------------"
	di as result  "LE LABEL DES MODALITES DE LA VARIABLE Y DOIT-ETRE"
	di as result  "COMPATIBLE AVEC DES NOMS DE VARIABLE STATA: NI ESPACE NI ACCENT ET SEULEMENT _"
	di as result  "COMME CARACTERE SPECIAL"

	marksample touse
	tokenize `varlist'


	qui tab `1' `2' if `touse',  matcell(Y) matrow(r)

	svmat r
	svmat Y

	qui levelsof `2', local(val)
	local c: word count `val'

	rename r1 X_`1'

	if "`lab'"=="0" {
		local c: word count `val'
		forvalue val2=1/`c' {
			local y "Y"
			local sum `sum' Y`val2'
		} 
	}


	if "`lab'" =="1" {
		foreach val2 of local val{
			capture rename Y`c' Y`val2'
		}
		local des: value label `2'
		foreach val2 of local val {
			local n`val2': label `des' `val2'
			capture rename Y`val2' Y_`n`val2''
			local sum `sum' Y_`n`val2''
		}
	}

	qui egen N=rsum(`sum')


	local a "("
	local b ")"  
	local c "|"
	local l "line"

	foreach sum2 of local sum {
		qui qui replace `sum2'=(`sum2'/N)*100
		local g `g' `l' `sum2' X_`1' `c'`c'
	}

	tw `g', ylabel(0(10)100) ytitle("%")

	drop X_`1' Y* N
end


* gpct2  age str_fam if pvague=="ABCDEF" & age<15

