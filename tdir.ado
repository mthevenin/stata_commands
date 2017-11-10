capture program drop tdir


*** COMMAND TSAVE ***

program define tdir

syntax
display as txt    "------------------------------------"
display as result "  Contenu du repertoire stata_temp  "
display as txt    "------------------------------------"
dir "D:/stata_temp/"


end



