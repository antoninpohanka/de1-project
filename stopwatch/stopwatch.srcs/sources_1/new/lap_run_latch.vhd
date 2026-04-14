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