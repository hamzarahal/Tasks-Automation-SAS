/**********************Creating Formats from SAS Data Sets***************************************/
/************************************************************************************************/

/***Using a SAS data set to create a format (by creating a control
data set)***/

*Program to create a control data set from a SAS data set;

data codes;
   input ICD9 : $5. Description & $21.;
datalines;
020 Plague
022 Anthrax
390 Rheumatic fever
410 Myocardial infarction
493 Asthma
540 Appendicitis
;

data Control;
  set Codes(rename=
  (ICD9 = Start
   Description = Label));
  retain Fmtname '$ICDFMT'
   Type 'C';
run;