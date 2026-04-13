library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lap_run_latch is
    Port (
        clk        : in  STD_LOGIC;
        btn_lap_d  : in  STD_LOGIC;
        time_24b   : in  STD_LOGIC_VECTOR (23 downto 0);
        lap_24b    : in  STD_LOGIC_VECTOR (23 downto 0);
        stream_24b : out STD_LOGIC_VECTOR (23 downto 0) 
    );
end lap_run_latch;

architecture Behavioral of lap_run_latch is
    signal btn_prev : STD_LOGIC := '0';
    signal lap_mode : STD_LOGIC := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            -- Detekce hrany pro přepnutí 
            btn_prev <= btn_lap_d;
            
            if (btn_lap_d = '1' and btn_prev = '0') then
                lap_mode <= not lap_mode; 
            end if;
        end if;
    end process;

    -- Samotný přepínač na výstup
    stream_24b <= lap_24b when lap_mode = '1' else time_24b;
end Behavioral;