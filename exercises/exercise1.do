import delimited using "C:/GitHub/mlm-teaching/data/df.csv"

* Empty multilevel model
mixed a170 || iso3c:

* Create matrix of results 

** estat returns the SD
estat sd

** save SD in a matrix
matrix mix r(b)

** once in matrix format we can calculate by hand
di mix[1,2]^2/(mix[1,2]^2+mix[1,3]^2)

** stata all allows output of ICC 
mixed a170 || iso3c:
estat icc




