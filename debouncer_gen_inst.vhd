library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity debouncer_gen_inst is
	generic (
    switch_count : positive;
    timeout_cycles : positive
    );
  port (
    clk : in std_logic;
    rst : in std_logic;
    switches : in std_logic_vector(switch_count - 1 downto 0);
    switches_debounced : out std_logic_vector(switch_count - 1 downto 0)
  );
end debouncer_gen_inst;

architecture Behavioral of debouncer_gen_inst is

begin

	 MY_GEN : for i in 0 to switch_count - 1 generate
 
    DEBOUNCER : entity work.debouncer(rtl)
    generic map (
      timeout_cycles => timeout_cycles
    )
    port map (
      clk => clk,
      rst => rst,
      switch => switches(i),
      switch_debounced => switches_debounced(i)
    );
 
  end generate;
 
end Behavioral;

