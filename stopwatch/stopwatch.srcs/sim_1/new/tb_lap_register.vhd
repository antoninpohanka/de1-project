library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_lap_register is
end tb_lap_register;

architecture Behavioral of tb_lap_register is
    signal clk           : std_logic := '0';
    signal btn_rst_d     : std_logic := '0'; 
    signal lap_mode_flag : std_logic := '0';
    signal time_24b      : std_logic_vector(23 downto 0) := (others => '0');
    signal lap_24b       : std_logic_vector(23 downto 0);

    constant clk_period : time := 10 ns;
    signal sim_counter   : unsigned(23 downto 0) := (others => '0');
begin
    UUT: entity work.lap_register
        port map (
            clk           => clk,
            btn_rst_d     => btn_rst_d,      
            lap_mode_flag => lap_mode_flag,
            time_24b      => time_24b,
            lap_24b       => lap_24b
        );

    clk_process: process
    begin
        clk <= '0'; wait for clk_period/2;
        clk <= '1'; wait for clk_period/2;
    end process;

    fake_time_process: process(clk)
    begin
        if rising_edge(clk) then
            sim_counter <= sim_counter + 1;
            time_24b <= std_logic_vector(sim_counter);
        end if;
    end process;

    stim_proc: process
    begin
        btn_rst_d <= '1';
        wait for 50 ns;
        btn_rst_d <= '0';
        
        lap_mode_flag <= '0';
        wait for 100 ns;

        lap_mode_flag <= '1';
        wait for 150 ns;

        lap_mode_flag <= '0';
        wait for 100 ns;

        wait;
    end process;
end Behavioral;