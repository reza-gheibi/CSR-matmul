library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use std.textio.all;	
	 

	
entity TwoArch is
	 		PORT (
						a, b	: IN std_logic;
						c		: OUT std_logic 
	 				);
end TwoArch;


architecture MatrixMachine of TwoArch is

	file read_file, results : text;
	type memory is array(integer range <>,integer range <>) of integer;
	type Res is array (integer range <>)of integer;
	constant Len : integer := 9;
	signal status0, status1  : Integer := 1; 				--signals for sensitivity list for process
	signal status2, status3 : Integer:= 0; 	
	shared variable mat1, mat2, myMat : memory(0 to Len, 0 to Len);
	shared variable Row, Col, R1 : integer;	
	shared variable rng1 : integer := 0;	
	shared variable rng2 : integer := 1;
	shared variable RamFileLine, line_v : line;


	--This function reads a matrix from the file
	impure function InitRamFromFile (RamFileName : in string; rowBeg : in integer) return memory is --; colBeg: in integer; rowEnd : in integer; colEnd: in integer) return memory is
		FILE RamFile : text is in RamFileName;
		variable mat : memory(0 to Len, 0 to Len);
	BEGIN
			for i in 0 to rowBeg-1 loop
				readline(RamFile, RamFileLine);
			end loop;
			for i in 0 to Row-1 loop
				readline (RamFile, RamFileLine);
				for j in 0 to Col-1 loop
					read (RamFileLine, mat(i,j));
				end loop;
			end loop;	
		return mat;
	end function;	
	
	--This function calculates a vector matrix multiplication
	impure function VectCal(rng : in integer) return Res is 
		variable r : Res(0 to 0);
	BEGIN
			for i in 0 to Col loop
				myMat(rng,i) := 0;
				for j in 0 to Row loop
					myMat(rng,i) := myMat(rng,i) + (mat1(rng,j)*mat2(j,i));
				end loop; --End for j
			end loop; --End for i
		return r;
	end function;	
		
	--Begin of Arch
	BEGIN
		
		ReadMatrices: PROCESS (status0) is
			variable rowBeg :INTEGER ;
		BEGIN
			rowBeg:=1;															--c:=1;
			file_open(read_file, "mat1.txt", read_mode);
			readline(read_file, line_v);
			read(line_v, Row);
			read(line_v, Col); 												--rEnd:=dim(0)+1; --cEnd:=dim(1)+1;
			R1 := Row;
			mat1 := InitRamFromFile("mat1.txt", rowBeg);
			rowBeg:=rowBeg+Row;
			for i in 0 to Row-1 loop
				readline(read_file, line_v);								--move the line till second matrix
			end loop;
			readline(read_file, line_v);
			rowBeg:=rowBeg+1;
			read(line_v, Row);
			read(line_v, Col);
			mat2 := InitRamFromFile("mat1.txt", rowBeg);
			file_close(read_file);
			status1 <= 1;
		END PROCESS ReadMatrices;	
		
		ProcessGenerator: for i in 0 to 5 GENERATE
			VectorMul : PROCESS (status1) IS
				variable temp : Res(0 to 0);
			BEGIN
					temp := VectCal(i);
			END PROCESS VectorMul;
		END GENERATE;

END MatrixMachine;


architecture SecondArch of TwoArch is
	signal status5 : Integer:= 0;
begin
	
		status5 <= 7;
end SecondArch;