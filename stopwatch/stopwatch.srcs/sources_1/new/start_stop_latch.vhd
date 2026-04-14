library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity start_stop_latch is
    Port (
        clk              : in  STD_LOGIC;
        btn_rst_d        : in  STD_LOGIC;
        btn_start_stop_d : in  STD_LOGIC;
        run_enable       : out STD_LOGIC  
    );
end start_stop_latch;

architecture Behavioral of start_stop_latch is
    signal running  : STD_LOGIC := '0';

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if btn_rst_d = '1' then
                running <= '0';
            -- Toggle state when the debounced pulse arrives
            elsif btn_start_stop_d = '1' then
                running <= not running;
            end if;
        end if;
    end process;
    
    run_enable <= running;
end Behavioral;