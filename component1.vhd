
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity component1 is
end component1;


architecture Example of component1 is

component XOR_4 is
   port(A,B: in BIT_VECTOR(0 to 3);
   C: out BIT_VECTOR(0 to 3));
end component XOR_4;

signal S1,S2, S3, S4 : BIT_VECTOR(0 to 3);
signal P1, P2 : BIT_VECTOR(0 to 3);

begin
   X1 : XOR_4 port map(S1,S2,P1);
	X2 : XOR_4 port map(S3,S4,P2);
end architecture Example;