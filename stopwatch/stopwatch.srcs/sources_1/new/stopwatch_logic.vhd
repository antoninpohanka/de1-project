library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- use IEEE.NUMERIC_STD.ALL; -- Bude se hodit pro inkrementaci času

entity stopwatch_logic is
    Port ( 
        clk            : in  STD_LOGIC;
        rst            : in  STD_LOGIC;
        
        -- Řídící pulzy
        ce_100hz       : in  STD_LOGIC;
        btn_start_stop : in  STD_LOGIC;
        btn_lap        : in  STD_LOGIC;
        
        -- Výstupní data pro displej (MM:SS.cc -> 6 * 4 bity = 24 bitů)
        display_data   : out STD_LOGIC_VECTOR (23 downto 0)
    );
end stopwatch_logic;

architecture Behavioral of stopwatch_logic is

    

begin

    

end Behavioral;