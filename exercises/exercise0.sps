* Encoding: UTF-8.
GET DATA  /TYPE=TXT
  /FILE="C:/GitHub/mlm-teaching/data/df.csv"
  /ENCODING='UTF8'
  /DELCASE=LINE
  /DELIMITERS=","
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /DATATYPEMIN PERCENTAGE=60.0
  /VARIABLES=
  iso3c A3
  year F4
  A170 f2
  C006 F2
  A190 F2
  X047_WVS F2
  X001 F2
  X003 F2
  X025R F2
  impinc F8.3
  e_gdppc F8.2

  
* SPSS does not like the "NA" values
*Need to change LEVEL to get rid of them and make correct variable types
    
VARIABLE LEVEL iso3c (NOMINAL) year to e_gdppc (SCALE)
  
* Define Variable Properties.
*iso3c.
* Labels are necessary for filtering

VALUE LABELS iso3c
  'ALB' 'ALB'
  'AND' 'AND'
  'ARG' 'ARG'
  'ARM' 'ARM'
  'AUS' 'AUS'
  'AZE' 'AZE'
  'BFA' 'BFA'
  'BGD' 'BGD'
  'BGR' 'BGR'
  'BIH' 'BIH'
  'BLR' 'BLR'
  'BOL' 'BOL'
  'BRA' 'BRA'
  'CAN' 'CAN'
  'CHE' 'CHE'
  'CHL' 'CHL'
  'CHN' 'CHN'
  'COL' 'COL'
  'CYP' 'CYP'
  'CZE' 'CZE'
  'DEU' 'DEU'
  'DOM' 'DOM'
  'DZA' 'DZA'
  'ECU' 'ECU'
  'EGY' 'EGY'
  'ESP' 'ESP'
  'EST' 'EST'
  'ETH' 'ETH'
  'FIN' 'FIN'
  'FRA' 'FRA'
  'GBR' 'GBR'
  'GEO' 'GEO'
  'GHA' 'GHA'
  'GRC' 'GRC'
  'GTM' 'GTM'
  'HKG' 'HKG'
  'HRV' 'HRV'
  'HTI' 'HTI'
  'HUN' 'HUN'
  'IDN' 'IDN'
  'IND' 'IND'
  'IRN' 'IRN'
  'IRQ' 'IRQ'
  'ISR' 'ISR'
  'ITA' 'ITA'
  'JOR' 'JOR'
  'JPN' 'JPN'
  'KAZ' 'KAZ'
  'KEN' 'KEN'
  'KGZ' 'KGZ'
  'KOR' 'KOR'
  'KWT' 'KWT'
  'LBN' 'LBN'
  'LBY' 'LBY'
  'LTU' 'LTU'
  'LVA' 'LVA'
  'MAC' 'MAC'
  'MAR' 'MAR'
  'MDA' 'MDA'
  'MEX' 'MEX'
  'MKD' 'MKD'
  'MLI' 'MLI'
  'MMR' 'MMR'
  'MNE' 'MNE'
  'MNG' 'MNG'
  'MYS' 'MYS'
  'NGA' 'NGA'
  'NIC' 'NIC'
  'NLD' 'NLD'
  'NOR' 'NOR'
  'NZL' 'NZL'
  'PAK' 'PAK'
  'PER' 'PER'
  'PHL' 'PHL'
  'POL' 'POL'
  'PRI' 'PRI'
  'PSE' 'PSE'
  'QAT' 'QAT'
  'ROU' 'ROU'
  'RUS' 'RUS'
  'RWA' 'RWA'
  'SAU' 'SAU'
  'SGP' 'SGP'
  'SLV' 'SLV'
  'SRB' 'SRB'
  'SVK' 'SVK'
  'SVN' 'SVN'
  'SWE' 'SWE'
  'THA' 'THA'
  'TJK' 'TJK'
  'TTO' 'TTO'
  'TUN' 'TUN'
  'TUR' 'TUR'
  'TWN' 'TWN'
  'TZA' 'TZA'
  'UGA' 'UGA'
  'UKR' 'UKR'
  'URY' 'URY'
  'USA' 'USA'
  'UZB' 'UZB'
  'VEN' 'VEN'
  'VNM' 'VNM'
  'YEM' 'YEM'
  'ZAF' 'ZAF'
  'ZMB' 'ZMB'
  'ZWE' 'ZWE'.
EXECUTE.

*Recode income

COMPUTE inc_real = impinc/1000

RECODE inc_real (60 thru 200 = 60)(else = copy) INTO inc_real

SAVE OUTFILE "C:/GitHub/mlm-teaching/data/df.sav"


