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