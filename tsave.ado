*! version 1.0 Septembre 2015 [Marc Thevenin INED-SMS]

capture program drop tuse

*** COMMAND TSAVE ***

program define tsave

syntax    anything
tokenize `anything'

saveold "D:/stata_temp/`anything'.dta" , replace

end


