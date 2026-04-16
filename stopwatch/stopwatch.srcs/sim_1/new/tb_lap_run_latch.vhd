library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_lap_run_latch is
end tb_lap_run_latch;

architecture Behavioral of tb_lap_run_latch is
    signal clk           : std_logic := '0';
    signal btn_rst_d     : std_logic := '0'; 
    signal btn_lap_d     : std_logic := '0';
    signal time_24b      : std_logic_vector(23 downto 0) := x"111111"; 
    signal lap_24b       : std_logic_vector(23 downto 0) := x"999999"; 
    signal stream_24b    : std_logic_vector(23 downto 0);              
    signal lap_mode_flag : std_logic;

    constant clk_period : time := 10 ns;
begin
    UUT: entity work.lap_run_latch
        port map (
            clk           => clk,
            btn_rst_d     => btn_rst_d,    
            btn_lap_d     => btn_lap_d,
            time_24b      => time_24b,     
            lap_24b       => lap_24b,      
            stream_24b    => stream_24b,   
            lap_mode_flag => lap_mode_flag
        );

    clk_process: process
    begin
        clk <= '0'; wait for clk_period/2;
        clk <= '1'; wait for clk_period/2;
    end process;

    stim_proc: process
    begin
        btn_rst_d <= '1';
        wait for 50 ns;
        btn_rst_d <= '0';
        wait for 50 ns;
        
        btn_lap_d <= '1';
        wait for clk_period; 
        btn_lap_d <= '0';
        
        wait for 100 ns;
        
        btn_lap_d <= '1';
        wait for clk_period;
        btn_lap_d <= '0';
        
        wait;
    end process;
end Behavioral;