----------------------------------------------------------------------------------
-- Company:      Brno University of Technology
-- Engineer:     Antonin Pohanka
-- 
-- Create Date:  03/05/2026 10:22:20 AM
-- Design Name:  Stopwatch with Lap Time Function
-- Module Name:  clk_en - Behavioral
-- Project Name: Digital Electronics 1 Project - Stopwatch
-- Target Devices: Nexys A7-50T (Artix-7)
-- Tool Versions: Vivado 2020.1 (or newer)
-- Description:  Generates a single clock-cycle enable pulse at a frequency 
--               determined by the generic parameter G_MAX. Used to derive 
--               slower enable signals (e.g., 100 Hz for the stopwatch) 
--               from the main system clock.
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: Project for DE1 course at FEEC BUT.
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clk_en is
    generic (
        G_MAX : positive := 5 -- default number of clock cycles
    );
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           ce  : out STD_LOGIC);
end clk_en;

architecture Behavioral of clk_en is

    -- Internal counter
    signal sig_cnt : integer range 0 to G_MAX-1;

begin

    -- Count clock pulses and generate a one-clock-cycle enable pulse
    process (clk) is
    begin
        if rising_edge(clk) then  -- Synchronous process
            if rst = '1' then     -- High-active reset
                ce      <= '0';   -- Reset output
                sig_cnt <= 0;     -- Reset internal counter

            elsif sig_cnt = G_MAX-1 then
                
                ce      <= '1';
                sig_cnt <= 0;                
                
                
            else
                
                sig_cnt <= sig_cnt + 1;
                ce      <= '0';
                
                                
            end if;  -- End if for reset/check
        end if;      -- End if for rising_edge
    end process;


end Behavioral;
