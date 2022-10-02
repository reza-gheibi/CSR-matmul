----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:38:09 07/19/2021 
-- Design Name: 
-- Module Name:    file_test_2 - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity file_test_2 is
end file_test_2;

architecture Behavioral of file_test_2 is


type info_bits_pos_t is array(0 to 1) of integer range 0 to n_encoded_bits-1;

impure function get_info_bits_pos(info_bits_file : string) return info_bits_pos_t is

	--file     m_file : text open read_mode is info_bits_file;
	variable m_line : line;
	variable m_data : integer;
	variable ibp    : info_bits_pos_t;

begin
	for i in ibp'range loop
		assert not endfile(m_file) report "" severity failure;

		readline(m_file, m_line);
		read(m_line, m_data);

		ibp(i) := m_data;

	end loop;
	assert endfile(m_file) report "" severity warning;

	return ibp;
end function;

begin
process
begin
end process;
end Behavioral;

