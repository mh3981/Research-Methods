*Read in data:
insheet using sports-and-education.csv

*Label variables:
label variable collegeid ”College.Id”
label variable academicquality “Academic.Quality”
label variable athleticquality “Athletic.Quality”
label variable nearbigmarket ”Near.Big.Market”
label variable ranked2017 “Ranked.2017”
label variable alumnidonations2018 “Alumni.Donations.2018”

*Create balance table:
teffects ipw (alumnidonations2018) (ranked2017 academicquality athleticquality nearbigmarket)

*Have we done an adequate job of balancing the covariates so that we can trust the estimated treatment effect? We could use the overidentification test:
tebalance overid, nolog
*We cannot reject the null hypothesis that all covariates are balanced.

*tebalance summarize reports the model-adjusted difference in means and ratio of variances between the treated and untreated for each covariate:
tebalance summarize
*Differences in weighted means are negligible, and variance ratios are all near one.
*The Raw columns show where we started, and, before weighting, differences were large.

*Using starter code by Bo:
global balanceopts "prehead(\begin{tabular}{l*{6}{c}}) postfoot(\end{tabular}) noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01)"

estpost ttest alumnidonations2018 academicquality athleticquality nearbigmarket, by(ranked2017) unequal welch
esttab . using test.tex, cell("mu_1(f(3)) mu_2(f(3)) b(f(3) star)") wide label collabels("Control" "Treatment" "Difference") noobs $balanceopts mlabels(none) eqlabels(none) replace mgroups(none)

*There is a significant difference between treatment and control condition for out dependent variable of interest alumni donations in 2018, and for our covariates athletic quality and near big market. We cannot reject the null hypothesis that all covariates are balanced. This is some evidence that there seems to be non-random selection into who was ranked.   

*#3 To address the above derived issue, we want to build a propensity score model and first need to determine and select all variables that the agents who assign treatment scan use in their assignments. In particular, we are looking at cross section data about 100 top colleges in the year 2017 that are ranked based on their athletic quality, i.e., basketball performance. It therefore seems reasonable, that rankers base their rank2017 on the athletic quality, rather than academic, into their ranking. For our propensity score model, we therefore need to weigh our model based on athletic quality.

*#4Build a propensity score model:
*#4aStep 1: Run a regression to see what determines being ranked in 2017:
reg ranked2017 athleticquality academicquality nearbigmarket
* It turns out that both athleticquality and nearbigmarket predict being ranked in 2017. Both are singinficant. As predicted, academicquality does not predict being ranked as top basketball school in 2017, where p=.258

*4bStep2: For each observation, predict the probability of treatment.
logit ranked2017 athleticquality nearbigmarket 
predict propoensity_score, pr


*#5 stacked histogram:
*ssc install psmatch2
psmatch2 ranked2017 athleticquality nearbigmarket, out(alumnidonations2018) common
psgraph

*6 Group your observations into ``blocks'' based on propensity score
sort propoensity_score
gen block = floor(_n/4)
* indicates some evidence of an overlap of propensity score

*7 Analyze the treatment effect of being ranked on alumni donations, while controlling for block-fixed effects as well as other covariates.
reg alumnidonations2018 ranked2017 i.block athleticquality nearbigmarket academicquality
eststo regression_one
global tableoptions "bf(%15.2gc) sfmt(%15.2gc) se label noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01) replace r2"
esttab regression_one using Preliminary-Regression.rtf, $tableoptions keep(ranked2017) 
 * Notes: This table contain regression predicting the amount of alumni donations in 2018 as a function of whether the school was ranked as a top basketball program in 2017 (1 or 0). Standard OLS standard errors are reported. Being ranked as top basketball program in 2017 tends to increase the likelihood of receiving alumni donations in the following year (by 500 percentage). Fixed effects of block and covariates athleticquality, nearbigcity and academicquality are controlled for/ not included in the analysis.
