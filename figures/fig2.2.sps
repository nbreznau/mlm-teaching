* Encoding: UTF-8.
GET DATA "C:/GitHub/mlm-teaching/data/df.sav"
    
* Chart Builder.

*create filter for DEU KOR IDN MEX

RECODE iso3c (DEU KOR IDN MEX = 1)(else = .) INTO filter1

* top portion

GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=X047_WVS A170 iso3c MISSING=LISTWISE REPORTMISSING=NO 
    DATAFILTER=iso3c(VALUES='DEU' OR 'KOR' OR 'IDN' OR 'MEX' UNLABELED=INCLUDE) 
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: X047_WVS=col(source(s), name("X047_WVS"))
  DATA: A170=col(source(s), name("A170"))
  GUIDE: axis(dim(1), label("Income Category"))
  GUIDE: axis(dim(2), label("Life Satisfaction"))
  GUIDE: text.title(label("Scatter Plot of A170 by X047_WVS"))
  GUIDE: text.footnote(label("Filtered by iso3c variable"))
  ELEMENT: point.jitter(position(X047_WVS*A170), size(size."1"))
  ELEMENT: line( position( smooth.linear(X047_WVS*A170)), color.interior(color.black))
END GPL.

 *can also use this in GGRAPH command for fitted line
    */FITLINE TOTAL=YES SUBGROUP=NO.

  
