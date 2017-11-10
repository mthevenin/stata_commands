.-
Aide pour ^cpairs^: analyse de la qualité de l'ajustement
Redige sans accent en raison du changement du systeme d'encodage lors du passage à la v14
.-


^Syntaxe^
---------
^cpairs^ variable_dependante

^Description^
------------
^cpairs^ calcule quelques statistiques de qualité de l'ajustement après avoir execute un modele
logit, probit, cloglog

^Statistiques^
-------------
% de paires concordantes et discordantes
D de Somer
Gamma
Tau-a
c-Auc (Aire sous la courbe de Roc)

^Exemple^
--------
webuse lbw
quietly logit low age lwt i.race smoke ptl ht ui
^cpairs low^

^Output:^
Association of Predicted Probabilities and Observed Responses

      Number of pairs =    7670

Proportion Concordant =   0.746
Proportion Discordant =   0.254
      Proportion Tied =   0.000

            Somer's D =   0.492
                Gamma =   0.493
                Tau-a =   0.213
                c-AUC =   0.746

.-
Auteur: ^Marc Thevenin^ - ^Ined-Sms^ [^marc.thevenin@ined.fr^]
.-
Voir également la commande ^ggof^ et la commande officielle de Stata ^estat gof^
