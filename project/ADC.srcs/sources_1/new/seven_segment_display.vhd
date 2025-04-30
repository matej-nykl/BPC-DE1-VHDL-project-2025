library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity seven_segment_display is
    Port (
        clk     : in  STD_LOGIC;
        value   : in  STD_LOGIC_VECTOR(11 downto 0);
        seg     : out STD_LOGIC_VECTOR(6 downto 0);
        dp      : out STD_LOGIC;
        an      : out STD_LOGIC_VECTOR(7 downto 0)
    );
end seven_segment_display;

architecture Behavioral of seven_segment_display is
    signal refresh_counter : unsigned(17 downto 0) := (others => '0');
    signal digit_select   : integer range 0 to 3 := 0;
    signal bcd_digit     : STD_LOGIC_VECTOR(3 downto 0);
    signal bcd_value      : STD_LOGIC_VECTOR(15 downto 0);
    
    -- Převod binární na BCD
    function to_bcd(bin : unsigned(11 downto 0)) return STD_LOGIC_VECTOR is
        variable temp : unsigned(11 downto 0);
        variable bcd : unsigned(15 downto 0) := (others => '0');
    begin
        temp := bin;
        for i in 0 to 11 loop
            if bcd(3 downto 0) > 4 then 
                bcd(3 downto 0) := bcd(3 downto 0) + 3;
            end if;
            if bcd(7 downto 4) > 4 then 
                bcd(7 downto 4) := bcd(7 downto 4) + 3;
            end if;
            if bcd(11 downto 8) > 4 then  
                bcd(11 downto 8) := bcd(11 downto 8) + 3;
            end if;
            
            bcd := bcd(14 downto 0) & temp(11);
            temp := temp(10 downto 0) & '0';
        end loop;
        return std_logic_vector(bcd);
    end function;
    
begin
    -- Převod hodnoty na BCD
    bcd_value <= to_bcd(unsigned(value));

    -- Výběr aktuální číslice
    process(digit_select, bcd_value)
    begin
        case digit_select is
            when 0 => bcd_digit <= bcd_value(3 downto 0);   -- Jednotky
            when 1 => bcd_digit <= bcd_value(7 downto 4);   -- Desítky
            when 2 => bcd_digit <= bcd_value(11 downto 8);  -- Stovky
            when others => bcd_digit <= "1111";             -- Vypnuto
        end case;
    end process;

    -- Převodník BCD na 7-segment (aktivní nízká logika pro Nexys A7)
    with bcd_digit select
    seg <= "0000001" when "0000",  -- 0
           "1001111" when "0001",  -- 1
           "0010010" when "0010",  -- 2
           "0000110" when "0011",  -- 3
           "1001100" when "0100",  -- 4
           "0100100" when "0101",  -- 5
           "0100000" when "0110",  -- 6
           "0001111" when "0111",  -- 7
           "0000000" when "1000",  -- 8
           "0000100" when "1001",  -- 9
           "1111111" when others;  -- Vypnuto

    -- Obnovování displeje (cca 100Hz refresh rate)
     process(clk)
    begin
        if rising_edge(clk) then
            refresh_counter <= refresh_counter + 1;
            if refresh_counter = 0 then
                digit_select <= digit_select + 1;
                if digit_select = 3 then
                    digit_select <= 0;
                end if;
            end if;
        end if;
    end process;
    -- Aktivace anod (aktivní nízká logika)
    process(digit_select)
    begin
        an <= (others => '1');  -- Všechny vypnuty
        case digit_select is
            when 0 => an(0) <= '0';  -- První číslice
            when 1 => an(1) <= '0';  -- Druhá číslice
            when 2 => an(2) <= '0';  -- Třetí číslice
            when others => null;
        end case;
    end process;

    dp <= '1';  -- Desetinná tečka stále vypnuta
end Behavioral;