Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

Entity addern is
	generic (width : integer := 8);
	port (A,B : in std_logic_vector (width-1 downto 0);
			Y : out std_logic_vector (width-1 downto 0));
end addern;

ARCHITECTURE bhv of addern is
	begin
	  Y <= A + B;
End bhv;

Library IEEE;
use IEEE.std_logic_1164.all;


Entity top is
  port (X, Y, Z : in std_logic_vector (12 downto 0);
		A, B : in std_logic_vector (4 downto 0);
		S :out std_logic_vector (16 downto 0) );
End top;

ARCHITECTURE bhv of top is
  
  component addern
	 generic (width : integer := 8);
	 port (A,B : in std_logic_vector (width-1 downto 0);
		  Y : out std_logic_vector (width-1 downto 0));
  end component;

  for all : addern use entity work.addern(bhv);
  signal C1 : std_logic_vector (12 downto 0);
  signal C2, C3 : std_logic_vector (16 downto 0);
  
BEGIN

  U1 : addern generic map (n=>13) port map (X,Y,C1);
  C2 <= C1 & A;
  C3 <= Z & B;
  U2 : addern generic map (n=>17) port map (C2,C3,S);

END bhv;