/*************************Tasks Involving Multiple Observations
per Subject**********************************************/

/***Using PROC SORT to detect duplicate BY values or duplicate
observations (records)***/
*Data set Duplicates to demonstrate ways of identifying
 duplicate records and duplicate BY variables;
data Duplicates;
   input @1  Subj   $3.
         @4  Gender $1.
         @5  Age     3.
         @8  Height  2.
         @10 Weight  3.;
datalines;
001M 2363122
002F 4459109
002F 4459109
003M 8767200
004F10053112
004F 5059201
005M 4569188
;
*Demonstrating the NODUPKEY option of PROC SORT;
*Using PROC SORT to detect duplicate BY values;
proc sort data=Duplicates out=Sorted nodupkey;
by Subj;
run;

*Fixing the problem with the NODUPRECS option;
*Possible solution to the problem;
proc sort data=Multiple out=Features noduprecs;
by _all_;
run;

/***Task: Extracting the first and last observation in a BY group***/

Demonstrating First. and Last. variables
proc sort data=Duplicates out=Sorted_Duplicates;
by Subj;
run;
data _null_;
 set Sorted_Duplicates;
 by Subj;
 put Subj= First.Subj= Last.Subj=;
run;

/***Detecting duplicate BY values using a DATA step***/

*Detecting duplicate BY values using a DATA step
*Using a DATA step to detect duplicate BY values;
proc sort data=Duplicates out=Sorted_Duplicates;
 by Subj;
run;
data Dups;
 set Sorted_Duplicates;
 by Subj;
if first.Subj and last.Subj then delete;
run;

/***Identifying observations with exactly 'n' observations per subject***/

*Identifying subjects who have exactly two observations;
proc sort data=Two_Records;
by Subj;
run;
data Not_Two;
set Two_Records;
by subj;
if first.Subj then n=0;
n + 1;
if last.Subj and n ne 2 then output;
run;

/***Computing differences between observations (for each subject)***/

*Computing inter-patient differences;
proc sort data=Visits;
 by Patient Visit;
run;

data Difference;
 set Visits;
 by Patient;
 Diff_Wt = Weight - lag(Weight);
 if not first.Patient then output;
run;
