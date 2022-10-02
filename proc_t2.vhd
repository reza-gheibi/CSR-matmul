
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use ieee.math_real.all;
 
ENTITY proc_t2 IS
END proc_t2;
 
ARCHITECTURE behavior OF proc_t2 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT proc_test2
    PORT(
         clk : IN  std_logic;
         input : IN  std_logic;
			--reset  : IN   STD_LOGIC;
			reset  : IN   INTEGER;
         output1, output2 : INOUT  INTEGER--STD_LOGIC_VECTOR(0 to 1000)
        );
    END COMPONENT;
    
   --Inputs
   signal clk : std_logic := '0';
   signal input : std_logic := '0';
	--signal reset : std_logic := '0';
	signal reset : INTEGER := 1;
	
 	--Outputs
   signal output1, output2 : INTEGER := 0;--STD_LOGIC_VECTOR(0 to 1000);

   -- Clock period definitions
   constant clk_period : time := 1000 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: proc_test2 PORT MAP (
          clk => clk,
          input => input,
			 reset => reset,
			 --reset1 => reset1,
          output1 => output1,
			 output2 => output2
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/4;
		clk <= '1';
		wait for clk_period/4;
   end process;

   -- Stimulus process
   stim_proc: process
   begin	
		--reset1 <= '1';
		input <= '1';
      reset <= 0;
      wait;
   end process;

END;
