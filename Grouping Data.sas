/**************************Grouping Data***********************/
/*************************************************************/

/***Grouping values using IF-THEN-ELSE statements***/

*Grouping values using if-then-else statements;

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

data Grouped;
length HR_Group $ 10.;
set Blood_Pressure(keep=Subj Heart_Rate);
if missing(Heart_Rate) then HR_Group = ' ';
else if Heart_Rate lt 40 then HR_Group = '<40';
else if Heart_Rate lt 60 then HR_Group = '40-<60';
else if Heart_Rate lt 80 then HR_Group = '60-<80';
else if Heart_Rate lt 100 then HR_Group = '80-<100';
else HR_Group = '100 +';
run;

