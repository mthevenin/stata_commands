.-
Aide pour ^ggof^: qualité de l'ajustement
Redige sans accent en raison du changement du systeme d'encodage lors du passage à la v14
.-

^Syntaxe^
---------
^ggof^ variable_dependante

^Description^
------------
^ggof^ affiche plusieurs graphiques combinés ainsi que le test d'Hosmer et Lemeshow pour 10 groupes
après avoir exécuté un modèle logit, probit, cloglog


^Graphiques et statistiques^
---------------------------
Probabilités prédites vs valeurs de la variables dépendants
Courbes de ROC (et statistique Auc)
Densités des probabilités prédites pour chaque valeur de la variable dépendent
En légende le test d'Hosmer et Lemeshow pour 10 groupes


^Exemple^
--------
webuse lbw
quietly logit low age lwt i.race smoke ptl ht ui
^cpairs low^

.-
Auteur: ^Marc Thevenin^ - ^Ined-Sms^ [^marc.thevenin@ined.fr^]
.-
Voir également la commande ^cpairs^
