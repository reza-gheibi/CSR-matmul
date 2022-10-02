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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CSR_bit is
end CSR_bit;

architecture Behavioral of CSR_bit is
 
	--signal and memory declaration for graph data (edges, degree, node number, ...)
	type memory is array(1 downto 0, 7 downto 0) of unsigned(31 downto 0);
	type memory2 is array(7 downto 0) of unsigned(31 downto 0);
	type memory3 is array(7 downto 0) of integer ;
	type memory4 is array(7 downto 0) of std_logic_vector(31 downto 0);
	
	signal edgelist : memory;
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
	 
	 --initializing the edgelist
	 edgelist(0,0) <= to_unsigned(0, 32); edgelist(1,0) <= to_unsigned(5, 32);
	 edgelist(0,1) <= to_unsigned(1, 32); edgelist(1,1) <= to_unsigned(11, 32);
	 edgelist(0,2) <= to_unsigned(1, 32); edgelist(1,2) <= to_unsigned(8, 32);
	 edgelist(0,3) <= to_unsigned(1, 32); edgelist(1,3) <= to_unsigned(3, 32);
	 edgelist(0,4) <= to_unsigned(2, 32); edgelist(1,4) <= to_unsigned(4, 32);
	 edgelist(0,5) <= to_unsigned(2, 32); edgelist(1,5) <= to_unsigned(9, 32);
	 edgelist(0,6) <= to_unsigned(3, 32); edgelist(1,6) <= to_unsigned(5, 32);
	 edgelist(0,7) <= to_unsigned(4, 32); edgelist(1,7) <= to_unsigned(6, 32);
	 
	 x := deglist'left;
	 
	 nodelist_rm_duplicate(to_integer(edgelist(0,0)))<= to_unsigned(to_integer(edgelist(0,0)), 32);
	 tt:=to_integer(edgelist(0,0))+1;
	 
	 
	 for i in 0 to deglist'left loop
		for j in 0 to deglist'left loop
			if (i = to_integer(edgelist(0,j))) then
				deg_cntr := deg_cntr+1;
			end if;
			wait for 5 ns;
		end loop;
		if (i<(deglist'left)) then
			if (edgelist(0,i)/=edgelist(0,i+1)) then
				nodelist_rm_duplicate(tt)<=(edgelist(0,i+1));
				tt :=tt+1;
			end if;
		end if;
		deglist(i)<= to_unsigned(deg_cntr, 32);
		deg_cntr:=0;
	end loop;
	
	--wait for 5 ns;	
		
	--find and store the largest node number in order to 
	--be able to start from node 0 to this node
	highest_node_num := to_integer(nodelist_rm_duplicate(0));
	for i in 0 to nodelist_rm_duplicate'left loop
			if (highest_node_num < to_integer(nodelist_rm_duplicate(i))) then
				highest_node_num := to_integer(nodelist_rm_duplicate(i));
			end if;
			wait for 5 ns;
	end loop;
	
	
	--find and store the largest number in the edgelist to get maxbits
	largest_num := to_integer(edgelist(0,0));
	for i in 0 to 1 loop
		for j in 0 to deglist'left loop
			if (largest_num < to_integer(edgelist(i,j))) then
				largest_num := to_integer(edgelist(i,j));
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
		for j in 0 to deglist'left loop
			if (to_integer(nodelist_rm_duplicate(i)) = to_integer(edgelist(0,j))) then
				--comp_bitseq_temp (num_bits-1 downto 0) <= comp_bitseq_temp (num_bits-1 downto 0) or edgelist(1,j)(num_bits-1 downto 0);
				--comp_bitseq <= comp_bitseq_temp sll num_bits;
				--sign := to_integer(edgelist(0,j));
				--sign2:= to_integer(nodelist_rm_duplicate(i));
				--c:= c+1;
				comp_bitseq ((c+1)*num_bits-1 downto c*num_bits) <= to_bitvector(std_logic_vector(edgelist(1,j)(num_bits-1 downto 0)));
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
	 
				
	
	
	wait for 1 ns;
	end process;
	
end Behavioral;

