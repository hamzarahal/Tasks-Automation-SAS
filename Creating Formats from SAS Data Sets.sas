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

/***Adding new format values to an existing format***/

*Adding new formats to an existing format using a CNTLOUT data set;
proc format cntlout=Control_Out;
  select $icdfmt;
run;
data New_control;
  length Label $ 25;
  set Control_Out(drop=End) end=Last;
  output;
   if Last then do;
   Hlo = ' ';
   Start = '427.5';
   Label = 'Cardiac Arrest';
   output;
    Start = '466';
    Label = 'Bronchitis - nonspecific';
   output;
  end;
run;

proc format cntlin=New_control;
  select $ICDFMT;
run;