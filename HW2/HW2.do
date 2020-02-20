* Read in data: 

insheet using vaping-ban-panel.csv

* Label your variables

label variable stateid ”State.Id”
label variable year “Year”
label variable vapingban ”Vaping.Ban”
label variable lunghospitalizations “Lung.Hospitalizations”


* Run preliminary regression #2: 

 reg lunghospitalizations vapingban

* Store regression
eststo regression_one 


* Run DnD regressions #4: 

areg lunghospitalizations vapingban, absorb(stateid year)

*although I downloaded reghdfe package, absorb cannot entail more than one variables, hence need to run two fixed-effect regressions

areg lunghospitalizations vapingban, absorb(stateid)

* Store regression
eststo regression_two

areg lunghospitalizations vapingban, absorb(year)

* Store regression
eststo regression_three



* Regression tables #5:
global tableoptions "bf(%15.2gc) sfmt(%15.2gc) se label noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01) replace r2"
esttab regression_one using Preliminary-Regression.rtf, $tableoptions keep(vapingban) 


global tableoptions "bf(%15.2gc) sfmt(%15.2gc) se label noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01) replace r2"
esttab regression_two using Regression-Fixed-Effect-State.rtf, $tableoptions keep(vapingban)


global tableoptions "bf(%15.2gc) sfmt(%15.2gc) se label noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01) replace r2"
esttab regression_three using Regression-Fixed-Effect-Year.rtf, $tableoptions keep(vapingban) 

*Fixed Effect State Stats
testparm i.stateid
*no such variables the specified varlist does not identify any testable coefficients


* Graph DnD #3:

collapse (mean) lunghospitalizations, by (vapingban year)
reshape wide lunghospitalizations, i(year) j (vapingban)
*(note: j = 0 1)
Graph twoway line lunghospitalizations0 lunghospitalizations1 year, sort




