/*********************************Summarizing Data************************************************/
/*************************************************************************************************/

/**Computing the mean of all observations and outputting it to a SAS data set**/

*Program to create the Blood_Pressure data set;
data blood_pressure;
   call streaminit(37373);
   do Drug = 'Placebo','Drug A','Drug B';
      do i = 1 to 20;
         Subj + 1;
         if mod(Subj,2) then Gender = 'M';
         else Gender = 'F';
         SBP = rand('normal',130,10) +
               7*(Drug eq 'Placebo') - 6*(Drug eq 'Drug B')
               + (rand('uniform') lt .2)*(rand('normal',0,30));
         SBP = round(SBP,2);
         DBP = rand('normal',80,5) +
               3*(Drug eq 'Placebo') - 2*(Drug eq 'Drug B')
               + (rand('uniform') lt .2)*(rand('normal',0,30));
         DBP = round(DBP,2);
         if Subj in (5,15,25,55) then call missing(SBP, DBP);
         if Subj in (4,18) then call missing(Gender);
         Heart_Rate = int(rand('normal',70,20) 
                       + 5*(Gender='M') 
                       - 8*(Drug eq 'Drug B'));
         if Subj in (2,8) then call missing(Heart_Rate);
         output;
      end;
   end;
   drop i;
run;

*Computing the mean of all observations and outputting it to a
SAS data set;
proc means data=Blood_Pressure noprint;
var Heart_Rate;
output out=Summary(keep=Mean_HR) mean=Mean_HR;
run;

**Computing the mean of a variable broken down by values of
another variable: Using a BY variable;

*Computing the mean for each value of a BY variable;
proc sort data=Blood_Pressure;
by Drug;
run;
proc means data=Blood_Pressure noprint;
by Drug;
var Heart_Rate;
output out=Summary mean=Mean_HR;
run;

**Computing the mean of a variable broken down by values of
another variable: Using a CLASS statement;

*Using PROC MEANS to create a summary data set;
proc means data=Blood_Pressure noprint;
class Drug;
var Heart_Rate;
output out=Summary mean=Mean_HR;
run;

**Have PROC MEANS name the variables in the output data set
automatically (the AUTONAME option);

*Demonstrating the AUTONAME option;
proc means data=Blood_Pressure noprint nway;
class Drug;
var Heart_Rate;
output out=Summary(drop=_type_ _freq_)
n= mean= min= max= / autoname;
run;

/*** Computing the mean of a variable broken down by values of
another variable: Using a BY variable ***/

*Computing the mean for each value of a BY variable;
proc sort data=Blood_Pressure;
  by Drug;
run;
proc means data=Blood_Pressure noprint;
  by Drug;
  var Heart_Rate;
  output out=Summary mean=Mean_HR;
run;

/***Computing the mean of a variable broken down by values of
another variable: Using a CLASS statement***/

*Using PROC MEANS to create a summary data set;
proc means data=Blood_Pressure noprint;
  class Drug;
  var Heart_Rate;
  output out=Summary mean=Mean_HR;
run;

/***Have PROC MEANS name the variables in the output data set
automatically (the AUTONAME option)***/

*Demonstrating the AUTONAME option;
proc means data=Blood_Pressure noprint nway;
  class Drug;
  var Heart_Rate;
  output out=Summary(drop=_type_ _freq_)
  n= mean= min= max= / autoname;
run;

/***Creating multiple output data sets from PROC MEANS, each
with a different combination of CLASS variables***/

*Demonstrating the CHARTYPE procedure option;
proc means data=Blood_Pressure noprint chartype;
  class Drug Gender;
  var Heart_Rate;
  output out=Summary mean=Mean_HR;
run;

*Using the _TYPE_ variable to send summary data to separate data sets;

data Grand(drop=Drug Gender)
 ByGender(drop=Drug)
 ByDrug(drop=Gender)
 ByDrugGender;
 drop _type_ _freq_;
 set Summary;
 if _type_ = '00' then output Grand;
 else if _type_ = '01' then output ByGender;
 else if _type_ = '10' then output ByDrug;
 else if _type_ = '11' then output ByDrugGender;
run;

/***Combining summary information (a single mean) with detail
data: Using a conditional SET statement***/

*Program to compare each person's heart rate with the mean heart
rate of all the observations;
proc means data=Blood_Pressure noprint;
  var Heart_Rate;
  output out=Summary(keep=Mean_HR) mean=Mean_HR;
run;

*Demonstrating a conditional SET statement (to combine summary data with detail data);
data Percent_of_Mean;
 set Blood_Pressure(keep=Heart_Rate Subj);
 if _n_ = 1 then set Summary;
 Percent = round(100*(Heart_Rate / Mean_HR));
run;

/***Combining summary information (a single mean) with detail
data: Using PROC SQL***/

*Solution using PROC SQL;
proc sql;
 create table Percent_of_Mean as
 select Subj,Heart_Rate,Mean_HR
 from Blood_Pressure, Summary;
quit;

/***Combining summary information (a single mean) with detail
data: Using PROC SQL without using PROC MEANS***/

*PROC SQL solution not using PROC MEANS;
proc sql;
 create table Percent_of_Mean as
 select Subj,Heart_Rate, round(100*Heart_Rate / mean(Heart_Rate))
 as Percent
 from Blood_Pressure;
quit;

/***Combining summary information (a single mean) with detail
data: Using a macro variable***/

Combining summary information with detail data using a macro variable
*Solution using a macro variable;
data _null_;
 set summary;
 call symputx('Macro_Mean',Mean_HR);
run;

*Using PROC SQL to create the macro variable;

proc sql noprint;
 select mean(Heart_Rate)
 into :Macro_Mean
 from Blood_Pressure;
quit;

*Demonstrating how to use a macro variable in a DATA step;
data Percent_of_Mean;
 set Blood_Pressure(keep=Heart_Rate Subj);
 Percent = round(100*(Heart_Rate / &Macro_Mean));
run;

/***Combining summary data with detail data—for each category of
a BY variable***/

*Program to compare each person's heart
rate with the mean heart rate for each
value of Gender;
proc means data=Blood_Pressure noprint nway;
 class Gender;
 var Heart_Rate;
 output out=By_Gender(keep=Gender Mean_HR) mean=Mean_HR;
run;

*Combining summary data with detail data for each category of a BY variable;

proc sort data=Blood_Pressure;
 by Gender;
run;

data Percent_of_Mean;
 merge Blood_Pressure(keep=Heart_Rate Gender Subj) By_Gender;
 by Gender;
 Percent = round(100*(Heart_Rate / Mean_HR));
run;
*Put the observations back in Subj order;
proc sort data=Percent_of_Mean;
 by Subj;
run;


