
rsource, terminator(END_OF_R)
library(cmprsk);
library(foreign);
base <- read.dta("competout_gray_test.dta",convert.f=TRUE);
attach(base);
out<-cuminc(cuminc_var_time,cuminc_var_event,cuminc_var_group);
colnames(out$Tests)[1] <- "Chi2" ;
colnames(out$Tests)[2] <- "Pr>Chi2" ;
out$Tests[,c(1,3,2)];
rm(list=ls());
unlink(".RData");
detach(cmprsk,unload=TRUE);
detach(survival,unload=TRUE);
detach(splines,unload=TRUE);
detach(foreign,unload=TRUE);
END_OF_R
