library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use std.textio.all;



entity test_to_read_file is
end test_to_read_file;

architecture Behavioral of test_to_read_file is



	type RamType is array(0 to 15) of bit_vector(2 downto 0);
	--type RamType is array(0 to 15) of integer;
	
	impure function InitRamFromFile (RamFileName : in string) return RamType is
		FILE RamFile : text is in RamFileName;
		variable RamFileLine : line;
		variable RAM : RamType;
	begin
			for I in RamType'range loop
				readline (RamFile, RamFileLine);
				read (RamFileLine, RAM(I));
				--read (RamFileLine, RAM(I));
			end loop;
		return RAM;
	end function;

signal RAM : RamType := InitRamFromFile("input_vectors.txt");
--signal RAM : RamType := InitRamFromFile("int_numbers.txt");


begin 

end Behavioral;

