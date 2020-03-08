*What implicit claim about causality does Obama's "cycle of crime" theory assert? 
*According to the “cycle of crime” theory, harsh sentencing of one-time convicts causes these convicts to become professional criminals (i.e., recidivism). Hence, paradoxically, harsh sentence might cause criminal justice to decrease instead of increase.


*Read in data:
insheet using crime-iv.csv

*Label variables:
label variable defendantid ”Defendant.Id”
label variable republicanjudge “Republican.Judge”
label variable severityofcrime “Severity.Of.Crime”
label variable monthsinjail ”Months.In.Jail”
label variable recidivates “Recidivates”

*#2 - My friends design: Run a regression to see whether the length of prison time preducts recidivism
reg recidivates monthsinjail

* Fair enough, the coeff. for prison time is significantly different from zero with p<.001 and positive with .0088, however, there could be more to the story, let's try sth. else. I also want to include the other covariates now:
reg recidivates monthsinjail severityofcrime republicanjudge
*the political affiliation of the judge (coeff = .12) and the severity of the crime (coeff. =  .075) seem to be stronger predictors than months in jail (.006) of a second convitcion (all significant).

*#4 A balance test and table:

*Create balance table:
teffects ipw (recidivates) (republicanjudge severityofcrime monthsinjail)

*Have we done an adequate job of balancing the covariates so that we can trust the estimated treatment effect? We could use the overidentification test:
tebalance overid, nolog
*We can reject the null hypothesis that all covariates are balanced.

*tebalance summarize reports the model-adjusted difference in means and ratio of variances between the treated and untreated for each covariate:
tebalance summarize
*Differences in weighted means are negligible but signs after weighting have changed, and variance ratios are all near one.
*The Raw columns show where we started, and, before weighting, signs were in the opposite direction. Use Bo's starter code to see what's going on:

*Using starter code by Bo:
global balanceopts "prehead(\begin{tabular}{l*{6}{c}}) postfoot(\end{tabular}) noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01)"

estpost ttest recidivates severityofcrime monthsinjail, by(republicanjudge) unequal welch
esttab . using test.tex, cell("mu_1(f(3)) mu_2(f(3)) b(f(3) star)") wide label collabels("Control" "Treatment" "Difference") noobs $balanceopts mlabels(none) eqlabels(none) replace mgroups(none)

*We get insightful results from our balance test analysis: There is a significant difference between treatment - i.e., getting a republican judge, and control  - i.e., getting a democratic judge, for our dependent variable of recidivates. Interestingly, we also find a significant difference for our covariate months in jail. However, we do not find significantly difference for our covariate severity of crime, which is interesting and useful for our further analysis. We can reject the null hypothesis that all covariates are balanced. This is some evidence that there seems to be random selection to who (whatever the severity of crime) received a judge form a particular political party. This is useful because we want to use our balance test for our IV design. 


*#5a let's move on to our IV design - and our first stage
* Assumption: you are asking us to go in alignment with the posted articles and further explore how duration time in prison predicts a second conviction. In words, in the first stage of my IV design, I am interested in what might predict my explanatory variable of interest: monthsinjail. More specifically, from my balance test I get the intuition that the length of the first prison time might have something to do with the political affiliation of the judge. If I am right, then republicanjudge might predict the length of stay during first sentence, which is investigated in the first stage. Please note that I am assuming our data on political affiliation of the judge is form the first trial, i.e., before the duration of the first prison time. 

* x is the variable I want to make a causal statement about, which is monthsinjail
* z is the explanatory variable in my first stage: republicanjudge
* I'm adding severity of crime as a control/ covariate
reg monthsinjail republicanjudge severityofcrime

*# 6 Interpret the coefficient on your instrument from the first stage. 
*This estimate for our coefficient of interest republicanjudge is 3.22 and significant, which indicates the amount of increase in monthsinjail that would be predicted by a 1 unit increase in the predictor (here, whether we have a republican judge or not). Expectedly, the severity of the crime in the first place strongly predicts the months spent in jail with a coefficient of 18.15 and being significant. However, point of our analysis is to uncover potential unfairness in our justice system (i.e., the cycle of crime), and it is interesting to notice that the political affiliation of the judge has an effect on the duration of prison time and thereby might contribute to the cycle of crime. So let's move on to stage 2.

*#7 Calculate the "reduced form." with outcome of interest: recidivates and z is republicanjudge from stage 1
reg recidivates republicanjudge severityofcrime   
 
*# 8 Calculate the ratio of the reduced form The coefficient on z from the reduced form. ... divided by ... The coefficient on z from the first stage. 
*\beta_{IV} = \beta_{.1426641} / \beta_{3.221876}/ = .04427982

*# 9 Now complete the IV regression and make a publication quality table of the second stage. Use the setup below. 
ssc install ivreg2
ivreg2 recidivates (monthsinjail = republicanjudge) severityofcrime  

*Interpretation: coefficiant of monthsinjail on recidivates is now .0442798 and significant. What I also want to mention here is that in fact the severity of the crime has a negative impact of a second sentence (beta = -.615, p <.001), which is very interesting and might further speak to the cycle of crime argument.
 
 *table:
 
 
 *# 10 F-Stat
 *F(  2,  4997) =   164.34 with Prob > F      =   0.0000
 * Since my F-value is larger than the typical threshold (F=10) and my p-value is less than the significance level(alpha = .05), my sample data provide sufficient evidence to conclude that my IV regression model fits the data better than the model with no independent variables.
 
 
 *# 11 Compare your answer to question #8 (above) to the IV coefficient in #9. 
 * My IV coefficient in #9 has a value of .0442798 and is significant (p<.001) and is the same as my ratio in #8. This indicates that by seperating out my IV design into stage 1 and 2 I am able to better understand what causes a second sentence by seperating out the compliers in my analysis (i.e., causal effect of prison time on second sentence for those who receive a republican judge). I find that the duration of prisontime after a first trial leads to an increase in the likelihood of being convicted again, an effect partly explained by being assigned to a republican judge.
 

*#12 Complete these sentences. 
*In the research design above (using randomized judges), the always-takers are the the convicts who are always judged guilty whether they get a republican judge or not. The never-takers are the the convicts who are always staying away from the prison no matter whether they get a republican judge. The compliers are the convicts who are sentenced only if they get a republican judge. The defiers are the the convicts who are staying away from the prison only if they get a republican judge. 
 
 
*#13 Comment on the monotonicity assumption and the possibility of "defiers" in this setting. 
* A monotonicity assumption is also known as the no-defiers assumption. This assumption makes sense in a lot of applications. Here, the possibility of defiers means that a convict will stay away from prison only if they get a republican judge. Although, given our experimental design and outcomes unlikely, I would argue that there can be defiers.


 *# 14 In your dataset, what types of defendants are compliers? 
 *Those prisoners who (a) get a republican judge when first in trial (treatment) and (b) are sent to prison; i.e., I tested the causal effect of prison time on second sentence for those who receive a republican judge
 
 * # 15 Does the cycle of crime hypothesis appear to be true for the compliers? 
 * Yes it does. In #9 I was able to show that the coefficiant of monthsinjail on recidivates is .0442798 and significant for the compliers. For these convicts, the severity of the crime actually has a negative impact of a second sentence (beta = -.615, p <.001). Hence, this is a pretty clear indication of the cycle of crime. The cycle of crime hypothesis seems to be true for those who receive a republican judge.
 
