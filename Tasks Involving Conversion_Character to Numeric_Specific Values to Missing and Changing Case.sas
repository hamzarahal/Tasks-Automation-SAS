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

