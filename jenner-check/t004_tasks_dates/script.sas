/************************Tasks Involving Dates****************************/
/*************************************************************************/

/***Computing a person’s age, given his or her date of birth***/

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

*Computing a person's age, given a date of birth;
data Compute_Age;
 set Demographic;
 Age_Exact = yrdif(DOB,'01jan2012'd);
 Age_Last_Birthday = int(Age_Exact);
run;

/***Computing a SAS date given a month, day, and year (even if the
day value is missing)***/

*Data set MoDayYear contains month, day and year data where
 the value of Day may be missing;
data MoDayYear;
   input Month Day Year;
datalines;
10 21 1955
6 . 1985
8 1 2001
9 . 2000
;

*Creating a SAS date when the day of the month may be missing;
data Compute_Date;
  set MoDayYear;
  if missing(Day) then Date = MDY(Month,15,Year);
  else Date = MDY(Month,Day,Year);
  format Date date9.;
run;

*Alternative (elegant) solution suggested by Mark Jordan;
data Compute_Date;
  set MoDayYear;
  Date = MDY(Month,coalesce(Day,15),Year);
  format Date date9.;
run;