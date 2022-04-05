import delimited using "C:/GitHub/mlm-teaching/data/df.csv", clear

*ssc install estout

* subset to Wave 1-5 of WVS, the only waves with the real income variable
keep if year < 2010

* graphing scheme black and white background
set scheme s1mono

*replace "NA" with missing
replace impinc = "." if impinc == "NA"

*remove missing on key vars
drop if impinc == "."

* create numeric income in k and trim over 60k
gen inc_real = real(impinc)/1000
replace inc_real = 60 if (inc_real > 60) & (inc_real != .)

* create a factor variable for iso3c (regression will not read a string var)
encode iso3c, gen(iso3c_F)


* Compare regressions
reg a170 inc_real
est store m1

mixed a170 inc_real || iso3c:, var
est store m2

mixed a170 inc_real || iso3c: inc_real, var
est store m3

reg a170 inc_real i.iso3c_F
est store m4

*note: we have to add df_m and df_c to get the used degrees of freedom,
*results differ from R's logLik command

esttab m1 using "C:\GitHub\mlm-teaching\exercises\stata_extras\m1.csv", replace r2 ar2 aic scalars(ll df_c df_m) not

esttab m2 using "C:\GitHub\mlm-teaching\exercises\stata_extras\m2.csv", replace r2 ar2 aic scalars(ll df_c df_m) not ///
transform(ln*: exp(2*@) 2*exp(2*@)) ///
eqlabels("" "var(Residual)" "var(_cons)" , none)

esttab m3 using "C:\GitHub\mlm-teaching\exercises\stata_extras\m3.csv", replace r2 ar2 aic scalars(ll df_c df_m) not ///
transform(ln*: exp(2*@) 2*exp(2*@)) ///
eqlabels("" "var(inc_real)" "var(Residual)" "var(_cons)" , none)

esttab m4 using "C:\GitHub\mlm-teaching\exercises\stata_extras\m4.csv", replace r2 ar2 aic scalars(ll df_c df_m) not

*Stata has a built in model comparison, but it cannot compare ols and mixed models
lrtest m1 m2

*Thus, as far as I know, we have to do it by hand (not all shown here)
*compare m1 and m2
di "Prob > chi2 = "chi2tail(2, -2*(-481279.5 - -461997.2))
*compare m2 and m4
di "Prob > chi2 = "chi2tail(79, -2*( -464978.2 - -464699.1))

*compare m2 and m4, using the results obtained in R, very similar despite the minor output differences
di "Prob > chi2 = "chi2tail(80, -2*( -464986 - -464699))
