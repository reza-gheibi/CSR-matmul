----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:08:12 06/07/2021 
-- Design Name: 
-- Module Name:    csr1 - Behavioral 
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

entity CSR_test is
end CSR_test;

architecture Behavioral of CSR_test is

	signal int_tmp :integer; -- 32 bit integer
	signal temp, temp3, temp2, temp4, comp_arr_len :integer;-- :=0;
	--signal temp :integer :=0;
	signal num_bits, num_elements, remain   : integer :=0;
	signal temp_bit : std_logic_vector(0 downto 0);
	signal int_tmp1 :integer range 255 downto 0; -- 8 bit integer
	--signal my_slv: std_logic_vector(31 downto 0);
	signal xtemp : std_logic_vector(7 downto 0);
	signal xtemp_dec1, xtemp_dec2, xtemp_dec3, xtemp_dec4: std_logic_vector(7 downto 0);
	--signal x1: unsigned (31 downto 0):= x"00000000";
	signal max : std_logic_vector(31 downto 0);
	type ram_t is array(63 downto 0) of std_logic_vector(31 downto 0) ;
	type ram_t2 is array(7 downto 0) of std_logic_vector(31 downto 0) ;
   signal ram, ram2 : ram_t ;
	signal ram3 : ram_t2 ;
	
	--type matrix_t is array(1 downto 0, 6 downto 0) of integer ;--matrix 2 by 10 (row X col)
	--signal mat : matrix_t;
	
	--constant mat1 : matrix_t := ( (0,0)=>7, others=>0);
	--constant mat1 : matrix_t := ( (0,0)=>7);
	--signal mat1: matrix_t :=  ((others=> ( (0,0)=>7, (0,1)=>3, others=>0)));
	--signal mat1: matrix_t :=  ( (0=>0, 1=>0, 2=>1, 3=>1, 4=>1, 5=>2, 6=>3) , --others=>0), 
	--									 (0=>1, 1=>4, 2=>2, 3=>3, 4=>4, 5=>3, 6=>4)); --others=>0) ); --node numbers 0-5
	
	
	type memory is array(1 downto 0, 7 downto 0) of integer ;
	type memory2 is array(7 downto 0) of integer ;
	type memory3 is array(49 downto 0) of integer ;
	--signal c, cc, dg_down, dg:integer :=0;


	signal edgelist : memory := ( (0=>1, 1=>1, 2=>1, 3=>1, 4=>2, 5=>2, 6=>3, 7=>4) , --others=>0), 
										   (0=>5, 1=>11, 2=>8, 3=>3, 4=>4, 5=>9, 6=>5, 7=>6)); --others=>0) ); --node numbers 0-5
	
	signal deglist : memory2 := ((others=>0) ); 
	signal nodelist_rm_duplicate : memory2 := ((others=>0) );
	--to store all edges for each node(except the degree)
	--signal final_temp : memory2 := ((others=>0) );
	--final list to store each node and corespoinding degree
	--signal final_list : memory3 :=((others=>0),(others=>0),(others=>0),(others=>0),
	--										 (others=>0),(others=>0),(others=>0),(others=>0));
	signal final_list, final_list_decomp : memory3 := (others=>0);
	
	
 	--type int_arr is array (integer range <>) of integer;
	--type int_arr is array (0 to 3, 0 to 2) of integer range 0 to 9;
	type int_arr is array (31 downto 0) of Integer;-- 0 to 31;
	--type int_arr_1 is array (0 to 5) of integer;
	--shared variable r_int : int_arr(31 downto 0);
	--signal r_num, r_num_decomp : int_arr ;--ram_t;--others => 0; 
	--signal r_num_1 : int_arr := (others => 0);
	--signal r_num_2 : int_arr;
	--variable I: integer;
begin
	--ram <= (others => x"00000000");
	--ram2 <= (others => x"00000000");
	--int_tmp <= 11;
	--wait for 1 ns;
	--my_slv <= std_logic_vector(to_unsigned(int_tmp, my_slv'length));
	--wait for 2 ns;
	--x <= std_logic_vector(to_unsigned(temp, my_slv'length));
	--r_num(2) <= 7;
	--r_num(4) <= 11;
	--r_num(5) <= 31;
	--r_num (7 downto 0) <= (2 => '5', others=>(1 => '1', others=>'0'));
   --r_num(31 downto 0) <= (0=> 13, 1=>11, 2 => 21, 4 => 39, 7 => 33, 11=>66, 14=>70, 15=>77,
	--								19=>120, 22=>15, 25=>63, 26=>255, 29=>13, 31=> 7, others => 0);
	--r_num (7 downto 0) <= (2 => X"0007", 3=> X"0005", 4 => X"00CC", 5 => X"00FF", others => X"0");
	--r_num_1(5 downto 0) <= (1 => 13, 2 => 20, 4 => 15, others => 0);
	--r_num_2(5 downto 0) <= (1 => 13, 2 => 21, 4 => 33, others => 0);
	--r_num_2 (2) <= 9;
	process
	--variable temp2 : integer;
	variable deg_cntr, tt, c, dg, dg_down: integer := 0;
	begin
	
	--degreelist
	
	--to remove duplicate we keep the first element and continiue comparing and removing duplicate
	nodelist_rm_duplicate(edgelist(1,0))<=edgelist(1,0);
	tt:=edgelist(1,0)+1;
	
	for i in 0 to deglist'length-1 loop
		for j in 0 to deglist'length-1 loop
			if (i = (edgelist(1,j))) then
				deg_cntr := deg_cntr+1;
			end if;
			wait for 5 ns;
		end loop;
		if (i<(deglist'length-1)) then
		if (edgelist(1,i)/=edgelist(1,i+1)) then
			nodelist_rm_duplicate(tt)<=edgelist(1,i+1);
			tt :=tt+1;
		end if;
		end if;
		deglist(i)<=deg_cntr;
		deg_cntr:=0;
	end loop;
		
	wait for 10 ns;

LP:
   --final list integer
	for i in 0 to deglist'length-1 loop
		for j in 0 to deglist'length-1 loop
			if dg_down = deglist'length then
				exit LP;
			end if;
			if(deglist(j) /= 0) then
				final_list(c) <= nodelist_rm_duplicate(j);
				c := c+1;
				wait for 5 ns;
				final_list(c) <= deglist(j);
				c := c+1;
				wait for 5 ns;
				dg := deglist(j);-- keep the degree on dg and while degree>0 keep storing edges of that node
				wait for 5 ns;
				
				while(dg>0) loop
					final_list(c) <= edgelist(0,dg_down);
					c := c+1;
					wait for 5 ns;
					dg_down := dg_down+1;
					dg := dg-1;
					wait for 5 ns;
				end loop;
				--dg_down := dg_down-1;
				wait for 5 ns;

			end if;
			wait for 5 ns;
			
		end loop;		
	end loop;

	--wait for 5 ns;
	
	temp2 <= final_list(0);
		wait for 5 ns;
		--temp2 <= r_num(0); --after 1 ns;
		--wait for 1 ns;
		for i in final_list'range loop
			if (temp2 < (final_list(i))) then
				temp2 <= final_list(i);
			end if;
			wait for 5 ns;
		end loop;
	--wait for 5 ns;
	max <= std_logic_vector(to_unsigned(temp2, max'length));
	--temp <= temp2;
	--temp3 <= integer(ceil(log2(max)));
	--wait for 10 ns; --wait for 1 ns;
   --remain <= temp2; --to_integer(max);
	--end process;
	
	--remain <= temp2;
	
	--process
	--variable temp3 : integer;
	--begin
	--temp3 := temp;
	--wait for 5 ns;
	remain <= temp2;--to_integer(unsigned(temp2)); --after 3 ns;
	--wait for 3 ns;
	--remain <= temp3;
   while remain > 0 loop  -- Iteration for each bit required
      temp3 <= temp3 + 1;
	   --max <= max / 2;
		wait for 5 ns;
      remain <= remain / 2;
   end loop;
	--wait for 2 ns;
	num_bits <= temp3 -1;
	--wait for 5 ns;
	--if x /= my_slv then
		--report "hi";
	--end if;
	--I <= r_num'left';--(r_num'range);
	temp4 <= num_bits; -- temp4 is maximum #ofbits required for each number(#bits of largest num in the array)
	wait for 20 ns;
	num_elements <= final_list'length; -- keep the #elements of uncompressed array
   wait for 20 ns;
	comp_arr_len <= num_elements * temp4; --# the length of the compressed array
	wait for 20 ns;
	 
	
	
	xtemp <= std_logic_vector(to_unsigned((temp2), xtemp'length));
	--wait for 10 ns;
	 
	 

		for i in final_list'range loop 
			ram(i) <= std_logic_vector(to_unsigned((final_list(i)),   xtemp'length));
		end loop;
		
		wait for 10 ns;
		
		L1:
		for i in ram3'range loop 
		--for i in 0 to 7 loop 
			--z:=0;
			--wait for 10 ns;
			--exit L1 when i = 8;
			ram3(i) <=   ram(i*3+i)(31 downto 24)    & ram(i*3+i+1)(31 downto 24)  
						  & ram(i*3+i+2)(31 downto 24)  & ram(i*3+i+3)(31 downto 24);
			--wait for 10 ns;
			--z:=z+3;
		end loop;
		
	
		wait for 10 ns;
		
		L2:
		--for i in ram'range loop 
		for i in 0 to 31 loop 
			--z:=0;
			wait for 10 ns;
			exit L2 when i = 8;
			ram2(i) <=   ram(i*3+i)(31 downto 24)    & ram(i*3+i+1)(31 downto 24)  
						  & ram(i*3+i+2)(31 downto 24)  & ram(i*3+i+3)(31 downto 24);
			--z:=z+3;
		end loop;

		wait for 10 ns;
		
		for i in 0 to 7 loop 
			--z:=0;
			xtemp_dec1 <= ram2(i)(31 downto 24);
			xtemp_dec2 <= ram2(i)(23 downto 16);
			xtemp_dec3 <= ram2(i)(15 downto 8);
			xtemp_dec4 <= ram2(i)(7  downto 0);
			wait for 10 ns;
			final_list_decomp(i*3+i)   <= to_integer(unsigned(xtemp_dec1));
			final_list_decomp(i*3+i+1) <= to_integer(unsigned(xtemp_dec2));
			final_list_decomp(i*3+i+2) <= to_integer(unsigned(xtemp_dec3));
			final_list_decomp(i*3+i+3) <= to_integer(unsigned(xtemp_dec4));
			--wait for 10 ns;
			--z:=z+3;
			--wait for 10 ns;
			--r_num_decomp
		end loop;

		
		
		--wait for 10 ns;
		--ram2(0) <=   ram(0)(31 downto 24)   & ram(1)(31 downto 24)
			--		  & ram(2)(31 downto 24)   & ram(3)(31 downto 24);
	--wait for 885 ns;
 
	
	


	


	end process;
	
end Behavioral;

