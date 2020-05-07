.-
Aide pour ^gpct^
Version 2.0 - Mai 2020
.-

^Courbes de pourcentages^ 
----------------------------------------------------------------------------------------- 

Syntaxe: ^gpct^ varX varY [if] [in], [ci] [gops(string)] [mts] [keep]

^Option^
----------
^ci^: reporte les intervalles de confiances estimés par la méthode de Clopper-Pearson
^gops(string)^: options graphiques supportées par la commande line. ^Ne pas renseigner l'option legend^ qui est utilisée par le programme.
^mts^: charge un style graphique utilisant la palette de couleur hue.
^keep^: conserve, sous forme de variables, les proportions générées pour le graphique.

^Exemple^
-------------------------------------
^use http://www.stata-press.com/data/r15/nlswork.dta , clear ^
^label define msp 0 "no_msp" 1 "msp", modify^
^label value msp msp^
^gpct age msp^
^gpct age msp, ci^
^gpct age msp if age>=20 & age<=40, ci gops(title("Statut matrimonial de 20 à 40 ans") ylabel(0(0.1)1)) mts keep^

^list _r1 _Y1 lcl__Y1 ucl__Y1 if _r1!=.^

       +--------------------------------------+
       | _r1        _Y1    lcl__Y1    ucl__Y1 |
       |--------------------------------------|
    1. |  20   .5968449   .5677245   .6254645 |
    2. |  21   .4935459   .4662048   .5209159 |
    3. |  22   .4465021   .4207713   .4724488 |
    4. |  23   .4008728   .3767778   .4253314 |
    5. |  24   .3914373   .3676866   .4155785 |
       |--------------------------------------|
    6. |  25   .3537676   .3300597    .378025 |
    7. |  26   .3593196   .3342452   .3849813 |
    8. |  27   .3378995   .3123311   .3641953 |
    9. |  28   .3322658   .3061638     .35916 |
   10. |  29   .3386709   .3124302   .3656735 |
       |--------------------------------------|
   11. |  30   .3390854   .3118373    .367153 |
   12. |  31   .3544621    .327354   .3822861 |
   13. |  32   .3375337   .3097394   .3661915 |
   14. |  33   .3261044   .3000993   .3529335 |
   15. |  34   .3553082    .327826   .3835213 |
       |--------------------------------------|
   16. |  35   .3496836   .3233743    .376694 |
   17. |  36   .3645365   .3361756    .393617 |
   18. |  37   .3546025   .3242418   .3858622 |
   19. |  38   .3571429   .3252217   .3900377 |
   20. |  39   .3831169    .348634   .4184985 |
       |--------------------------------------|
   21. |  40   .3466204   .3077947    .387026 |
       +--------------------------------------

.-
^Marc Thevenin^ - ^Ined/Sms^
Pour toute question ou tout type de bug: ^marc.thevenin@ined.fr^




