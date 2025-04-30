library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity binary_to_bcd is
    generic(
        bits    : INTEGER := 12;
        digits  : INTEGER := 3
    );
    port(
        clk     : in  STD_LOGIC;
        reset   : in  STD_LOGIC;
        binary  : in  STD_LOGIC_VECTOR(bits-1 downto 0);
        bcd     : out STD_LOGIC_VECTOR(digits*4-1 downto 0)
    );
end binary_to_bcd;

architecture Behavioral of binary_to_bcd is
    type states is (start, shift, done);
    signal state : states;
    signal binary_reg : unsigned(bits-1 downto 0);
    signal bcd_reg : unsigned(digits*4-1 downto 0);
    signal counter : integer range 0 to bits;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            state <= start;
        elsif rising_edge(clk) then
            case state is
                when start =>
                    binary_reg <= unsigned(binary);
                    bcd_reg <= (others => '0');
                    counter <= 0;
                    state <= shift;
                
                when shift =>
                    if counter < bits then
                        -- Shift left
                        bcd_reg <= bcd_reg(digits*4-2 downto 0) & binary_reg(bits-1);
                        binary_reg <= binary_reg(bits-2 downto 0) & '0';
                        
                        -- Korekce BCD
                        for i in 0 to digits-1 loop
                            if bcd_reg(i*4+3 downto i*4) > 4 then
                                bcd_reg(i*4+3 downto i*4) <= bcd_reg(i*4+3 downto i*4) + 3;
                            end if;
                        end loop;
                        
                        counter <= counter + 1;
                    else
                        state <= done;
                    end if;
                
                when done =>
                    bcd <= std_logic_vector(bcd_reg);
                    state <= start;
            end case;
        end if;
    end process;
end Behavioral;