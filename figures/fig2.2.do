*Create Fig 2.2. Stata
import delimited using "C:/GitHub/mlm-teaching/data/df.csv"

* make numeric
encode x047_wvs, gen(x047_wvs_n)

* set graph scheme
set scheme s1mono

* subset sample

*Plot A
twoway (scatter a170 x047_wvs_n if inlist(iso3c, "DEU", "KOR", "IDN", "MEX"), mcolor("gray") msize(vtiny) jitter(15)) ///
(lfit a170 x047_wvs_n, lcolor("black") lwidth(medthick)), ytitle("Life Satisfaction") xtitle("Income Category") ///
saving("C:/GitHub/mlm-teaching/figures/fig2.2a.gph", replace)  

twoway (scatter a170 x047_wvs_n if inlist(iso3c, "DEU", "KOR", "IDN", "MEX"), mcolor("gray") msize(vtiny) jitter(15)) ///
(lfit a170 x047_wvs_n if iso3c == "DEU", lcolor("72 41 121") lwidth(medthick)) /// *Regression line for Germany
(lfit a170 x047_wvs_n if iso3c == "KOR", lcolor("50 182 122") lwidth(medthick)) /// *Korea
(lfit a170 x047_wvs_n if iso3c == "IDN", lcolor("31 149 120") lwidth(medthick)) /// *Indonesia
(lfit a170 x047_wvs_n if iso3c == "MEX", lcolor("black") lwidth(medthick)), /// *Mexico
xtitle("Income Category") ytitle("") legend(order(2 "DEU" 3 "KOR" 4 "IDN" 5 "MEX") rows(2)) saving("C:/GitHub/mlm-teaching/figures/fig2.2b.gph", replace) 

*combine plots
graph combine "C:/GitHub/mlm-teaching/figures/fig2.2a.gph" "C:/GitHub/mlm-teaching/figures/fig2.2b.gph"

* save graph
graph export "C:\GitHub\mlm-teaching\figures\fig2.2_stata.png", as(png) replace
