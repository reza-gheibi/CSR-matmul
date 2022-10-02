library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use std.textio.all;



entity read_file_seperator_2 is
end read_file_seperator_2;

architecture Behavioral of read_file_seperator_2 is



	--type RamType is array(0 to 15) of bit_vector(2 downto 0);
	type RamType is array(0 to 15, 0 to 1) of integer;
	
	impure function InitRamFromFile (RamFileName : in string) return RamType is
		FILE RamFile : text is in RamFileName;
		variable RamFileLine : line;
		variable RAM : RamType;
	begin
			for i in RamType'range loop
				--for j in 0 to 1 loop
					readline (RamFile, RamFileLine);
					read (RamFileLine, RAM(i,0));
					read (RamFileLine, RAM(i,1));
					--read (RamFileLine, RAM(j));
				--end loop;
			end loop;
		return RAM;
	end function;

--signal RAM : RamType := InitRamFromFile("input_vectors.txt");
signal RAM : RamType := InitRamFromFile("int_numbers.txt");


begin 

end Behavioral;

