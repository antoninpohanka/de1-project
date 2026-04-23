----------------------------------------------------------------------------------
-- Company:      Brno University of Technology
-- Engineer:     Antonin Pohanka
-- 
-- Create Date:  04/09/2026 08:22:45 AM
-- Design Name:  Stopwatch with Lap Time Function
-- Module Name:  start_stop_latch - Behavioral
-- Project Name: Digital Electronics 1 Project - Stopwatch
-- Target Devices: Nexys A7-50T (Artix-7)
-- Tool Versions: Vivado 2020.1 (or newer)
-- Description:  Recognizes the start/stop button press and holds the state 
--               of whether the stopwatch is currently running or paused.
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: Project for DE1 course at FEEC BUT.
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- recognizes the start/stop button press and holds the state of whether the stopwatch is running or not

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
