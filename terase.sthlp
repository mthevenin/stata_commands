.-
Aide pour ^terase^
Redige sans accent en raison du changement du systeme d'encodage lors du passage à la v14

.-

Efface les fichiers Stata present dans le repertoire stata_temp  
----------------------------------------------------------------------------------------- 

^terase^ [type_fichier] 

Description
-----------
Efface les fichiers stata presents dans le repertoire stata_temp ainsi que les logs crees a l'ouverture d'une session.
Les fichiers pris en charge sont: ^.dta^ ^.do^ ^.ado^ ^.mata^ ^.stsem^ ^.smcl^ ^.log^ .
Pour les log, le fichier d'une session active ne sont pas supprimees

Exemple
-------
Effacer tous les fichier Stata a l'exception du ou des logs actifs: 
^terase^
Effacer tous les fichiers de type .dta
^terase dta^

 
.-
Auteur: ^Marc Thevenin^ - ^Ined-SMS^
Pour toute question: ^m.thevenin@ined.fr^ 


