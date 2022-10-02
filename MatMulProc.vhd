--MATRIXMUL//////////
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use std.textio.all;	
	 
	
entity MatMulProc is
	 		PORT (
						a, b	: IN std_logic;
						c		: OUT std_logic 
	 				);
end MatMulProc;

architecture MatrixMachine of MatMulProc is

	file read_file, results : text;
	type memory is array(0 to 4, 0 to 4) of integer;
	signal status, status1, status2 : bit := '0';				--signals for sensitivity list for process
	shared variable mat1, mat2, myMat : memory;
	shared variable Row, Col : integer;								
	shared variable RamFileLine, line_v : line;


	--This Function reads a matrix from the file
	impure function InitRamFromFile (RamFileName : in string; rowBeg : in integer) return memory is --; colBeg: in integer; rowEnd : in integer; colEnd: in integer) return memory is
		FILE RamFile : text is in RamFileName;
		variable mat : memory;
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
	

	--Begin of Arch
	BEGIN

		status <= '1';
		ReadMatrix1: PROCESS (status) is									--variable dim : INT_ARRAY;--row and col
			variable rowBeg : INTEGER;
		BEGIN
			rowBeg:=1;															--c:=1;
			file_open(read_file, "mat1.txt", read_mode);
			readline(read_file, line_v);
			read(line_v, Row);
			read(line_v, Col); 												--rEnd:=dim(0)+1; --cEnd:=dim(1)+1;
			mat1 := InitRamFromFile("mat1.txt", rowBeg);				--, c, rEnd, cEnd);
			file_close(read_file);
			status1 <= status;
		END PROCESS ReadMatrix1;
		
		ReadMatrix2: PROCESS (status1) is								--variable line_v : line; --file read_file : text; --variable dim : INT_ARRAY;--row and col
			variable rowBeg :INTEGER; 										--1, r2, c1, c2 : INTEGER;
		BEGIN
			rowBeg:=Row+1;														--r1:=rEnd+2; --c1:=cEnd+2;
			file_open(read_file, "mat1.txt", read_mode);
			for i in 0 to rowBeg loop
				readline(read_file, line_v);
			end loop;
			read(line_v, Row);
			read(line_v, Col); 												--read(line_v, dim(0), dim(1)); --r2:=dim(0)+r1; --c2:=dim(1)+c1;
			mat2 := InitRamFromFile("mat1.txt", rowBeg+1);			--r1, c1, r2, c2);
			file_close(read_file);
			status2 <= status1;
		END PROCESS ReadMatrix2;
		
		Multiply : PROCESS (status2) is
			variable sum, temp : INTEGER :=0;			
		BEGIN
			for i in memory'range loop
				for j in memory'range loop
					myMat(i,j):=0;
					for k in memory'range loop
								myMat(i,j) := myMat(i,j) + (mat1(i,k)* mat2(k,j));
					end loop; --End for k
				end loop; --End for j
			end loop; -- end for i					
		END PROCESS Multiply;
		
END MatrixMachine;

