----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/09/2026 08:22:45 AM
-- Design Name: 
-- Module Name: stopwatch_top - Behavioral
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

entity stopwatch_top is
    Port ( clk : in STD_LOGIC;
           btn_rst : in STD_LOGIC;
           btn_start_stop : in STD_LOGIC;
           btn_lap : in STD_LOGIC;
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           dp : out STD_LOGIC;
           an : out STD_LOGIC_VECTOR (7 downto 0));
end stopwatch_top;

architecture Structural of stopwatch_top is

    -- internal signals
    signal sig_btn_rst_press : STD_LOGIC;
    signal sig_btn_start_stop_press : STD_LOGIC;
    signal sig_btn_lap_press : STD_LOGIC;

    signal sig_ce_100hz : STD_LOGIC;
    signal sig_display_data : STD_LOGIC_VECTOR(31 downto 0); -- 6 digits * 4 bits per digit

begin

    -- insance 1: clock divider to generate 100Hz enable signal

    clk_en_100hz_inst : entity work.clk_en
        generic map (
            -- G_MAX => 5 -- for simulation
            G_MAX => 1_000_000, -- for implementation, 
        )
        port map (
            clk => clk,
            rst => '0', -- no reset for clock divider
            ce_out => sig_ce_100hz
        );

    -- instance 2, 3, 4: button debouncers for reset, start/stop, and lap buttons

    debouncer_rst : entity work.debounce
        port map (
            clk => clk,
            rst => '0', -- no reset for debouncer
            btn_in => btn_rst,
            btn_state => open, -- not used
            btn_press => sig_btn_rst_press
        );

    debouncer_start_stop : entity work.debounce
        port map (
            clk => clk,
            rst => '0', -- no reset for debouncer
            btn_in => btn_start_stop,
            btn_state => open, -- not used
            btn_press => sig_btn_start_stop_press
        );

    debouncer_lap : entity work.debounce
        port map (
            clk => clk,
            rst => '0', -- no reset for debouncer
            btn_in => btn_lap,
            btn_state => open, -- not used
            btn_press => sig_btn_lap_press
        );

    -- instance 5: stopwatch control logic
    stopwatch_core_inst : entity work.stopwatch_logic
        port map (
            clk => clk,
            rst => sig_btn_rst_press,
            ce_100hz => sig_ce_100hz,
            start_stop => sig_btn_start_stop_press,
            lap => sig_btn_lap_press,
            display_data => sig_display_data
        );

    -- instance 6: display driver to convert display data to 7-seg signals
    display_driver_inst : entity work.display_driver
        port map (
            clk => clk,
            rst => sig_btn_rst_press,
            data_i => sig_display_data,
            seg_o => seg,
            dp_o => dp,
            an_o => an
        );


end Structural;
