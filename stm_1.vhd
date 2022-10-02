library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity stm_1 is
	PORT( trigger   : IN   INTEGER);
end stm_1;

ARCHITECTURE SM_ART OF stm_1 IS
	SIGNAL status, status1 : INTEGER ;
	SIGNAL val_1, val_2, total : INTEGER := 0;
	
BEGIN

   COUNTER: PROCESS (status)
		   variable val1, val2 : integer :=0;
		BEGIN
			IF (status = 0) THEN
				val_1 <= val_1+1;
				val1 := val1 + 1;
				status <= 1;
				--status1 <= 0;
			ELSE 
				val_2 <= val_2+1;
				val2 := val2 + 1;
				status <= 0;
				--status1 <= 1;
			END IF;
			--status1 <= 1;
		END PROCESS COUNTER;
		
	SecondPROCESS: PROCESS (status1)
		BEGIN
			IF (status1 = 0) THEN
				total <= total+1;
				status1 <= 1;
			ELSE 
				total <= total+1;
				status1 <= 0;
			END IF;	
		END PROCESS SecondPROCESS;

END SM_ART;
