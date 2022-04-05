import delimited using "C:/GitHub/mlm-teaching/data/df.csv", clear

* subset to Wave 5 of WVS, cross-section better for comparing real incomes
keep if year > 2004 & year < 2010

* graphing scheme black and white background
set scheme s1mono

*replace "NA" with missing
replace impinc = "." if impinc == "NA"


* create numeric income in k and trim over 60k
gen inc_real = real(impinc)/1000
replace inc_real = 60 if (inc_real > 60) & (inc_real != .)

* Figure 3.1 scatterplot with line
graph twoway (scatter a170 inc_real, msize(vtiny) jitter(10)) (lfit a170 inc_real), ///
xtitle("Income in 2015 (dollars, k)") ytitle("Life Satisfaction") legend(off)

graph export "C:\GitHub\mlm-teaching\figures\fig3.1_stata.png", as(png) replace

* Figure 3.2 three countries

graph twoway (scatter a170 inc_real if iso3c == "DEU", msize(tiny) msymbol(O) jitter(10) mcolor("72 41 121")) ///
(scatter a170 inc_real if iso3c == "ESP", msize(tiny) msymbol(O) jitter(10) mcolor("50 182 122")) ///
(scatter a170 inc_real if iso3c == "ZMB", msize(tiny) msymbol(O) jitter(10) mcolor("31 149 139")) ///
(lfitci a170 inc_real if iso3c == "DEU", lcolor("72 41 121") lwidth(medthick)) ///
(lfitci a170 inc_real if iso3c == "ESP", lcolor("50 182 122") lwidth(medthick)) ///
(lfitci a170 inc_real if iso3c == "ZMB", lcolor("31 149 120") lwidth(medthick) range (0 4)), ///
xtitle("Income in 2015 (dollars, k)") ytitle("Life Satisfaction") legend(order(1 "DEU" 2 "ESP" 3 "ZMB") rows(1))

* save graph
graph export "C:\GitHub\mlm-teaching\figures\fig3.2_stata.png", as(png) replace
