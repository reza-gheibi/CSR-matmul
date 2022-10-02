library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


ENTITY componentRAM is
--	generic((
--		 data_width : integer := 64;
--		 addr_width : integer := 12); 
--	port(
--		 data : in std_logic_vector(data_width-1 downto 0);
--		 addr : in std_logic_vector(addr_width-1 downto 0));
END componentRAM;

architecture Behavioral of componentRAM is
	component RAM is
		generic(
		 data_width : integer := 64;
		 addr_width : integer := 12); 
		port(
		 data : in std_logic_vector(data_width-1 downto 0);
		 addr : in std_logic_vector(addr_width-1 downto 0));
	end component RAM;
	signal data, addr :std_logic_vector(data_width-1 downto 0);
	--signal data_width, addr_width : integer;
BEGIN
	RAM1 : RAM generic map(
	 data_width => 32,
	 addr_width => 20)
	port map(
	 data => data ,
	 addr => addr );
	 
	RAM2 : RAM port map(
	 data => data ,
	 addr => addr );
 
END Behavioral;

