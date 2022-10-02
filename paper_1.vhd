--MATRIXMUL//////////
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use std.textio.all;	
	 
	
entity paper_1 is
	 		PORT (
						a, b	: IN std_logic;
						c		: OUT std_logic 
	 				);
end paper_1;


architecture Multiplication of paper_1 is

	file read_file : text;
	type memory is array(integer range <>,integer range <>) of integer;
	type Res is array (integer range <>)of integer;
	constant n : integer := 9;--4;
	constant m : integer := 9;--5;
	signal status0, status1  : Integer := 1; 				--signals for sensitivity list for process
	signal status2, status3 : Integer:= 0; 	
	shared variable mat : memory(0 to n, 0 to m);
	--shared variable X, Y, results: Res(0 to m);
	shared variable X, Y, results, ResultVect, row_index, col_index, value, row_length : Res(0 to (n+1)*(m+1));
	shared variable Row, Col, R1 : integer;	
	shared variable indx, rng1 , nnz: integer := 0;	
	shared variable rng2 : integer := 1;
	shared variable RamFileLine, RamFileLine2, line_v, line_v2 : line;


	--This function reads a matrix from the file
	impure function InitRamFromFile (RamFileName : in string; rowBeg : in integer) return memory is --; colBeg: in integer; rowEnd : in integer; colEnd: in integer) return memory is
		FILE RamFile : text is in RamFileName;
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
	
	
	--This Reads the dense vector X
	procedure ReadVect(RamFileName : in string)  is 
		FILE RamFile : text is in RamFileName;
	BEGIN
			--row_length(0) := 0;
			readline (RamFile, RamFileLine);
			for i in 0 to m loop
				read (RamFileLine, X(i));
			end loop; --End for i
			file_close(read_file);
	end ReadVect;	

	
--	--This function calculates a vector matrix multiplication
--	impure function SpMV(rng : in integer) return Res is 
--		variable r : Res(0 to 0);
--	BEGIN
--			for i in 0 to Col loop
--				myMat(rng,i) := 0;
--				for j in 0 to Row loop
--					myMat(rng,i) := myMat(rng,i) + (mat1(rng,j)*mat2(j,i));
--				end loop; --End for j
--			end loop; --End for i
--		return r;
--	end function;	
	
	--This function calculates CSR
	procedure CSR(rng1 : in integer)  is 
		variable r, k, c, z : integer := 0;
	BEGIN
			row_index(0) := z;
			for i in 0 to row-1 loop
				for j in 0 to col-1 loop
					if (mat(i,j) /= 0) then
						--row_index(k) := i;
						col_index(k) := j;
						value(k) := mat(i,j);
						k := k+1;
						c := c+1;
						z := z+1;
						nnz := nnz+1;
					end if;
				end loop; --End for j
				row_index(i+1) := z;
				row_length(i) := c;
				c := 0;
			end loop; --End for i
	end CSR;	
	
	
	--This function calculates a vector matrix multiplication
	procedure SpMV(rng : in integer) is 
		variable k, y0, l1, l2 : integer := 0;
	BEGIN
			for i in 0 to row-1 loop
				y0 := 0;
				--l1 := row_index(i);
				--l2 := row_index(i+1);
				--for j in 2 to 3 loop
				for j in row_index(i) to row_index(i+1)-1 loop
					--if (row_index(i) /= row_index(i+1)) then
						k := col_index(j);
						y0 := y0 + (value(j) * X(k));
					--end if;
				end loop; --End for j
				Y(i) := y0;
			end loop; --End for i
	end SpMV;	
	
	
	--This function calculates the Modified CSR (MCSR) SpMV
	procedure MCSR_SpMV(rng : in integer) is 
		--variable nnz: integer := 7;
		variable k, z, c, col_left, col, term, sum : integer := 0;
	BEGIN	
			col_left := 0;--row_length(k);
			for r in 0 to nnz loop 
				if (col_left = 0 ) then
					col_left := row_length(k);
					sum :=0;
					k := k+1;
				end if;
				if (col_left > 0 ) then
					col := col_index(c);
					term := value(c) * X(col);
					sum := sum + term;
					c := c+1;
					--term := 0;
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
			--results(z) := sum;
	end MCSR_SpMV;
	
	--This function calculates the Modified CSR (MCSR) SpMV Row*DenseVect
	procedure MCSR_RowVect(RowDeg : in integer; RowInd : in integer) is 
	variable col, term, sum : integer := 0;
	BEGIN
			for i in 0 to RowDeg-1 loop
				col := col_index(indx);
				term := value(indx) * X(col);
				sum := sum + term;
				indx := indx+1;
				ResultVect(RowInd) := sum;
			end loop; --End for loop
			--store the ith row*vec result to coresponding row in the final vector
			--ResultVect(RowInd) := sum;
	end MCSR_RowVect;		
	
	--Begin of Arch
	BEGIN
		
		ReadMatrices: PROCESS (status0) is
			variable rowBeg, deg :INTEGER ;
		BEGIN
			rowBeg:=1;															--c:=1;
			file_open(read_file, "SparseMat_10by10.txt", read_mode);
			readline(read_file, line_v);
			read(line_v, Row);
			read(line_v, Col); 												--rEnd:=dim(0)+1; --cEnd:=dim(1)+1;
			R1 := Row;
			mat := InitRamFromFile("SparseMat_10by10.txt", rowBeg);
			file_close(read_file);
			--Calling procedure to read the dense vector
			ReadVect("DenseVect_10.txt");
			--Calling procedure to create CSR format of the matrix
			CSR(1);
			--Calling procedure to do sparse matrix vector multiplication
			SpMV(1);
			--Calling procedure to do Spmv on Modified CSR format
			MCSR_Spmv(1);
			--Calling procedure to do Spmv on Modified CSR format row by row
			for i in 0 to row_length'length loop
				deg := row_length(i);
				if (deg = 0) then
					ResultVect(i) := 0;
				else
				MCSR_RowVect(deg, i);
				end if;
			end loop;
		END PROCESS ReadMatrices;	
		
--		ProcessGenerator: for i in 0 to 5 GENERATE
--			VectorMul : PROCESS (status0) IS
--				variable temp : Res(0 to 0);
--			BEGIN
--					temp := SpMV(i);
--			END PROCESS VectorMul;
--		END GENERATE;

END Multiplication;


--impure function 
--A function that can read or write any signal within its scope, 
--also those that are not on the parameter list. 
--We say that the function has side effects. 
--What we mean by side effects is that it is not guaranteed 
--that the function will return the same value 
--every time it is called with the same parameters.
--Pure function will always return the same value with the same given parameters,
-- whereas an impure function may not.
--The value returned by an impure function can depend on 
--items other than just its input parameters (e.g.shared variables).
--
--Functions can be either pure (which is default) or impure. 
--Pure functions always return the same value for the same set of actual parameters. 
--Impure functions may return different values for the same set of parameters. 
--Additionally, an impure function may have „side effects”, like updating objects 
--outside of their scope, which is not allowed for pure functions.