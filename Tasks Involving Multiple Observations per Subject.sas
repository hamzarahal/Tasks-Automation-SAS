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