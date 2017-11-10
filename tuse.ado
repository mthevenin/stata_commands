*! version 1.0 Septembre 2015 [Marc Thevenin INED-SMS]

capture program drop tuse


*** COMMAND TSAVE ***

program define tuse

syntax anything
tokenize `anything'

use "D:/stata_temp/`anything'.dta" , clear

end


