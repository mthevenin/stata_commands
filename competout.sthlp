{smcl}
{* 01sept2016}{...}
{* Version 1.0}{...}
{hline}
help for {competout}
{hline}

{title:Generate Outputs, Graphics and Tests in presence of competing risks}

{title:Syntax}
{cmd:competout} {it:timevar} {it:eventvar} [{cmd:if} {it:exp}] [{cmd:in} {it: range}] {cmd:,} {cmd:event(}{it:integer}{cmd:)} [{cmd:group(}{it:varname}{cmd:)} {cmd:test(s | r | sr)} msave]

{title:Description}
{p 4 4 0}{cmd:competout} displays outputs, graphics and tests for CI (Cumulative Incidence) using several Stata's commands and cmprsk package from R.
It is not useful to declare data as survival-time data with stset instruction.{p_end} 

{title:Options}
{p 4 8 2}- {cmd:event(}{it:integer}{cmd:)} is the event of interest of {it:eventvar}. It is not an option.
The right-censoring level has to be coded 0. The maximum number of competing events if fixed at 6 by stcompet. 
So, the maximum number of levels for {it:eventvar} is 7 plus the censoring(0).
{p_end}

{p 4 8 2}
- {cmd:group(}{it:varname}{cmd:)} is the categorical variable to make comparaison between groups. {p_end}

{p 4 8 0}- {cmd:test(s | r | sr)}  shows results of several tests in order to compare estimates for different levels defined by the use of {cmd:by(}{it:varname}{cmd:)}.{p_end}
{p 6 8 0}(1) {bf:s}  display Stata's available tests: {bf:log-rank} for cause specific hazard and (but not for difference(s) between survival curves), and {bf:Pepe-Mori} 
for weighted areas {bf:between 2 cumulative incidences only}.{p_end}
{p 6 8 0}(2) {bf:r}  display {bf:Gray's test}. This test is based on subdistribution hazard  and compares Cumulative incidences between 2 or more groups.{p_end}
{p 6 8 0}(3) {bf:sr} display all the tests.                                                                                                                                  
{p_end}

{p 4 8 0}- {cmd:msave} saves results in a matrix. The name of the matrix is given by eventvar# or {it:eventvar}#{it:group}#, where # are  levels of {it:eventvar} and {it:group}. 
         See example (3) below{p_end}                                                                                                                                

{title:Remark}
{p 4 8 0} {cmd:competout} uses 3 commands from SSC: {cmd:stcompet}(Coviello, Bogess), {cmd:stpepemori}(Covellio) and {cmd:rsource} (Newson).
Only {cmd:rsource} needs to be installed by the user,{cmd:competout} installs automatically {cmd:stpepemori} if the command is needed. 
R coding is not required, {cmd:cmprsk} and {cmd:foreign} package can be downloaded directly via dialog boxes of R's console. 
If you want to install foreign and cmprsk packages in Stata, see below ("How to display Gray's test", (4) (5)). {p_end}

{title:How too display Gray's test from R}
{p 4 8 0}(1) {cmd:ssc install rsource}{p_end}
{p 4 8 0}(2) Install R: {browse "https://www.r-project.org/"}{p_end}
{p 4 8 0}(3) Find R path*, copy & paste in your profile.do*:{p_end}
{p 10 8 0}{cmd:global Rterm_path `"path to R\R.exe"'}{p_end}
{p 10 8 0}{cmd:global Rterm_options `"--slave --vanilla --args  "`tf1'" "`tf2'" "'}{p_end}
{p 4 8 0}(4) Install {cmd:foreign} package from Stata.:{p_end}
{p 10 8 0}{cmd:rsource, terminator(END_OF_R)}{p_end}
{p 10 8 0}{cmd:install.packages("foreign", repos="http://cran.uk.r-project.org")}{p_end}
{p 10 8 0}{cmd:END_OF_R}{p_end}
{p 4 8 0}(5) Install {cmd:cmprsk} package from Stata.:{p_end}
{p 10 8 0}{cmd:rsource, terminator(END_OF_R)}{p_end}
{p 10 8 0}{cmd:install.packages("cmprsk", repos="http://cran.uk.r-project.org")}{p_end}
{p 10 8 0}{cmd:END_OF_R}{p_end}
{p 4 8 0}(6) File {cmd:competout_gray_test.do} must be in the same directory than competout.ado{p_end}

{p 2 8 0}* For example: path to R => C:\Program Files\R\R-3.3.1\bin\i386{p_end}
{p 2 8 0}** Help for {help profile}. You can create a profile.do and save it in the user directory of C:{p_end}


{title:Examples}

{p 4 4 2}(1) Display all results comparing 2 levels of a categorical variable   {p_end}
{p 12 20 2}{cmd:.  use http://www.stata-press.com/data/cggm3/bc_compete, clear} {p_end}
{p 12 20 2}{cmd:.  competout time status, event(1) group(drug) test(sr)} {p_end}

{p 4 4 2}(2) Display all results comparing 2 levels of 3 levels categorical variable. The event of interest is status=2{p_end}
{p 12 20 2}{cmd:. The competout time status if race==1 | race==3, event(2) group(race) test(sr)} {p_end}

{title: Output for example(2)}

Cumulative incidence for race=1
----------------------------------------------------------
       _t |         IC          SE      95% LB      95% UB
----------+-----------------------------------------------
        3 |     0.0308      0.0107      0.0145      0.0572
        9 |     0.1115      0.0195      0.0769      0.1532
       12 |     0.1346      0.0212      0.0965      0.1791
       15 |     0.1385      0.0214      0.0998      0.1834
       18 |     0.1500      0.0221      0.1097      0.1962
       21 |     0.1538      0.0224      0.1131      0.2004
       24 |     0.1577      0.0226      0.1164      0.2046
       27 |     0.1731      0.0235      0.1299      0.2215
       33 |     0.1769      0.0237      0.1333      0.2257
       36 |     0.1846      0.0241      0.1401      0.2340
       54 |     0.1885      0.0243      0.1435      0.2382
----------------------------------------------------------

Cumulative incidence for race=3
----------------------------------------------------------
       _t |         IC          SE      95% LB      95% UB
----------+-----------------------------------------------
        3 |     0.0250      0.0175      0.0048      0.0784
        6 |     0.0875      0.0316      0.0385      0.1617
        9 |     0.1000      0.0335      0.0467      0.1772
       12 |     0.1375      0.0385      0.0731      0.2221
       15 |     0.1500      0.0399      0.0823      0.2367
       18 |     0.1750      0.0425      0.1013      0.2654
       21 |     0.1875      0.0436      0.1110      0.2795
       27 |     0.2000      0.0447      0.1209      0.2935
       33 |     0.2125      0.0457      0.1309      0.3074
       45 |     0.2375      0.0476      0.1512      0.3349
       60 |     0.2500      0.0484      0.1616      0.3484
----------------------------------------------------------

[Graph not displayed]


{title:Log-rank test (Cause specific hazards)}

 Main event failure:  status == 2
   Chi2(1) =  1.2385
 Prob>Chi2 =  0.2658


{title:Pepe and Mori test comparing the cumulative incidence of two groups of race}

     Main event failure:  status == 2
Chi2(1) = .35604  -  p =  0.55071

Competing event failure:  status == 1
Chi2(1) = .12298  -  p =  0.72583


{title:Gray's test}

using Rsource (Newson) & cmprsk (Gray)

Line 1 - Test for main event failure:  status == 2
Line 2 - Test for competing event(s) failure:  status == 1

. rsource, terminator(END_OF_R)
Assumed R program path: "C:\Program Files\R\R-3.3.1\bin\i386\R.exe"
Beginning of R output

       Chi2 df   Pr>Chi2
1 1.2464305  1 0.2642353
2 0.2942562  1 0.5875059

End of R output

Runtime: r; {bf:t=2.20} 15:58:30


{p 4 4 2}(3) Display  matrix of results & save it as variables{p_end}
{p 12 20 2}{cmd:. qui competout time status, event(1) group(drug) msave} {p_end}

{p 12 20 2}{cmd:.matrix dir} {p_end}
    status1drug1[7,5]
    status1drug0[13,5]

{p 12 20 2}{cmd:. matrix list status1drug0} {p_end}

status1drug0[13,5]
          t_10      ic_10      se_10      lb_10      ub_10
 r1          3  .09677419   .0187738  .06403645  .13745086
 r2          6  .19354839  .02508754  .14705034   .2449125
 r3          9  .25403226  .02764258  .20168248  .30950267
 r4         12  .31451613  .02948453  .25772676  .37275583
 r5         15  .31854839  .02958553  .26150619  .37693165
 r6         18   .3266129   .0297799  .26908012  .38526888
 r7         21  .33467742  .02996426  .27667385  .39358721
 r8         27  .33870968  .03005274  .28047802  .39773938
 r9         30  .34274194  .03013879  .28428701  .40188696
r10         36  .34677419  .03022242  .28810076  .40602996
r11         39  .35080645  .03030366  .29191924  .41016844
r12         45  .35483871  .03038252  .29574242  .41430243
r13         48  .36290323   .0305332   .3034027  .42255705

{p 12 20 2}{cmd:. svmat status1drug0, names(col)} {p_end}
Comment: with names(col) option, variables generated are t_10, ic_10, se_10, lb_10, ub_10   

{title:References}

{p 4 8 2}Coviello, V. and Bogess, M. 
{it:Cumulative incidence estimation in the presence of competing risks}.
The Stata Journal, 2004, Number2, pp 103-112.

{p 4 8 2}Pintilie, M. 
{it:Competing Risks. A practical perspective}.
2006, Wiley and Sons. Chichester, England. 

{title:Authors}

{cmd:competout}:         Marc Thevenin, Ined-Sms, (marc.thevenin@ined.fr)      		

{cmd:Others packages}:
       {cmd:stcompet   (Stata)}: Coviello and Bogess 
       {cmd:stpepemori (Stata)}: Coviello 
       {cmd:Rsource    (Stata)}:  Newson 
       {cmd:cmprsk         (R)}:  Gray
	
	
{title:Also see}

{p 4 13}
Stata's help files:  help for {help rsource}, {help stcompet}, {help stpepemori}{p_end}
