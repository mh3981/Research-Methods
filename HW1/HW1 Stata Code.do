/* Type these commands to install the "estout" package: 
ssc install estout
Also: Note you can type help [command] into Stata to get help on any command. 
*/

* Read in data: 
insheet using assignment1-research-methods.csv

* Label your variables
label variable calledback "calledback"
label variable eliteschoolcandidate "eliteschoolcandidate"
label variable malecandidate "malecandidate"
label variable bigcompanycandidate "bigcompanycandidate"
label variable recruiterismale "recruiterismale"
label variable recruiteriswhite "recruiteriswhite"

* Run regression: 
 reg calledback eliteschoolcandidate recruiterismale

* Store regression
eststo regression_one 


**********************************
* FOR PEOPLE USING MICROSOFT: 
global tableoptions "bf(%15.2gc) sfmt(%15.2gc) se label noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01) replace r2"
esttab regression_one using Elite-School-Effect.rtf, $tableoptions keep(eliteschoolcandidate recruiterismale) 


