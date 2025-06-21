/*************Combining and Updating SAS Data Sets*********************/
/**************************************************************************************/

/***Concatenating two SAS data sets—Using a SET statement***/

*Concatenating SAS data sets;
data Combined;
  set Name1 Name2;
run;

/***Concatenating two SAS data sets—Using PROC APPEND***/

*Method 2 - Using PROC APPEND;
proc append base=Name1 data=Name2;
run;

/***Concatenating two SAS data sets with character variables of
different lengths***/


