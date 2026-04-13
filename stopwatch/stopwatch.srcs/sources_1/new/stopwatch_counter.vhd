library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity stopwatch_counter is
    Port (
        clk        : in  STD_LOGIC;
        btn_rst_d  : in  STD_LOGIC;
        ce_100hz   : in  STD_LOGIC;  
        run_enable : in  STD_LOGIC;  
        time_24b   : out STD_LOGIC_VECTOR (23 downto 0)
    );
end stopwatch_counter;

architecture Behavioral of stopwatch_counter is
    -- Vytvoříme si signály pro jednotlivé číslice 
    signal centisec_0 : unsigned(3 downto 0) := (others => '0');
    signal centisec_1 : unsigned(3 downto 0) := (others => '0');
    signal sec_0      : unsigned(3 downto 0) := (others => '0');
    signal sec_1      : unsigned(3 downto 0) := (others => '0');
    signal min_0      : unsigned(3 downto 0) := (others => '0');
    signal min_1      : unsigned(3 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if btn_rst_d = '1' then
                -- Reset všech čítačů
                centisec_0 <= (others => '0');
                centisec_1 <= (others => '0');
                sec_0      <= (others => '0');
                sec_1      <= (others => '0');
                min_0      <= (others => '0');
                min_1      <= (others => '0');
                
            elsif (ce_100hz = '1' and run_enable = '1') then
               
                
                if centisec_0 = 9 then
                    centisec_0 <= (others => '0');
                    if centisec_1 = 9 then
                        centisec_1 <= (others => '0');
                        if sec_0 = 9 then
                            sec_0 <= (others => '0');
                            if sec_1 = 5 then -- Desítky vteřin jdou jen do 5 (59s max)
                                sec_1 <= (others => '0');
                                if min_0 = 9 then
                                    min_0 <= (others => '0');
                                    if min_1 = 5 then -- Desítky minut jdou jen do 5
                                        min_1 <= (others => '0');
                                    else
                                        min_1 <= min_1 + 1;
                                    end if;
                                else
                                    min_0 <= min_0 + 1;
                                end if;
                            else
                                sec_1 <= sec_1 + 1;
                            end if;
                        else
                            sec_0 <= sec_0 + 1;
                        end if;
                    else
                        centisec_1 <= centisec_1 + 1;
                    end if;
                else
                    centisec_0 <= centisec_0 + 1;
                end if;
            end if;
        end if;
    end process;

    -- Složení 24bitového vektoru 
    time_24b(23 downto 20) <= std_logic_vector(min_1);      -- Desítky minut
    time_24b(19 downto 16) <= std_logic_vector(min_0);      -- Jednotky minut
    time_24b(15 downto 12) <= std_logic_vector(sec_1);      -- Desítky vteřin
    time_24b(11 downto  8) <= std_logic_vector(sec_0);      -- Jednotky vteřin
    time_24b( 7 downto  4) <= std_logic_vector(centisec_1); -- Desítky setin
    time_24b( 3 downto  0) <= std_logic_vector(centisec_0); -- Jednotky setin

end Behavioral;
