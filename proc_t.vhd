LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY proc_t IS
END proc_t;
 
ARCHITECTURE behavior OF proc_t IS 
  
    COMPONENT proc_test
    PORT(
         clk : IN  std_logic;
         input : IN  std_logic;
         reset : IN  std_logic;
         output : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;  

   --Inputs
   signal clk : std_logic := '0';
   signal input : std_logic := '0';
   signal reset : std_logic := '0';
 	--Outputs
   signal output : std_logic_vector(1 downto 0);
   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
	-- Instantiate the Unit Under Test (UUT)
   uut: proc_test PORT MAP (
          clk => clk,
          input => input,
          reset => reset,
          output => output);
		  
   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;

   -- Stimulus process
   stim_proc: process
   begin		
		reset <= '1';
		input <= '1';
      reset <= '0';
		
      wait;
   end process;
END;
