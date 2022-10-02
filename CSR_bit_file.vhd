----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:28:30 06/22/2021 
-- Design Name: 
-- Module Name:    CSR_bit - Behavioral 
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
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use std.textio.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CSR_bit_file is
end CSR_bit_file;

architecture Behavioral of CSR_bit_file is
 
	
	-- define a file type of text to write the output
	file results : text;
	--type RamType is array(0 to 15) of bit_vector(2 downto 0);
	type RamType is array(0 to 15, 0 to 1) of integer;
	
	impure function InitRamFromFile (RamFileName : in string) return RamType is
		FILE RamFile : text is in RamFileName;
		variable RamFileLine : line;
		variable edgelist : RamType;
	begin
			for i in RamType'range loop
				--for j in 0 to 1 loop
					readline (RamFile, RamFileLine);
					read (RamFileLine, edgelist(i,0));
					read (RamFileLine, edgelist(i,1));
					--read (RamFileLine, RAM(j));
				--end loop;
			end loop;
		return edgelist;
	end function;

	--signal RAM : RamType := InitRamFromFile("input_vectors.txt");
	signal edgelist : RamType := InitRamFromFile("int_numbers.txt");


	--signal and memory declaration for graph data (edges, degree, node number, ...)
	type memory is array(0 to 15, 0 to 1) of unsigned(31 downto 0);
	type memory2 is array(0 to 15) of unsigned(31 downto 0);
	type memory3 is array(0 to 15) of integer ;
	type memory4 is array(0 to 15) of std_logic_vector(31 downto 0);
	
	--signal edgelist : RAM;
	signal deglist, nodelist_rm_duplicate : memory2;
	--signal comp_bitseq : unsigned(127 downto 0);
	--signal comp_bitseq : unsigned(127 downto 0) := (others=>'0'); --comp_bitseq_temp,
	signal comp_bitseq : bit_vector (126 downto 0);
	signal comp_int_list : memory3;
	signal comp_unsigned_list : memory2;
	signal comp_std : memory4;
	
	--Begining of the Architecture
begin
	
	process
		--variable declaration
		variable deg_cntr, tt, c, sign, sign2, dg, dg_down, sum, 
					rnge, reminder: integer := 0;
		variable x1 : integer := 2;
		variable x,num_bits, highest_node_num, largest_num, remain,
					total_bit_req, bitseq_len: integer;
		variable len : integer := 32;
	
	--process begins here
	begin
	 
	 x := deglist'right;
	 
	 nodelist_rm_duplicate(edgelist(0,0))<= to_unsigned(edgelist(0,0), len);
	 tt:=edgelist(0,0)+1;
	 
	 for i in 0 to deglist'right loop
		for j in 0 to deglist'right loop
			if (i = edgelist(j,0)) then
				deg_cntr := deg_cntr+1;
			end if;
			wait for 5 ns;--why i need wait
		end loop;
		if (i<(deglist'right)) then
			if (edgelist(i,0)/=edgelist(i+1,0)) then
				nodelist_rm_duplicate(tt)<= to_unsigned(edgelist(i+1,0), len);
				tt :=tt+1;
			end if;
		end if;
		deglist(i)<= to_unsigned(deg_cntr, len);
		deg_cntr:=0;
	end loop;
	
	--wait for 5 ns;	
		
	--find and store the largest node number in order to 
	--be able to start from node 0 to this node
	highest_node_num := to_integer(nodelist_rm_duplicate(0));
	for i in 0 to nodelist_rm_duplicate'right loop
			if (highest_node_num < to_integer(nodelist_rm_duplicate(i))) then
				highest_node_num := to_integer(nodelist_rm_duplicate(i));
			end if;
			wait for 5 ns;
	end loop;
	
	
	--find and store the largest number in the edgelist to get maxbits
	largest_num := edgelist(0,0);
	for i in 0 to 1 loop
		for j in 0 to deglist'right loop
			if (largest_num < edgelist(j,i)) then
				largest_num := edgelist(j,i);
			end if;
			wait for 5 ns;
		end loop;
	end loop;
	
	--wait for 5 ns;
		
	--find #of bits of the maximum number inorder to assign it to all numbers	
	remain := largest_num; 
   while remain > 0 loop  -- Iteration for each bit required
      reminder := reminder + 1;
		wait for 5 ns;
      remain := remain / 2;
   end loop;
	num_bits := reminder;
	
	--wait for 5 ns;

	
	total_bit_req := (((highest_node_num + 1) * 2) + (deglist'left+1))*4; 
	
	--c:=comp_bitseq_temp'left;
	
	for i in 0 to highest_node_num loop
		--comp_bitseq (i*4 to (i+1)*4) <= 
		--comp_bitseq_temp <= comp_bitseq_temp (comp_bitseq_temp'left downto num_bits-1) & nodelist_rm_duplicate(i)(num_bits-1 downto 0);
		--comp_bitseq <= comp_bitseq_temp sll num_bits+1;
		--comp_bitseq_temp (num_bits-1 downto 0) <= comp_bitseq_temp (num_bits-1 downto 0) or deglist(i)(num_bits-1 downto 0);
		--comp_bitseq <= comp_bitseq_temp sll num_bits+1;
		comp_bitseq ((c+1)*num_bits-1 downto c*num_bits) <= to_bitvector(std_logic_vector(nodelist_rm_duplicate(i)(num_bits-1 downto 0)));
		c:= c+1;
		comp_bitseq ((c+1)*num_bits-1 downto c*num_bits) <= to_bitvector(std_logic_vector(deglist(i)(num_bits-1 downto 0)));
		c:= c+1;
		--wait for 5 ns;
		for j in 0 to deglist'right loop
			if (to_integer(nodelist_rm_duplicate(i)) = edgelist(j,0)) then
				--comp_bitseq_temp (num_bits-1 downto 0) <= comp_bitseq_temp (num_bits-1 downto 0) or edgelist(1,j)(num_bits-1 downto 0);
				--comp_bitseq <= comp_bitseq_temp sll num_bits;
				--sign := to_integer(edgelist(0,j));
				--sign2:= to_integer(nodelist_rm_duplicate(i));
				--c:= c+1;
				comp_bitseq ((c+1)*num_bits-1 downto c*num_bits) <= to_bitvector(std_logic_vector(to_unsigned(edgelist(j,1), len)(num_bits-1 downto 0)));
				c:= c+1;
			end if;
			--wait for 5 ns;
		end loop;
	end loop;
	
	--0-4   1*2		128-124	128 - 128-(i*4)
	--4-8   2*4		124-120	128-(i*4) - 128-((i+1)*4) 
	--8-12  3*4
	
	-- 3 downto 0		i=0	
	-- 7 downto 4		i=1
	-- 11 downto 8  	i=2
	wait for 1 ns;	
	rnge := total_bit_req / 32 ;
	bitseq_len := comp_bitseq'length;
	

	
	for i in 0 to rnge loop
		--comp_int_list(i) <= to_integer(to_unsigned(comp_bitseq((i+1)*len -1 downto len*i), bitseq_len));
		comp_std(i) <=     to_stdlogicvector(comp_bitseq((i+1)*len -1 downto len*i));
		--comp_int_list(i) <=  to_integer(comp_std(i));
		wait for 1 ns;
		comp_int_list(i) <= to_integer(unsigned(comp_std(i)));
		--wait for 1 ns;
	end loop;
	
	--report "The value of 'int' is " & integer'image(comp_int_list(i));
	
	--creating the compacted bit sequence (node#,degree,edgess)
	--each has the #of bits of biggest node number in edgelist
	--for i in nodelist_rm_duplicate'range loop 
	
	--wait;
	wait for 1 ns;
	end process;--end of first process



  -- write to a file with another process

	process
		variable txtline : line;
		variable file_status : file_open_status;
	begin
		file_open (file_status, results, "output.txt", write_mode);
		for i in 0 to comp_std'right loop
			--for j in 0 to 1 loop
			write (txtline, comp_std(i));
			writeline (results, txtline);
		end loop;
		file_close(results);
		
				file_open (file_status, results, "output2.txt", write_mode);
		for i in 0 to comp_int_list'right loop
			--for j in 0 to 1 loop
			write (txtline, comp_int_list(i));
			writeline (results, txtline);
		end loop;
		file_close(results);
		
    wait for 1 ns;
	end process;
	
	
end Behavioral;

