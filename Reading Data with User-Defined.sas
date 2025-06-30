/*********************************************Reading Data with User-Defined*********************
INFORMATS*****************************************************************************************/

/***Reading a combination of character and numeric data***/

*A traditional approach to reading a combination
of character and numeric data;
data Temperatures;
 input Dummy $ @@;
 if upcase(Dummy) = 'N' then Temp = 98.6;
 else Temp = input(Dummy,8.);
 if Temp gt 106 or Temp lt 96 then Temp = .;
 drop Dummy;
 datalines;
 101 N 97.3 111 n N 104.5 85
;

*Using an enhanced numeric informat to read
a combination of character and numeric data;
proc format;
 invalue readtemp(upcase)
 96 - 106 = _same_
 'N' = 98.6
 other = .;
run;

data Temperatures;
 input Temp : readtemp5. @@;
 datalines;
 101 N 97.3 111 n N 67 104.5 85
;
