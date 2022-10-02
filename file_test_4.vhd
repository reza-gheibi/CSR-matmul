----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:06:43 07/20/2021 
-- Design Name: 
-- Module Name:    file_test_4 - Behavioral 
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

entity file_test_4 is
end file_test_4;

architecture Behavioral of file_test_4 is

   type mem is array (8 downto 0) of std_logic_vector(2 downto 0);
	signal t_mem : mem;

begin
    


process

   file mif_file : text open read_mode is "input_vectors.txt";
   variable mif_line : line;
	variable temp_bv : bit_vector(2 downto 0); 
	variable i: integer;
	 
 begin
 
   file_open(mif_file, "C:\Users\Reza\Desktop\input_vectors.txt",READ_MODE);
	
	i:=0;
	while (not EndFile (mif_file)) loop
   			readline (mif_file, mif_line);
	   		read(mif_line, temp_bv);
				t_mem (i)<= to_unsigned(to_integer(std_logic_vector(temp_bv)), 3);
				i:=i+1;
				wait for 1 ns;
	end loop;
	File_Close (mif_file); 
		 
   readline(mif_file, mif_line);
   read(mif_line, temp_bv);
	wait;

 end process;
end Behavioral;

