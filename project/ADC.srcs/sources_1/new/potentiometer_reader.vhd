library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity potentiometer_reader is
    Port (
        clk         : in  STD_LOGIC;
        vauxp       : in  STD_LOGIC;
        vauxn       : in  STD_LOGIC;
        analog_data : out STD_LOGIC_VECTOR(15 downto 0)
    );
end potentiometer_reader;

architecture Behavioral of potentiometer_reader is
    component xadc_wiz_0
    port(
        daddr_in    : in  STD_LOGIC_VECTOR(6 downto 0);
        den_in      : in  STD_LOGIC;
        di_in       : in  STD_LOGIC_VECTOR(15 downto 0);
        dwe_in      : in  STD_LOGIC;
        do_out      : out STD_LOGIC_VECTOR(15 downto 0);
        drdy_out    : out STD_LOGIC;
        dclk_in     : in  STD_LOGIC;
        vauxp3      : in  STD_LOGIC;
        vauxn3      : in  STD_LOGIC;
        busy_out    : out STD_LOGIC;
        channel_out : out STD_LOGIC_VECTOR(4 downto 0);
        eoc_out     : out STD_LOGIC;
        eos_out     : out STD_LOGIC;
        alarm_out   : out STD_LOGIC;
        vp_in       : in  STD_LOGIC;
        vn_in       : in  STD_LOGIC
    );
    end component;

    signal do      : STD_LOGIC_VECTOR(15 downto 0);
    signal drdy    : STD_LOGIC;
    signal eoc     : STD_LOGIC;
    
begin
    xadc_inst : xadc_wiz_0
    port map(
        daddr_in    => "0010011",       -- Channel 13 (VAUX3)
        den_in      => eoc,
        di_in       => (others => '0'),
        dwe_in      => '0',
        do_out      => do,
        drdy_out    => drdy,
        dclk_in     => clk,
        vauxp3      => vauxp,
        vauxn3      => vauxn,
        busy_out    => open,
        channel_out => open,
        eoc_out     => eoc,
        eos_out     => open,
        alarm_out   => open,
        vp_in       => '0',
        vn_in       => '0'
    );

    process(clk)
    begin
        if rising_edge(clk) then
            if drdy = '1' then
                analog_data <= do; -- Uložení 12-bitové hodnoty (0-4095 pro 0-1V)
            end if;
        end if;
    end process;
    
end Behavioral;