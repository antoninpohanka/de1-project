----------------------------------------------------------------------------------
-- Company:      Brno University of Technology
-- Engineer:     Lukas Kosek
-- 
-- Create Date:  04/09/2026 08:22:45 AM
-- Design Name:  Stopwatch with Lap Time Function
-- Module Name:  stopwatch_logic 
-- Project Name: Digital Electronics 1 Project - Stopwatch
-- Target Devices: Nexys A7-50T (Artix-7)
-- Tool Versions: Vivado 2020.1 (or newer)
-- Description:  Structural logic module connecting the start/stop latch, 
--               time counter, lap controller, and lap memory. It manages 
--               the internal signals and formats the 32-bit output for the 
--               8-digit 7-segment display driver, including lap mode indication.
-- 
-- Dependencies: start_stop_latch.vhd, stopwatch_counter.vhd, 
--               lap_run_latch.vhd, lap_register.vhd
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: Project for DE1 course at FEEC BUT.
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity stopwatch_logic is
    Port (
        clk              : in  STD_LOGIC;
        ce_100hz         : in  STD_LOGIC;
        btn_rst_d        : in  STD_LOGIC;
        btn_start_stop_d : in  STD_LOGIC;
        btn_lap_d        : in  STD_LOGIC;
        
        -- Full 32-bit output for 8 displays (including 'L' character)
        display_data     : out STD_LOGIC_VECTOR (31 downto 0);

        -- New outputs for RGB LEDs
        run_status       : out STD_LOGIC;
        lap_status       : out STD_LOGIC
    );
end stopwatch_logic;

architecture Structural of stopwatch_logic is

    -- Internal connections between the 4 modules
    signal sig_run_enable : STD_LOGIC;
    signal sig_lap_mode   : STD_LOGIC;
    signal sig_time_24b   : STD_LOGIC_VECTOR(23 downto 0);  
    signal sig_lap_24b    : STD_LOGIC_VECTOR(23 downto 0);
    signal sig_stream_24b : STD_LOGIC_VECTOR(23 downto 0);

begin

    -- Block 1: Start/Stop Latch 
    inst_start_stop: entity work.start_stop_latch
        port map (
            clk              => clk,
            btn_rst_d        => btn_rst_d,
            btn_start_stop_d => btn_start_stop_d,
            run_enable       => sig_run_enable  
        );

    -- Block 2: Time Counter 
    inst_counter: entity work.stopwatch_counter
        port map (
            clk        => clk,
            btn_rst_d  => btn_rst_d,
            ce_100hz   => ce_100hz,
            run_enable => sig_run_enable,       
            time_24b   => sig_time_24b          
        );

    -- Block 3: Lap/Run Latch (Controller)
    inst_lap_run_latch: entity work.lap_run_latch
        port map (
            clk           => clk,
            btn_rst_d     => btn_rst_d,
            btn_lap_d     => btn_lap_d,
            time_24b      => sig_time_24b,         
            lap_24b       => sig_lap_24b,           
            stream_24b    => sig_stream_24b,
            lap_mode_flag => sig_lap_mode
        );

    -- Block 4: Lap Register (Memory)
    inst_lap_register: entity work.lap_register
        port map (
            clk           => clk,
            btn_rst_d     => btn_rst_d,
            lap_mode_flag => sig_lap_mode,
            time_24b      => sig_time_24b,          
            lap_24b       => sig_lap_24b            
        );

    -- output states out of this module
    run_status <= sig_run_enable;
    lap_status <= sig_lap_mode;

    -- DATA FORMATTING FOR DISPLAY DRIVER (32 bits)
    -- AN7 (Leftmost) : Show 'L' (x"B") if in lap mode, else blank (x"A")
    display_data(31 downto 28) <= x"B" when sig_lap_mode = '1' else x"A";
    -- AN6            : Always blank (x"A")
    display_data(27 downto 24) <= x"A";
    -- AN5 down to AN0: The actual 6-digit time stream (MM:SS:hh)
    display_data(23 downto  0) <= sig_stream_24b;

end Structural;
