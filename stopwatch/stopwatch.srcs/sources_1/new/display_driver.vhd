library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity display_driver is
    Port ( 
        clk    : in  STD_LOGIC;
        rst    : in  STD_LOGIC;
        
        -- Input data from stopwatch logic (8 digits x 4 bits = 32 bits)
        data_i : in  STD_LOGIC_VECTOR (31 downto 0);
        
        -- Outputs directly to FPGA pins
        seg_o  : out STD_LOGIC_VECTOR (6 downto 0); -- Cathodes (Active Low)
        dp_o   : out STD_LOGIC;                     -- Decimal Point (Active Low)
        an_o   : out STD_LOGIC_VECTOR (7 downto 0)  -- Anodes (Active Low)
    );
end display_driver;

architecture Behavioral of display_driver is

    -- 17-bit counter for multiplexing (~762 Hz refresh rate on 100MHz clock)
    signal refresh_cnt : unsigned(16 downto 0) := (others => '0');
    -- Top 3 bits of the counter used to select the active digit (0 to 7)
    signal digit_sel   : std_logic_vector(2 downto 0);
    -- Holds the 4-bit value currently being drawn on the screen
    signal current_hex : std_logic_vector(3 downto 0);

begin

    -- 1. REFRESH COUNTER
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

    digit_sel <= std_logic_vector(refresh_cnt(16 downto 14));

    -- 2. ANODE, DATA, AND DECIMAL POINT MULTIPLEXER
    process(digit_sel, data_i)
    begin
        -- Default values to prevent latches
        an_o        <= "11111111"; -- All anodes OFF
        current_hex <= "1010";     -- Default to blank (Hex 'A')
        dp_o        <= '1';        -- Decimal point OFF

        case digit_sel is
            when "000" => 
                an_o <= "11111110"; -- Turn on AN0 (Hundredths ones)
                current_hex <= data_i(3 downto 0);
                
            when "001" => 
                an_o <= "11111101"; -- Turn on AN1 (Hundredths tens)
                current_hex <= data_i(7 downto 4);
                
            when "010" => 
                an_o <= "11111011"; -- Turn on AN2 (Seconds ones)
                current_hex <= data_i(11 downto 8);
                dp_o <= '0';        -- Turn ON DP (dot after seconds)
                
            when "011" => 
                an_o <= "11110111"; -- Turn on AN3 (Seconds tens)
                current_hex <= data_i(15 downto 12);
                
            when "100" => 
                an_o <= "11101111"; -- Turn on AN4 (Minutes ones)
                current_hex <= data_i(19 downto 16);
                dp_o <= '0';        -- Turn ON DP (dot after minutes)
                
            when "101" => 
                an_o <= "11011111"; -- Turn on AN5 (Minutes tens)
                current_hex <= data_i(23 downto 20);
                
            when "110" => 
                an_o <= "10111111"; -- Turn on AN6 (Always Blank)
                current_hex <= data_i(27 downto 24);
                
            when "111" => 
                an_o <= "01111111"; -- Turn on AN7 (L or Blank)
                current_hex <= data_i(31 downto 28);
                
            when others => 
                an_o <= "11111111";
        end case;
    end process;

    -- 3. HEX TO 7-SEGMENT DECODER (Active Low)
    process(current_hex)
    begin
        case current_hex is
            when "0000" => seg_o <= "1000000"; -- 0
            when "0001" => seg_o <= "1111001"; -- 1
            when "0010" => seg_o <= "0100100"; -- 2
            when "0011" => seg_o <= "0110000"; -- 3
            when "0100" => seg_o <= "0011001"; -- 4
            when "0101" => seg_o <= "0010010"; -- 5
            when "0110" => seg_o <= "0000010"; -- 6
            when "0111" => seg_o <= "1111000"; -- 7
            when "1000" => seg_o <= "0000000"; -- 8
            when "1001" => seg_o <= "0010000"; -- 9
            
            -- Custom characters for our logic
            when "1010" => seg_o <= "1111111"; -- A: Blank (All segments OFF)
            when "1011" => seg_o <= "1110001"; -- B: Letter 'L' (Segments D,E,F ON)
            
            when others => seg_o <= "1111111"; -- Default: Blank
        end case;
    end process;

end Behavioral;