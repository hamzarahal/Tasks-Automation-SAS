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