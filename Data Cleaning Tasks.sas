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