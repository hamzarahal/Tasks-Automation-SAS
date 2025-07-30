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

*Attempting to combine data sets with character variables
of different lengths using the FORCE option;
proc append base=Name2 data=Name3 force;
run;

/***Developing a macro to concatenate two SAS data sets that
contain character variables of different lengths***/

*Using PROC CONTENTS to output a data set of character variable storage lengths;

proc contents data=Name2 noprint
out=Out1(keep=Name Type Length where=(Type=2));
run;
proc contents data=Name3 noprint
out=Out2(keep=Name Type Length where=(Type=2));
run;

*Using a DATA step to write out a SAS program to an external file;

data _null_;
merge Out1
Out2(rename=(Length=Length2))
end=last;
by Name;
file "c:\books\tasks\Combined.sas";
/* Step 1 */
if _n_ = 1 then put "Data Combined;";
/* Step 2 */
L = max(Length,Length2);
/* Step 3 */
put " length " Name " $ " L 3. ";";
/* Step 4 */
if Last then do;
put " set Name1 Name2;";
put "run;";
end;
run;
/* Step 5 */
%include "combined.sas";

/***Updating a SAS data set using a transaction data set***/

Data New_Prices;
input Item_Number : $4. Price;
datalines;
2002 5.98
4006 16.98
;

proc sort data=Hardware;
by Item_Number;
run;
proc sort data=New_Prices;
by Item_Number;
run;

Data Hardware_June2012;
update Hardware New_Prices;
by Item_Number;
run;

