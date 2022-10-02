LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use ieee.math_real.all;
 
ENTITY ST1 IS
END ST1;
 
ARCHITECTURE behavior OF ST1 IS 
   
	COMPONENT stm_1
		PORT(trigger  : IN   INTEGER);
   END COMPONENT;

	signal trigger : INTEGER := 0;
   constant clk_period : time := 100 us;
	
 
BEGIN
   uut: stm_1 PORT MAP (
			 trigger => trigger
        );

   INIT : PROCESS
		BEGIN
			--trigger <= 0;
			--wait for clk_period/10;
			--trigger <= 1;
			--wait for clk_period/10;
		END PROCESS;

END;