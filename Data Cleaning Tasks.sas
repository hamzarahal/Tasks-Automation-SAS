/**********************************Data Cleaning Tasks****************************************/
/***********************************************************************************************/

/***Looking for possible data errors using a given range***/

title "Listing of Patient Numbers and Invalid Data Values";
 data _null_;
 set Blood_Pressure;
 file print;
 ***Check Heart_Rate;
 if (Heart_Rate lt 40 and not missing(Heart_Rate)) or
 Heart_Rate gt 100 then put Subj= @10 Heart_Rate=;
 ***Check SBP;
 if (SBP lt 80 and not missing(SBP)) or
 SBP gt 200 then put Subj= @10 SBP=;
 ***Check DBP;
 if (DBP lt 60 and not missing(DBP)) or
 DBP gt 120 then put Subj= @10 DBP=;
run;