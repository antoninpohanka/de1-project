----------------------------------------------------------------------------------
-- Company:      Brno University of Technology
-- Engineer:     Antonin Pohanka
-- 
-- Create Date:  04/09/2026 08:22:45 AM
-- Design Name:  Stopwatch with Lap Time Function
-- Module Name:  lap_run_latch - Behavioral
-- Project Name: Digital Electronics 1 Project - Stopwatch
-- Target Devices: Nexys A7-50T (Artix-7)
-- Tool Versions: Vivado 2020.1 (or newer)
-- Description:  Controller module that toggles lap mode on a button press. 
--               It acts as a multiplexer, routing either the continuously 
--               running time or the frozen lap time to the display output, 
--               and sets a flag to indicate the active lap mode.
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: Project for DE1 course at FEEC BUT.
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lap_run_latch is
    Port (
        clk           : in  STD_LOGIC;
        btn_rst_d     : in  STD_LOGIC;
        btn_lap_d     : in  STD_LOGIC; -- 1-clock cycle pulse from debouncer
        time_24b      : in  STD_LOGIC_VECTOR (23 downto 0);
        lap_24b       : in  STD_LOGIC_VECTOR (23 downto 0);
        stream_24b    : out STD_LOGIC_VECTOR (23 downto 0);
        lap_mode_flag : out STD_LOGIC  -- Tells the logic to display 'L'
    );
end lap_run_latch;

architecture Behavioral of lap_run_latch is
    signal lap_mode : STD_LOGIC := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if btn_rst_d = '1' then
                lap_mode <= '0';
            elsif btn_lap_d = '1' then
                lap_mode <= not lap_mode; -- Toggle lap mode
            end if;
        end if;
    end process;

    -- Multiplexer: Output frozen LAP time if in lap mode, else running time
    stream_24b    <= lap_24b when lap_mode = '1' else time_24b;
    lap_mode_flag <= lap_mode;
end Behavioral;
