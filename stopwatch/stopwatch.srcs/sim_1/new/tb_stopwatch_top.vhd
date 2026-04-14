library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_stopwatch_top is
-- Testbench has no ports, it acts as an enclosed testing environment
end tb_stopwatch_top;

architecture Behavioral of tb_stopwatch_top is

    -- Signals to connect to the Unit Under Test (UUT)
    signal clk            : std_logic := '0';
    signal btn_rst        : std_logic := '0';
    signal btn_start_stop : std_logic := '0';
    signal btn_lap        : std_logic := '0';
    
    signal seg            : std_logic_vector(6 downto 0);
    signal dp             : std_logic;
    signal an             : std_logic_vector(7 downto 0);

    -- Clock period definition for 100 MHz oscillator (10 ns period)
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Top-Level module
    UUT: entity work.stopwatch_top
        port map (
            clk            => clk,
            btn_rst        => btn_rst,
            btn_start_stop => btn_start_stop,
            btn_lap        => btn_lap,
            seg            => seg,
            dp             => dp,
            an             => an
        );

    -- Clock generation process
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process (Simulating human button presses)
    stim_proc: process
    begin
        -- 1. Initialization and System Reset
        btn_rst <= '1';
        wait for 100 ns;
        btn_rst <= '0';
        wait for 100 ns;

        -- 2. Start the stopwatch
        -- Note: Button must be held longer than the debounce sampling period!
        btn_start_stop <= '1';
        wait for 200 ns; 
        btn_start_stop <= '0';

        -- Let the stopwatch run for a while
        wait for 5000 ns;

        -- 3. Capture split time (Enter LAP mode)
        btn_lap <= '1';
        wait for 200 ns;
        btn_lap <= '0';

        -- Wait in LAP mode.
        -- In the waveform, the output display data should remain frozen,
        -- while internal background counters continue to increment.
        wait for 3000 ns;

        -- 4. Resume normal view (Exit LAP mode)
        btn_lap <= '1';
        wait for 200 ns;
        btn_lap <= '0';

        -- Let the running time display for a while
        wait for 3000 ns;

        -- 5. Stop the stopwatch completely
        btn_start_stop <= '1';
        wait for 200 ns;
        btn_start_stop <= '0';

        -- End of simulation sequence
        wait;
    end process;

end Behavioral;