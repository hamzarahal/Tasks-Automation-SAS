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

/***Using a MODIFY statement to update a master file from a
transaction file***/

*Using a MODIFY statement to update a master file from a transaction file;

data Hardware;
 modify Hardware New_Prices;
run;

/***Updating several variables using a transaction file created with
an INPUT method called named input***/

*Using named input to create a transaction data set
*Use "Named Input" method to create the transaction data set;

data New_Values;
informat Gender $6. Party $10. DOB Date9.;
input Subj= Score= Weight= Heart_Rate= DOB= Gender= Party=;
format DOB date9.;
datalines;
Subj=2 Score=72 Party=Republican
Subj=7 DOB=26Nov1951 Weight=140
;

*Updating a master file using a transaction file created with named input
proc sort data=Demographic;

by Subj;
run;
proc sort data=New_Values;
by Subj;
run;
Data Demographic_June2012;
update Demographic New_Values;
by Subj;
run;