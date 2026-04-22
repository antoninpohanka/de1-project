library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity display_driver is
    Port ( clk    : in STD_LOGIC;
           rst    : in STD_LOGIC;
           data_i : in STD_LOGIC_VECTOR (31 downto 0);
           seg_o  : out STD_LOGIC_VECTOR (6 downto 0);
           dp_o   : out STD_LOGIC;
           an_o   : out STD_LOGIC_VECTOR (7 downto 0));
end display_driver;

architecture Behavioral of display_driver is

    signal refresh_cnt : unsigned(16 downto 0) := (others => '0');
    signal digit_sel   : std_logic_vector(2 downto 0);
    signal current_hex : std_logic_vector(3 downto 0);

begin

    -- Fast counter for display refresh (~762 Hz on 100MHz clock)
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                refresh_cnt <= (others => '0');
            else
                refresh_cnt <= refresh_cnt + 1;
            end if;
        end if;
    end process;

    -- Selection of the active digit using the top 3 bits
    digit_sel <= std_logic_vector(refresh_cnt(16 downto 14));

    -- MULTIPLEXER: Selects which digit is currently lit (Active LOW for Anodes)
    process(digit_sel, data_i)
    begin
        -- Default state: all digits off (anodes high)
        an_o <= "11111111"; 
        current_hex <= "1010"; -- Default character A = Blank (off)
        dp_o <= '1';           -- Decimal point off (active low)

        case digit_sel is
            when "000" =>
                an_o <= "11111110"; -- Rightmost digit (hundredths)
                current_hex <= data_i(3 downto 0);
            when "001" =>
                an_o <= "11111101"; -- Tens of hundredths
                current_hex <= data_i(7 downto 4);
            when "010" =>
                an_o <= "11111011"; -- Seconds
                current_hex <= data_i(11 downto 8);
                dp_o <= '0';        -- Turn on decimal point (separates hundredths and seconds)
            when "011" =>
                an_o <= "11110111"; -- Tens of seconds
                current_hex <= data_i(15 downto 12);
            when "100" =>
                an_o <= "11101111"; -- Minutes
                current_hex <= data_i(19 downto 16);
                dp_o <= '0';        -- Turn on decimal point (separates seconds and minutes)
            when "101" =>
                an_o <= "11011111"; -- Tens of minutes
                current_hex <= data_i(23 downto 20);
            when "110" =>
                an_o <= "10111111"; -- Empty digit
                current_hex <= data_i(27 downto 24); -- Will be blank here (character A from logic)
            when "111" =>
                an_o <= "01111111"; -- Leftmost digit
                current_hex <= data_i(31 downto 28); -- Will display 'L' (character B) or blank (character A)
            when others =>
                an_o <= "11111111";
        end case;
    end process;

    -- DECODER: Translation to individual 7-segment patterns (Active LOW for Cathodes)
    process(current_hex)
    begin
        case current_hex is
            --                  abcdefg (0 = ON, 1 = OFF)
            when "0000" => seg_o <= "0000001"; -- 0
            when "0001" => seg_o <= "1001111"; -- 1
            when "0010" => seg_o <= "0010010"; -- 2
            when "0011" => seg_o <= "0000110"; -- 3
            when "0100" => seg_o <= "1001100"; -- 4
            when "0101" => seg_o <= "0100100"; -- 5
            when "0110" => seg_o <= "0100000"; -- 6
            when "0111" => seg_o <= "0001111"; -- 7
            when "1000" => seg_o <= "0000000"; -- 8
            when "1001" => seg_o <= "0000100"; -- 9
            
            when "1010" => seg_o <= "1111111"; -- A: Completely blank (all segments high)
            when "1011" => seg_o <= "1110001"; -- B: Letter 'L' (segments d, e, f are low)
            
            when others => seg_o <= "1111111"; -- Fallback: turn off for any other characters
        end case;
    end process;

end Behavioral;