.-
Aide pour ^tmt3^: test de type 3 pour covariables categorielles
Rédige sans accent en raison du changement du systeme d'encodage lors du passage à la v14
.-

^Syntaxe^
---------
^tmt3^ variable(s)


^Description^
------------
- ^tmt33^ renvoie un test multiple de Wald de type b1=b2=.....=bp=0  pour une ou 
plusieurs covariables categorielles de modalites (k=1,2,...,p) de preference à plus
de 2 modalites (si non resultat du test bi=0 donne dans l'output de la regression)

- Les covariables doivent-être prefixees par i ou ib lors de l'estimation du modele
 ("factor variable")
 
- Modeles supportes (verifies): logit, probit, mlogit, ologit, cloglog, poisson, stcox, regress



^Exemples^
---------

^[1] Modele MCO^

webuse auto
quietly gen gweight=weight
quietly recode gweight min/2239=1 2240/3189=2 3190/3599=3 3600/max=4
quietly regress mpg ib2.gweight ib2.rep78 i.foreign
^tmt3 gweight rep78^

Output:

Type-III multiple test for categorical covariable(s) after regress

-------------+--------------------------
   Variables |   df      F      Prob>F
-------------+--------------------------
      gweight| (3,60)    31.5   0.000
        rep78| (4,60)    2.65   0.042
-------------+--------------------------



^[2] Modele logit^
webuse lbw
quietly gen gage=age
quietly recode gage min/18=1 19/22=2 23/25=3 26/max=4
quietly logit low ib2.gage lwt i.race smoke ptl ht ui
^tmt3 gage race^

Output:

Type-III multiple test for categorical covariable(s) after logit

-------------+-----------------------------------
   Variables |       df      Khi2      Prob>chi2
-------------+-----------------------------------
         gage|        3     1.4006      0.705   
         race|        2    7.26305      0.026   
-------------+-----------------------------------


^[3] Modele multinomial^
webuse sysdsn1
quietly mlogit insure age male nonwhite i.site
^tmt3 site^

Output:
Type-III multiple test for categorical covariable(s) after mlogit

For insure = 2
-------------+-----------------------------------
   Variables |       df      Khi2      Prob>chi2
-------------+-----------------------------------
         site|        2    10.7754      0.005   
-------------+-----------------------------------

For insure = 3
-------------+-----------------------------------
   Variables |       df      Khi2      Prob>chi2
-------------+-----------------------------------
         site|        2    6.80668      0.033   
-------------+-----------------------------------


^[3] Modele poisson^
webuse dollhill3
quietly poisson deaths smokes i.agecat, exposure(pyears)
^tmt3 agecat^

Output:
Type-III multiple test for categorical covariable(s) after poisson

-------------+-----------------------------------
   Variables |       df      Khi2      Prob>chi2
-------------+-----------------------------------
       agecat|        4    643.156      0.000   
-------------+-----------------------------------


^[3] Modele Cox^
webuse stan3
quietly gen pgroup = year
quietly recode pgroup min/69=1 70/72=2 73/max=3
quietly stcox age posttran surg year i.pgroup
^tmt3 pgroup^

Output:
Type-III multiple test for categorical covariable(s) after cox

-------------+-----------------------------------
   Variables |       df      Khi2      Prob>chi2
-------------+-----------------------------------
       pgroup|        2     9.4131      0.009   
-------------+-----------------------------------


.-
Auteur: ^Marc Thevenin^ - ^Ined-Sms^ [^marc.thevenin@ined.fr^]
.-

