library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lap_register is
    Port (
        clk       : in  STD_LOGIC;
        btn_rst_d : in  STD_LOGIC;
        btn_lap_d : in  STD_LOGIC;
        time_24b  : in  STD_LOGIC_VECTOR (23 downto 0);
        lap_24b   : out STD_LOGIC_VECTOR (23 downto 0)
    );
end lap_register;

architecture Behavioral of lap_register is
    signal btn_prev : STD_LOGIC := '0';
    signal lap_mode : STD_LOGIC := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if btn_rst_d = '1' then
                lap_24b <= (others => '0');
                btn_prev <= '0';
                lap_mode <= '0';
            else
                -- Detekce hrany tlačítka LAP
                btn_prev <= btn_lap_d;
                
                if (btn_lap_d = '1' and btn_prev = '0') then
                    lap_mode <= not lap_mode; -- Přepnutí interního stavu
                    
                    if lap_mode = '0' then
                        -- Pokud jsme byli v běhu a mačkáme LAP, ulož aktuální čas
                        lap_24b <= time_24b;
                    end if;
                end if;
            end if;
        end if;
    end process;
end Behavioral;