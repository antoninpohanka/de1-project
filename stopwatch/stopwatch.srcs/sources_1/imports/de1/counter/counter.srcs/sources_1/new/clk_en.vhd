----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/05/2026 10:22:20 AM
-- Design Name: 
-- Module Name: clk_en - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
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
