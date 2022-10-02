library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use std.textio.all;	
	 
	


entity track is
end track;

architecture Behavioral of track is


file read_file : text;
	type memory is array(integer range <>,integer range <>) of integer;
	type Res is array (integer range <>)of integer;
	constant n : integer := 3;
	constant m : integer := 4;
	signal status0, status1  : Integer := 1; 				--signals for sensitivity list for process
	signal status2, status3 : Integer:= 0; 	
	shared variable mat : memory(0 to n, 0 to m);
	shared variable X, Y, results: Res(0 to m);
	shared variable row_index, col_index, value, row_length : Res(0 to (n+1)*(m+1));
	shared variable Row, Col, R1 : integer;	
	shared variable rng1 : integer := 0;	
	shared variable rng2 : integer := 1;
	shared variable RamFileLine, RamFileLine2, line_v, line_v2 : line;


--This function calculates the Modified CSR (MCSR) SpMV
	procedure MCSR_SpMV(rng : in integer) is 
		variable nnz: integer := 6;
		variable k, z, col_left, col, term, sum : integer := 0;
	BEGIN	
			col_left := 0;--row_length(k);
			for i in 0 to nnz-1 loop 
				if (col_left = 0 ) then
					col_left := row_length(k);
					sum :=0;
					k := k+1;
				end if;
				if (col_left /= 0 ) then
					col := col_index(i);
					term := value(i) * X(col);
					sum := sum + term;
					term := 0;
					col_left := col_left - 1;
				end if;	
				if (col_left = 0 ) then
						results(z) := sum;
						z := z+1;
						--col_left := row_length(k+1);
						--k := k+1;
					--end if;
				end if;
				--k := k+1;
			end loop; --End for i
	end MCSR_SpMV;
	
	
--Arch begins here	
begin


	MCSR_Spmv(1);
	

end Behavioral;

