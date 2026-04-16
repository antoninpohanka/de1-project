library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_stopwatch_counter is
end tb_stopwatch_counter;

architecture Behavioral of tb_stopwatch_counter is
    signal clk        : std_logic := '0';
    signal btn_rst_d  : std_logic := '0'; 
    signal ce_100hz   : std_logic := '0';
    signal run_enable : std_logic := '0';
    signal time_24b   : std_logic_vector(23 downto 0);

    constant clk_period : time := 10 ns;
begin
    UUT: entity work.stopwatch_counter
        port map (
            clk        => clk,
            btn_rst_d  => btn_rst_d,      
            ce_100hz   => ce_100hz,
            run_enable => run_enable,
            time_24b   => time_24b
        );

    clk_process: process
    begin
        clk <= '0'; wait for clk_period/2;
        clk <= '1'; wait for clk_period/2;
    end process;

    ce_process: process
    begin
        ce_100hz <= '0'; wait for clk_period * 2;
        ce_100hz <= '1'; wait for clk_period;
    end process;

    stim_proc: process
    begin
        -- Initial reset
        btn_rst_d <= '1';
        wait for 50 ns;
        btn_rst_d <= '0';
        wait for 50 ns;

        run_enable <= '1';
        wait for 2000 ns; 
        
        run_enable <= '0';
        wait for 500 ns;
        wait;
    end process;
end Behavioral;