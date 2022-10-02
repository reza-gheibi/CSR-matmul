--MATRIXMUL//////////
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use std.textio.all;
	 
	
	
entity MatMul is
	 		PORT (
						a, b	: IN std_logic;
						c		: OUT std_logic 
	 				);
end MatMul;

architecture MatrixMachine of MatMul is

	file results : text;
	 type memory is array(0 to 4, 0 to 4) of integer;
	--This Function reads a matrix from the file
	function InitRamFromFile (RamFileName : in string) return memory is
		FILE RamFile : text is in RamFileName;
		variable RamFileLine : line;
		variable mat : memory;
	BEGIN
			for i in memory'range loop
				readline (RamFile, RamFileLine);
				for j in memory'range loop
					read (RamFileLine, mat(i,j));
				end loop;
			end loop;	
		return mat;
	end function;
	


	signal mat1 : memory := InitRamFromFile("mat1.txt");
	signal mat2 : memory := InitRamFromFile("mat2.txt");
	signal mat3 : memory ;
	
--Begin of Arch
BEGIN

	Multiply : 
	PROCESS (a)
		variable sum, temp : INTEGER :=0;			
	BEGIN
		for i in memory'range loop
			for j in memory'range loop
				mat3(i,j) <= 0;
				for k in memory'range loop
					mat3(i,j) <= mat3(i,j) + (mat1(i,k)* mat2(k,j));
				end loop;
			end loop;
		end loop;					
	END PROCESS Multiply;
	
						
END MatrixMachine;

