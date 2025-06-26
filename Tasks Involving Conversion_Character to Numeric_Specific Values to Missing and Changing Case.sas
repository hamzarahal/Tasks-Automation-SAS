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

/***Converting a specific value such as 999 to a missing value for all
numeric variables in a SAS data set***/

data Demographic;
   call streaminit(374354);
   do Subj = 1 to 20;
      if rand('uniform') ge .1 then Score = ceil(rand('uniform')*100);
      else Score = 999;
      if rand('uniform') ge .1 then Weight = ceil(rand('normal',150,30));
      else Weight = 999;
      if rand('uniform') ge .1 then Heart_Rate = ceil(rand('normal',70,10));
      else Heart_Rate = 999;
      DOB = -3652 + ceil(rand('uniform')*2190);
      if rand('uniform') gt .5 then Gender = 'Female';
      else Gender = 'Male';
      if rand('uniform') lt .2 then Gender = 'NA';
      if rand('uniform') ge .8 then Gender = lowcase(Gender);
      if rand('uniform') gt .6 then Party = 'Republican';
      else Party = 'Democrat';
      if rand('uniform') lt .2 then Party = 'NA';
      if rand('uniform') gt .5 then Party = lowcase(Party);
      output;
   end;
   format DOB date9.;
run;

*Converting a specific value such as 999 to a missing value for
all numeric variables in a SAS data set;
data Num_missing;
  set Demographic;
  array Nums[*] _numeric_;
  do i = 1 to dim(Nums);
    if Nums[i] = 999 then Nums[i] = .;
  end;
  drop i;
run;

/***Converting a specific value such as 'NA' to a missing value for
all character variables in a SAS data set***/

*Converting a specific value such as "NA" to a missing value for all
character variables in a SAS data set;
data Char_missing;
  set Demographic;
  array Chars[*] _character_;
  do i = 1 to dim(Chars);
   if Chars[i] in ('NA' 'na') then Chars[i] = ' ';
   end;
  drop i;
run;

/***Changing all character values to either uppercase, lowercase, or
proper case***/

*Converting all character values to uppercase (or lower- or propercase);
data Upper;
  set Demographic;
  array Chars[*] _character_;
  do i = 1 to dim(Chars);
   Chars[i] = upcase(Chars[i]);
  end;
   drop i;
run;

/***Reading a numeric value that contains units such as Lbs. or
Kgs. in the value***/

*Reading data values that contain units;
data No_Units;
  set Units;
  Weight_Lbs = input(compress(Weight,,'kd'),12.);
  if findc(Weight,'k','i') then Weight_lbs = Weight_lbs*2.2;
  Height = compress(Height,,'kds');
  Feet = input(scan(Height,1,' '),12.);
  Inches = input(scan(Height,2,' '),12.);
  if missing(Inches) then Inches = 0;
  Height_Inches = 12*Feet + Inches;
  drop Feet Inches;
run;

/***Solving part of the previous task using a Perl regular expression***/

*Solution using Perl Regular expressions;
data No_Units;
  set Units(drop=Height);
  if _n_ = 1 then do;
  Regex = "/^(\d+)(\D)/";
  re = prxparse(Regex);
  end;
  retain re;
  if prxmatch(re,Weight) then do;
   Weight_Lbs = input(prxposn(re,1,Weight),8.);
   Units = prxposn(re,2,Weight);
   if upcase(Units) = 'K' then Weight_Lbs = Weight_Lbs*2.2;
  end;
  keep Subj Weight Weight_Lbs;
run;
