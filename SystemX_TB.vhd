----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:15:16 07/19/2021 
-- Design Name: 
-- Module Name:    SystemX_TB - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_textio.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SystemX_TB is
end entity;



architecture Behavioral of SystemX_TB is

	constant t_delay : time := 10 ns;
	
	component SystemX is
		port(ABC : in std_logic_vector(2 downto 0);
			 F : out std_logic);
	end component;
	
	
	signal ABC_TB : std_logic_vectore(2 downto 0);
	signal F_TB	  : std_logic;

	
begin

	DUT : SystemX port map (ABC_TB, F_TB);

	STIMULUS :  process
	
	file Fin : TEXT open READ_MODE is "input_vectors.txt";
	
	variable current_read_line : line;
	variable current_read_field : std_logic_vector (2 downto 0); --read from the read_line
	-- tead_field vbariable datatype would be the one we like to read from file and convert to
	
	variable current_write_line : line;
	
	
	begin
	
	 --- TEst bench code ----
	 
	 
	 while (not endfile (Fin)) loop
	 
			readline(Fin, current_read_line);
			read(current_read_line, current_read_field);
			ABC_TB <= current_read_field;
			wait for 100 ns;
			
			--write
			write(current_write_line, string'("Input Vectore ABC_TB="));
			write(current_write_line, ABC_TB);
			write(current_write_line, string'(" Output F_TB="));
			write(current_write_line, F_TB);
			writeline(OUTPUT, current_write_line);
	 end loop;
	
	wait;
	
	end process;

end Behavioral;

