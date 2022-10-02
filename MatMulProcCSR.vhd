--MATRIXMUL//////////
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use std.textio.all;	
	 
	
entity MatMulProcCSR is
	 		PORT (
						a, b	: IN std_logic;
						c		: OUT std_logic 
	 				);
end MatMulProcCSR;


architecture MatrixMachine of MatMulProcCSR is

	file read_file, results : text;
	type memory is array(integer range <>,integer range <>) of integer;
	type Res is array (integer range <>)of integer;
	constant Len : integer := 9;
	signal status0, status1 : bit; 				--signals for sensitivity list for process
	shared variable mat1, mat2, myMat : memory(0 to Len, 0 to Len);
	shared variable mat1_CSR, mat2_CSR : memory(0 to Len*Len/4, 0 to 2);--assuming % of sparsity
	shared variable Row, Col, R1, R2, C1, C2 : integer;	
	shared variable size1,size2,rng1, s0 : integer := 0;	
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
			if(i<Col) then
				myMat(rng,i) := 0;
				for j in 0 to Row loop
					myMat(rng,i) := myMat(rng,i) + (mat1(rng,j)*mat2(j,i));
				end loop; --End for j
			end if; 	--End if (fixes the last 0 on MyMat cols)
		end loop; --End for i
		return r;
	end function;
	
	--This function provides the size of the CSR format
	impure function CSRSize  return Res is 
		variable r : Res(0 to 0);
	BEGIN
		for i in 0 to R1-1 loop
			for j in 0 to C1-1 loop
				if(mat1(i,j) /= 0) then
					size1 := size1 +1;
				end if;
			end loop;--End for j
		end loop;--End for i
		for i in 0 to R2-1 loop
			for j in 0 to C2-1 loop
				if(mat2(i,j) /= 0) then
					size2 := size2 + 1;
				end if;
			end loop;--End for j
		end loop;--End for i	
		return r;
	end function;
	
	--This function creates a CSR representation of matrix
	impure function CSR(sel : in integer) return Res is 
		variable r : Res(0 to 0);
		variable k : integer;
	BEGIN
		case sel is -- creates CSR for matrix 1 or 2 based on sel value
		when 1 =>
			k :=0;
			for i in 0 to R1-1 loop
				for j in 0 to C1-1 loop
					if(mat1(i,j) /= 0) then
						mat1_CSR(k,0) := i;			  --Row
						mat1_CSR(k,1) := j;			  --Col
						mat1_CSR(k,2) := mat1(i,j); --value
						k := k+1;--k goes from 0 to size
					end if;
				end loop;--End for j
			end loop;--End for i	
		when 2 =>
			k :=0;
			for i in 0 to R2-1 loop
				for j in 0 to C2-1 loop
					if(mat2(i,j) /= 0) then
						mat2_CSR(k,0) := i;			  --Row
						mat2_CSR(k,1) := j;			  --Col
						mat2_CSR(k,2) := mat2(i,j); --value
						k := k+1;--k goes from 0 to size
					end if;
				end loop;--End for j
			end loop;--End for i	
		end case; -- End switch case
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
			C1 := Col;
			mat1 := InitRamFromFile("mat1.txt", rowBeg);
			rowBeg:=rowBeg+Row;
			for i in 0 to Row-1 loop
				readline(read_file, line_v);								--move the line till second matrix
			end loop;
			readline(read_file, line_v);
			rowBeg:=rowBeg+1;
			read(line_v, Row);
			read(line_v, Col);
			R2 := Row;
			C2 := Col;
			mat2 := InitRamFromFile("mat1.txt", rowBeg);
			file_close(read_file);
			s0 := 1;		-- set variable s0 to one for CSRSize Process
			--status1 <= '1';
		END PROCESS ReadMatrices;
				
		VectorMul_even : PROCESS (status1) is
			variable temp : Res(0 to 0);
		BEGIN
			while (rng1 < R1) loop
				temp := VectCal(rng1);
				rng1 := rng1 + 2;
			end loop;
		END PROCESS VectorMul_even;
	
		VectorMul_odd : PROCESS (status1) is
			variable temp : Res(0 to 0);
		BEGIN
			while (rng2 < R1) loop
				temp := VectCal(rng2);
				rng2 := rng2 + 2;
			end loop;
		END PROCESS VectorMul_odd;
	
		CallCSR_Size : PROCESS (status1) is
			variable temp : Res(0 to 0);
		BEGIN
			temp := CSRSize; 					--CSRSize finds the required size for CSR 
		END PROCESS CallCSR_Size;
		
		CallCSR_mat1 : PROCESS (status1) is
			variable temp : Res(0 to 0);
		BEGIN
			if (s0 = 1) then
				temp := CSR(1);	  -- Calls CSR func to do Create CSR format matrix
			end if;
		END PROCESS CallCSR_mat1;
		
		CallCSR_mat2 : PROCESS (status1) is
			variable temp : Res(0 to 0);
		BEGIN
			if (s0 = 1) then
				temp := CSR(2);	  -- Calls CSR func to do Create CSR format matrix
			end if;
		END PROCESS CallCSR_mat2;
		
--		CallCSRMatMul : PROCESS (status1) is
--			variable Size : Res(0 to 0);
--		BEGIN
--			Size := CSRMatMul(); --CSR matrix multiplication
--		END PROCESS CallCSRMatMul;
--	

END MatrixMachine;

