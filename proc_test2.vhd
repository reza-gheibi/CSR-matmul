library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity proc_test2 is
	PORT( clk      : IN   STD_LOGIC;
			input    : IN   STD_LOGIC;
			reset    : IN   INTEGER;
			--reset1	: IN 	INTEGER;
			output1, output2   : INOUT  INTEGER );
end proc_test2;

ARCHITECTURE StateMachine OF proc_test2 IS
   --TYPE STATE_TYPE IS (s0, s1);
   --SIGNAL state   : STATE_TYPE;
	SIGNAL reset1 : INTEGER ;--:= 1;
BEGIN
   STATES: PROCESS (reset)
   BEGIN
		IF (reset = 1) THEN
			--state <= s0;
			reset1 <= 0;
		ELSE
--			CASE state IS
--            WHEN s0=>
--					IF input = '1' THEN
--						state <= s1;
--					ELSE
--						state <= s0;
--					END IF;
--				WHEN s1=>
--					IF input = '1' THEN
--						state <= s0;
--					ELSE
--						state <= s1;
--					END IF;
--			END CASE;
			reset1 <= 1;
			--state <= s1;
		END IF;
   END PROCESS STATES;
   
   COUNTER: PROCESS (reset1)
   BEGIN
		if (output1 < 10) then
			output1 <= output1+1;
		end if;
		if (output2 < 100) then
			output2 <= output2+1;
		end if;		
   END PROCESS COUNTER;
   
END StateMachine;
