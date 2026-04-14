library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_stopwatch_top is
-- Testbench nemá žádné porty, je to uzavřená krabice
end tb_stopwatch_top;

architecture Behavioral of tb_stopwatch_top is

    -- Signály pro připojení k našim stopkám
    signal clk            : std_logic := '0';
    signal btn_rst        : std_logic := '0';
    signal btn_start_stop : std_logic := '0';
    signal btn_lap        : std_logic := '0';
    
    signal seg            : std_logic_vector(6 downto 0);
    signal dp             : std_logic;
    signal an             : std_logic_vector(7 downto 0);

    -- Definice periody hodin pro 100 MHz (10 nanosekund)
    constant clk_period : time := 10 ns;

begin

    -- Připojení (instanciace) našeho hlavního projektu
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

    -- Proces, který neustále generuje tikání hodin (jako krystal na desce)
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Proces, který simuluje mačkání tlačítek prstem
    stim_proc: process
    begin
        -- 1. Fáze: Inicializace a Reset
        btn_rst <= '1';
        wait for 100 ns;
        btn_rst <= '0';
        wait for 100 ns;

        -- 2. Fáze: Spuštění stopek (Změníme stav do RUNNING)
        -- Tlačítko musíme držet déle než je zpoždění debounceru!
        btn_start_stop <= '1';
        wait for 200 ns; 
        btn_start_stop <= '0';

        -- Necháme stopky chvíli běžet (počítat)
        wait for 5000 ns;

        -- 3. Fáze: Změření mezičasu (Změníme stav do LAP_VIEW)
        btn_lap <= '1';
        wait for 200 ns;
        btn_lap <= '0';

        -- Necháme stopky chvíli v LAP režimu.
        -- V simulátoru pak můžeš zkontrolovat, že se na displej posílá pořád stejný čas,
        -- i když vnitřní čítač dál tiká.
        wait for 3000 ns;

        -- 4. Fáze: Zrušení mezičasu (Návrat do RUNNING)
        btn_lap <= '1';
        wait for 200 ns;
        btn_lap <= '0';

        -- Zase necháme chvíli běžet aktuální čas
        wait for 3000 ns;

        -- 5. Fáze: Zastavení stopek
        btn_start_stop <= '1';
        wait for 200 ns;
        btn_start_stop <= '0';

        -- Konec simulace
        wait;
    end process;

end Behavioral;