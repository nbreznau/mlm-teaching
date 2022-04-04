* Encoding: UTF-8.
GET DATA  /TYPE=TXT
  /FILE="C:\GitHub\mlm-teaching\data\df.csv"
  /ENCODING='UTF8'
  /DELCASE=LINE
  /DELIMITERS=","
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /DATATYPEMIN PERCENTAGE=95.0
  /VARIABLES=
  iso3c A3
  year AUTO
  A170 AUTO
  C006 AUTO
  A190 AUTO
  X047_WVS AUTO
  X001 AUTO
  X003 AUTO
  X025R AUTO
  impinc AUTO
  e_gdppc AUTO
  
*Calculate life satisfaction ICC
 *Empty model gives within and between variance.
MIXED A170
 /PRINT = DESCRIPTIVES SOLUTION
 /FIXED = INTERCEPT 
 /RANDOM = INTERCEPT | SUBJECT(iso3c).



