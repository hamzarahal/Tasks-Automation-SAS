/** ***********************Restructuring (Transposing)SAS Data Sets***************************************/
/***********************************************************************************************************/

/***Converting a data set with one observation per subject into one
with multiple observations per subject (using a DATA step)***/

*One observation per subject to several observations per subject
Data step approach;

data oneper;
   input Subj : $3. Dx1-Dx3;
datalines;
001     450    430    410
002     250    240      .
003     410    250    500
004     240      .      .
;

data ManyPer;
 set OnePer;
  array Dx[3];
  do Visit = 1 to 3;
  if not missing(Dx[Visit]) then do;
  Diagnosis = Dx[Visit];
   output;
  end;
 end;
 keep Subj Diagnosis Visit;
run;