--LIBRARY--////////////////////////////////////////
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use std.textio.all;






--ENTITY--////////////////////////////////////////
entity CSR_optimize is
		
end CSR_optimize;







--BEHAVIORAL--////////////////////////////////////
architecture Behavioral of CSR_optimize is

	-- define a file type of text to write the output
	file results : text;
	--type RamType is array(0 to 15) of bit_vector(2 downto 0);
	type RamType is array(0 to 15, 0 to 1) of integer;
	
	--type RamType is array(0 to 15) of bit_vector(2 downto 0);
	type Memory is array(0 to 15) of std_logic_vector(31 downto 0);
	
	
	impure function InitRamFromFile (RamFileName : in string) return RamType is
		FILE RamFile : text is in RamFileName;
		variable RamFileLine : line;
		variable edgelist : RamType;
	begin
			for i in RamType'range loop
				--for j in 0 to 1 loop
					readline (RamFile, RamFileLine);
					read (RamFileLine, edgelist(i,0));
					read (RamFileLine, edgelist(i,1));
					--read (RamFileLine, RAM(j));
				--end loop;
			end loop;
		return edgelist;
	end function;

	--signal RAM : RamType := InitRamFromFile("input_vectors.txt");
	signal edgelist : RamType := InitRamFromFile("int_numbers.txt");
	
--begining of arch
begin

		process
			--variable declaration
			variable deg_cntr, tt, c, sign, sign2, dg, dg_down, sum, 
						rnge, reminder: integer := 0;
			variable x1 : integer := 2;
			variable x,num_bits, highest_node_num, largest_num, remain,
						total_bit_req, bitseq_len: integer;
			variable len : integer := 32;
	
		--process begins here
		begin
	 

			--find number of bits required for the largest node number on the edgelist
			remain := edgelist'right; 
			while remain > 0 loop  -- Iteration for each bit required
				reminder := reminder + 1;
				wait for 5 ns;
				remain := remain / 2;
			end loop;
			num_bits := reminder;
	
			
			--find degress for each node
			for i in 0 to edgelist'right loop
				
			
			end loop;
			
			
			x := edgelist'right;
			
		
		end process;

end Behavioral;

