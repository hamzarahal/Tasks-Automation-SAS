/**********************************Data Cleaning Tasks****************************************/
/***********************************************************************************************/

/***Looking for possible data errors using a given range***/

title "Listing of Patient Numbers and Invalid Data Values";
 data _null_;
 set Blood_Pressure;
 file print;
 ***Check Heart_Rate;
 if (Heart_Rate lt 40 and not missing(Heart_Rate)) or
 Heart_Rate gt 100 then put Subj= @10 Heart_Rate=;
 ***Check SBP;
 if (SBP lt 80 and not missing(SBP)) or
 SBP gt 200 then put Subj= @10 SBP=;
 ***Check DBP;
 if (DBP lt 60 and not missing(DBP)) or
 DBP gt 120 then put Subj= @10 DBP=;
run;

/***Demonstrating a macro to report on outliers using fixed ranges***/

*Macro to perform range checking for numeric variables;
%macro Errors(Var=, /* Variable to test */
Low=, /* Low value */
High=, /* High value */
Missing=IGNORE
/* How to treat missing values */
/* Ignore is the default. To flag */
/* missing values as errors set */
/* Missing=error */);
data Tmp;
set &Dsn(keep=&Idvar &Var);
length Reason $ 10 Variable $ 32;
Variable = "&Var";
Value = &Var;
if &Var lt &Low and not missing(&Var) then do;
Reason='Low';
output;
end;
%if %upcase(&Missing) ne IGNORE %then %do;
else if missing(&Var) then do;
Reason='Missing';
output;
end;
%end;
else if &Var gt &High then do;
Reason='High';
output;
end;
drop &Var;
run;
proc append base=Errors data=Tmp;
run;
%mend errors;

*Macro to generate an error report after the errors macro has been run;

%macro report;
proc sort data=errors;
by &Idvar;
run;
proc print data=errors;
title "Error Report for Data Set &Dsn";
id &Idvar;
var Variable Value Reason;
run;
proc datasets library=work nolist;
delete errors;
delete tmp;
run;
quit;
%mend report;

*Test the macro;
%let Dsn = Blood_Pressure;
%let Idvar = Subj;
%errors(Var=Heart_Rate, Low=40, High=100, Missing=error)
%errors(Var=SBP, Low=80, High=200, Missing=ignore)
%errors(Var=DBP, Low=60, High=120, Missing=ignore)
%report;

*Demonstrating a macro that performs automatic outlier
detection;

%macro Auto_Outliers(
Dsn=, /* Data set name */
ID=, /* Name of ID variable */
Var_list=, /* List of variables to check */
/* separate names with spaces */
Trim=.1, /* Integer 0 to n = number to trim */
/* from each tail; if between 0 and .5, */
/* proportion to trim in each tail */
N_sd=2 /* Number of standard deviations */);
ods listing close;
ods output TrimmedMeans=Trimmed(keep=VarName Mean Stdmean DF);
proc univariate data=&Dsn trim=&Trim;
var &Var_list;
run;
ods output close;
data Restructure;
set &Dsn;
length Varname $ 32;
array vars[*] &Var_list;
do i = 1 to dim(vars);
Varname = vname(vars[i]);
Value = vars[i];
output;
end;
keep &ID Varname Value;
run;
proc sort data=trimmed;
by Varname;
run;
proc sort data=restructure;
by Varname;
run;
data Outliers;
merge Restructure Trimmed;
by Varname;
Std = StdMean*sqrt(DF + 1);
if Value lt Mean - &N_sd*Std and not missing(Value)
then do;
Reason = 'Low ';
output;
end;
else if Value gt Mean + &N_sd*Std
then do;
Reason = 'High';
output;
end;
run;
proc sort data=Outliers;
by &ID;
run;
ods listing;
title "Outliers Based on Trimmed Statistics";
proc print data=Outliers;
id &ID;
var Varname Value Reason;
run;
proc datasets nolist library=work;
delete Trimmed;
delete Restructure;
run;
quit;
%mend auto_outliers;

