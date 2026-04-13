library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity stopwatch_logic is
    Port (
        
        clk              : in  STD_LOGIC;
        ce_100hz         : in  STD_LOGIC;
        btn_rst_d        : in  STD_LOGIC;
        btn_start_stop_d : in  STD_LOGIC;
        btn_lap_d        : in  STD_LOGIC;
        
        
        stream_24b       : out STD_LOGIC_VECTOR (23 downto 0)
    );
end stopwatch_logic;

architecture Structural of stopwatch_logic is

    
    signal sig_run_enable : STD_LOGIC;                      
    signal sig_time_24b   : STD_LOGIC_VECTOR(23 downto 0);  
    signal sig_lap_24b    : STD_LOGIC_VECTOR(23 downto 0);  

begin

    -- 1. Blok: Start/Stop Latch 
    inst_start_stop: entity work.start_stop_latch
        port map (
            clk              => clk,
            btn_rst_d        => btn_rst_d,
            btn_start_stop_d => btn_start_stop_d,
            run_enable       => sig_run_enable  
        );

    -- 2. Blok: Counter 
    inst_counter: entity work.stopwatch_counter
        port map (
            clk        => clk,
            btn_rst_d  => btn_rst_d,
            ce_100hz   => ce_100hz,
            run_enable => sig_run_enable,       
            time_24b   => sig_time_24b          
        );

    -- 3. Blok: Lap Register 
    inst_lap_register: entity work.lap_register
        port map (
            clk       => clk,
            btn_rst_d => btn_rst_d,
            btn_lap_d => btn_lap_d,
            time_24b  => sig_time_24b,          
            lap_24b   => sig_lap_24b            
        );

    -- 4. Blok: Lap/Run Latch 
    inst_lap_run_latch: entity work.lap_run_latch
        port map (
            clk        => clk,
            btn_lap_d  => btn_lap_d,
            time_24b   => sig_time_24b,         
            lap_24b    => sig_lap_24b,          
            stream_24b => stream_24b           
        );

end Structural;