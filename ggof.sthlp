.-
Aide pour ^ggof^: qualit� de l'ajustement
Redige sans accent en raison du changement du systeme d'encodage lors du passage � la v14
.-

^Syntaxe^
---------
^ggof^ variable_dependante

^Description^
------------
^ggof^ affiche plusieurs graphiques combin�s ainsi que le test d'Hosmer et Lemeshow pour 10 groupes
apr�s avoir ex�cut� un mod�le logit, probit, cloglog


^Graphiques et statistiques^
---------------------------
Probabilit�s pr�dites vs valeurs de la variables d�pendants
Courbes de ROC (et statistique Auc)
Densit�s des probabilit�s pr�dites pour chaque valeur de la variable d�pendent
En l�gende le test d'Hosmer et Lemeshow pour 10 groupes


^Exemple^
--------
webuse lbw
quietly logit low age lwt i.race smoke ptl ht ui
^cpairs low^

.-
Auteur: ^Marc Thevenin^ - ^Ined-Sms^ [^marc.thevenin@ined.fr^]
.-
Voir �galement la commande ^cpairs^
