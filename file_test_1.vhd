----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:55:36 07/19/2021 
-- Design Name: 
-- Module Name:    file_test - Behavioral 
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
use std.textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity file_test_1 is
end file_test_1;

architecture Behavioral of file_test_1 is

begin

process is
    variable line_v : line;
    file read_file : text;
    file write_file : text;
    variable slv_v : std_logic_vector(2 downto 0);
  begin
    file_open(read_file, "source.txt", read_mode);
    file_open(write_file, "target.txt", write_mode);
    while not endfile(read_file) loop
      readline(read_file, line_v);
      hread(line_v, slv_v);
      report "slv_v: " & to_hstring(slv_v);
      hwrite(line_v, slv_v);
      writeline(write_file, line_v);
    end loop;
    file_close(read_file);
    file_close(write_file);
    wait;
	 
  end process;
  
end Behavioral;

