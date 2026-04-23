----------------------------------------------------------------------------------
-- Company:      Brno University of Technology
-- Engineer:     Antonin Pohanka
-- 
-- Create Date:  04/09/2026 08:22:45 AM
-- Design Name:  Stopwatch with Lap Time Function
-- Module Name:  lap_register - Behavioral
-- Project Name: Digital Electronics 1 Project - Stopwatch
-- Target Devices: Nexys A7-50T (Artix-7)
-- Tool Versions: Vivado 2020.1 (or newer)
-- Description:  Memory register that stores the lap time. It continuously 
--               tracks the current running time and freezes the captured 
--               value as soon as the lap mode flag is asserted.
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: Project for DE1 course at FEEC BUT.
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lap_register is
    Port (
        clk           : in  STD_LOGIC;
        btn_rst_d     : in  STD_LOGIC;
        lap_mode_flag : in  STD_LOGIC;
        time_24b      : in  STD_LOGIC_VECTOR (23 downto 0);
        lap_24b       : out STD_LOGIC_VECTOR (23 downto 0)
    );
end lap_register;

architecture Behavioral of lap_register is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if btn_rst_d = '1' then
                lap_24b <= (others => '0');
                
            -- Continuously copy running time UNTIL we enter lap mode.
            -- Once lap_mode_flag = '1', this stops updating (freezing the time).
            elsif lap_mode_flag = '0' then
                lap_24b <= time_24b;
            end if;
        end if;
    end process;
end Behavioral;
