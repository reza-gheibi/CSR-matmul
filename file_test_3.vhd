----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:42:51 07/19/2021 
-- Design Name: 
-- Module Name:    file_test_3 - Behavioral 
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
use ieee.numeric_std.all;
use std.textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity file_test_3 is
		port(address : in	  std_logic_vector(3 downto 0);
		     dataout : out  std_logic_vector(3 downto 0));
end file_test_3;



architecture Behavioral of file_test_3 is

	type mem is array (15 downto 0) of std_logic_vector(3 downto 0);
	signal t_mem : mem;
	
begin
	
		process (address)
			file f : TEXT;
			constant filename : string := "D:/output.txt";
			variable L : line;
			variable i : integer :=0;
			variable b : std_logic_vector(3 downto 0);
		
		begin
			
			file_open(f, filename, read_mode);
			while((i<=15) and (not endfile(f))) loop
				readline(f,l);
				next when l(1)='#';
				read(1,b);
				t_mem(i) <= b;
				i := i+1;
			end loop;
			
			file_close(f);
			dataout<= t_mem(to_integer(address));
			
		end process;
				

end Behavioral;

