/**********************************Table Lookup Techniques*********************************/
/******************************************************************************************/

/***Performing a one-way table lookup using a MERGE statement ***/

*Data set GOALS, containing the sales goals for the years
 2004 through 2012;
data Goals;
   do Year = 2004 to 2012;
      input Goal @;
      output;
   end;
datalines;
20 21 24 28 34 40 49 60 75
;

*Data set GOALS_JOB, containing the sales goals for the years
 2004 through 2012 for each of 4 job categories;
data Goals_Job;
   do Year = 2004 to 2012;
      do Job = 1 to 4;
         input Goal @;
         output;
      end;
   end;
datalines;
20 21 24 28 34 40 49 60 75
21 22 25 30 40 45 55 67 82
24 27 29 37 45 51 62 74 90
30 38 40 47 53 60 70 80 99
;


*Using a MERGE to perform a table lookup;

proc sort data=Goals;
by Year;
run;
proc sort data=Sales;
by Year;
run;
data Sales_Goals;
merge Goals Sales;
by Year;
Difference = Sales - Goal;
run;
proc sort data=Sales_Goals;
by Sales_ID Year;
run;

/***Performing a one-way table lookup using user-defined informats***/

*Creating the INFORMAT "manually" using PROC FORMAT;
proc format;
invalue Goalfmt 2004=20
2005=21
2006=24
2007=28
2008=34
2009=40
2010=49
2011=60
2012=75;
run;

*Using the informat to perform the table lookup;

data Sales_Goals;
set Sales;
Goal = input(put(Year,4.),goalfmt.);
Difference = Sales - Goal;
run;

/***Creating an INFORMAT using a control data set***/

*Creating the INFORMAT using a CNTLIN data set;
data Control;
 set Goals(rename=(Year=Start Goal=Label));
retain Fmtname '@goalfmt' Type 'I';
run;

proc format cntlin=Control;
 select @goalfmt;
run;

/***Performing a one-way table lookup using a temporary array***/

*Load a temporary with the Goals data;
data Sales_Goals;
array Goalsarray[2004:2012] _temporary_;
if _n_ = 1 then do Year = 2004 to 2012;
set Goals;
goalsarray[Year] = Goal;
end;
set Sales;
Difference = Sales - Goalsarray[Year];
run;

/***Performing a two-way table lookup using a temporary array***/

*Twoway table lookup using temporary arrays;
data Two_Way;
 array Goals_Job[2004:2012,4] _temporary_;
  if _n_ = 1 then do Year = 2004 to 2012;
 do Job = 1 to 4;
 set Goals_Job;
 Goals_Job[Year,Job] = Goal;
 end;
 end;
 set Sales_Job;
 drop Goal Job;
 Difference = Sales - Goals_Job[Year,Job];
run;