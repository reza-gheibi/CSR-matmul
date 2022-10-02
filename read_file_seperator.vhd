library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use std.textio.all;



entity read_file_seperator is
end read_file_seperator;

architecture Behavioral of read_file_seperator is

 

begin 


read_ip : process
  file file_in       : text;
  variable file_line : line;
  constant path      : string := "C:\Xilinx\Projects\Project_CSR/";
  constant file_name : string := "int_numbers.txt";
  constant file_pwd  : string := path & file_name;
  
  variable scs       : integer;
  variable delimiter : string(1 to 3); -- : character;
  variable data_in   : byte;
  variable byte_index: integer;
  
begin
  file_open(file_in, file_pwd, READ_MODE);
  wait until RISING_EDGE(CLK);
  -- read the header
  readline(file_in, file_line);
  while not endfile(file_in) loop
    DATA_RX_RE <= '0';
    wait until RISING_EDGE(SCLK);
    readline(file_in, file_line);
    read(file_line, scs); -- int read, int if statement
    if scs = 1 then
      -- read(file_line, delimiter);
      hread(file_line, data_in);
      -- read(file_line, delimiter);
      read(file_line, byte_index);
      DATA_RX_RE <= '1';
      SCS_RST    <= '0';
    else 
      SCS_RST    <= '1';
    end if;
    DATA_RX_IN <= DATA_IN;
    wait until falling_edge(clk);
    wait until rising_edge(clk);
  end loop;
  file_close(file_in);
  report "finished" severity FAILURE;
  wait;

end process;

end Behavioral;

