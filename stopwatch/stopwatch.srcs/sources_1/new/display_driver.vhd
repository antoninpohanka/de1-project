library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- use IEEE.NUMERIC_STD.ALL; -- Bude se hodit pro čítač

entity display_driver is
    Port ( 
        clk    : in  STD_LOGIC;
        rst    : in  STD_LOGIC;
        
        -- Vstupní data z hlavní logiky (8 číslic, každá 4 bity)
        data_i : in  STD_LOGIC_VECTOR (31 downto 0);
        
        -- Výstupy fyzicky na desku
        seg_o  : out STD_LOGIC_VECTOR (6 downto 0);
        dp_o   : out STD_LOGIC;
        an_o   : out STD_LOGIC_VECTOR (7 downto 0)
    );
end display_driver;

architecture Behavioral of display_driver is

    

begin

    

end Behavioral;