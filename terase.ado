*! version 1.0 Septembre 2015 [Marc Thevenin INED-SMS]


capture program drop terase


*** COMMAND TERASE ***

program define terase

syntax [namelist] 


qui cd "D:\stata_temp\"

di as text "Deleted files:"

* tous types de fichiers

if "`namelist'"=="" {

* dta
qui local listeF1 : dir . files "*.dta"
foreach x of local listeF1 {
di as result "`x' deleted"
erase `x'
}

*do
qui local listeF2 : dir . files "*.do"
foreach x of local listeF2 {
di as result "`x' deleted"
erase "`x'"
}


*ado
local listeF3 : dir . files "*.ado"
foreach x of local listeF3 {
di as result "`x' deleted"
erase `x'
}

*smcl
qui local listeF4 : dir . files "*.smcl"
foreach x of local listeF4 {
di as result "`x' deleted"
erase `x'
}


*gph
qui local listeF4 : dir . files "*.gph"
foreach x of local listeF4 {
di as result "`x' deleted"
erase `x'
}

*stsem
qui local listeF4 : dir . files "*.stsem"
foreach x of local listeF4 {
di as result "`x' deleted"
erase `x'
}

*log
qui cd "D:\stata_temp\log\"
qui local listeF4 : dir . files "*.log"
foreach x of local listeF4 {
capture erase `x'
*di as result "log files deleted excepted current log"
}
}

* par type de fichier 

*dta
if "`namelist'"=="dta" {
qui local listeF1 : dir . files "*.dta"
foreach x of local listeF1 {
di as result "`x' deleted'"
erase "`x'"
}
}

*do
if "`namelist'"=="do" {
qui local listeF1 : dir . files "*.do"
foreach x of local listeF1 {
di as result "`x' deleted"
erase "`x'"
}
}

*ado
if "`namelist'"=="ado" {
local listeF3 : dir . files "*.ado"
foreach x of local listeF3 {
di as result "`x'  deleted"
erase "`x'"
}
}

*smcl
if "`namelist'"=="smcl" {
qui local listeF4 : dir . files "*.smcl"
foreach x of local listeF4 {
di as result "`x' deleted"
erase "`x'"
}
}

*gph
if "`namelist'"=="gph" {
qui local listeF4 : dir . files "*.gph"
foreach x of local listeF4 {
di as result "`x' deleted"
erase `x'
}
}

*stsem
if "`namelist'"=="stsem" {
qui local listeF4 : dir . files "*.stsem"
foreach x of local listeF4 {
di as result "`x' deleted"
erase "`x'"
}
}

*log
if "`namelist'"=="log" {
qui cd "D:\stata_temp\log\"
qui local listeF4 : dir . files "*.log"
foreach x of local listeF4 {
capture erase `x'
di as result "log files deleted excepted current log"
}
}
end


