/******************Tasks Involving Conversion: Character to Numeric, Specific Values to Missing,****
*******************************************and Changing Case*************************/

/***Converting character values to numeric values***/

*Program to create CHAR_VALUES Data Set;
data char_values;
   input Age : $3. Weight : $3. Gender : $1. DOB : mmddyy10.;
   format DOB mmddyy10.;
datalines;
23 150 M 10/21/1983
67 220 M 9/12/2001
77 101 F 5/6/1977
;
*Converting character values to numeric;
data Num_Values;
set Char_Values(rename=(Age = C_Age
Weight = C_Weight));
Age = input(C_Age,best12.);
Weight = input(C_Weight,best12.);
drop C_:;
run;

/***Converting character values to numeric values using a macro***/

*Macro to convert selected character variables to
numeric variables;
%macro char_to_num(In_dsn=, /*Name of the input data set*/
Out_dsn=, /*Name of the output data set*/
Var_list= /*List of character variables that you
want to convert from character to
numeric, separated by spaces*/);
/*Check for null var list */
%if &var_list ne %then %do;
/*Count the number of variables in the list */
%let n=%sysfunc(countw(&var_list));
data &Out_dsn;
set &In_dsn(rename=(
%do i = 1 %to &n;
/* break up list into variable names */
%let Var = %scan(&Var_list,&i);
/*Rename each variable name to C_ variable name */
&Var = C_&Var
%end;
));
%do i = 1 %to &n;
%let Var = %scan(&Var_list,&i);
&Var = input(C_&Var,best12.);
%end;
drop C_:;
run;
%end;
%mend char_to_num;
