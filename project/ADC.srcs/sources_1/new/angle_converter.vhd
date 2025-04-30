library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity angle_converter is
    Port (
        adc_value : in  STD_LOGIC_VECTOR(15 downto 0);
        angle     : out STD_LOGIC_VECTOR(11 downto 0)
    );
end angle_converter;

architecture Behavioral of angle_converter is
begin
    process(adc_value)
        variable temp : unsigned(23 downto 0);
    begin
        -- Přesný výpočet: angle = (adc_value * 300) / 4095
        temp := unsigned(adc_value(15 downto 4)) * to_unsigned(301, 12);
        angle <= std_logic_vector(temp(23 downto 12)); -- Automatické dělení 4096
    end process;
end Behavioral;