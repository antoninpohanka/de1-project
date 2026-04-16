library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_start_stop_latch is
end tb_start_stop_latch;

architecture Behavioral of tb_start_stop_latch is
    signal clk              : std_logic := '0';
    signal btn_rst_d        : std_logic := '0';
    signal btn_start_stop_d : std_logic := '0';
    signal run_enable       : std_logic;

    constant clk_period : time := 10 ns;
begin
    UUT: entity work.start_stop_latch
        port map (
            clk              => clk,
            btn_rst_d        => btn_rst_d,      
            btn_start_stop_d => btn_start_stop_d,
            run_enable       => run_enable
        );

    clk_process: process
    begin
        clk <= '0'; wait for clk_period/2;
        clk <= '1'; wait for clk_period/2;
    end process;

    stim_proc: process
    begin
        -- Initial reset
        btn_rst_d <= '1';
        wait for 50 ns;
        btn_rst_d <= '0';
        wait for 50 ns;
        
        btn_start_stop_d <= '1';
        wait for clk_period; 
        btn_start_stop_d <= '0';
        wait for 100 ns;
        
        btn_start_stop_d <= '1';
        wait for clk_period;
        btn_start_stop_d <= '0';
        
        wait;
    end process;
end Behavioral;