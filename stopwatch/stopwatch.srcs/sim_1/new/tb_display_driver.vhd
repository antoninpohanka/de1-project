library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_display_driver is
end tb_display_driver;

architecture Behavioral of tb_display_driver is

    signal clk    : std_logic := '0';
    signal rst    : std_logic := '0';
    signal data_i : std_logic_vector(31 downto 0) := (others => '0');
    
    signal seg_o  : std_logic_vector(6 downto 0);
    signal dp_o   : std_logic;
    signal an_o   : std_logic_vector(7 downto 0);

    constant clk_period : time := 10 ns;

begin

    UUT: entity work.display_driver
        port map (
            clk    => clk,
            rst    => rst,
            data_i => data_i,
            seg_o  => seg_o,
            dp_o   => dp_o,
            an_o   => an_o
        );

    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    stim_proc: process
    begin
        -- 1. Reset the module
        rst <= '1';
        wait for 100 ns;
        rst <= '0';

        -- 2. Test LAP mode rendering (Expected: "L 001234")
        -- B = code for 'L' character, A = code for blank (off)
        data_i <= x"BA001234";
        
        -- WARNING: Wait in milliseconds to allow the multiplexer 
        -- to cycle through all 8 digits (approx. 1.3 ms per full cycle)
        wait for 2 ms;

        -- 3. Test normal running mode rendering (Expected: "  595999")
        data_i <= x"AA595999";
        
        wait for 2 ms;

        wait;
    end process;

end Behavioral;