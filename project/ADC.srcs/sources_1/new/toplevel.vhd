library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;




entity potentiometer_angle_display is
    Port (
        CLK100MHZ : in  STD_LOGIC;
        XA_P      : in  STD_LOGIC;
        XA_N      : in  STD_LOGIC;
        CA        : out STD_LOGIC;
        CB        : out STD_LOGIC;
        CC        : out STD_LOGIC;
        CD        : out STD_LOGIC;
        CE        : out STD_LOGIC;
        CF        : out STD_LOGIC;
        CG        : out STD_LOGIC;
        DP        : out STD_LOGIC;
        AN        : out STD_LOGIC_VECTOR(7 downto 0)
    );
end potentiometer_angle_display;

architecture Structural of potentiometer_angle_display is
    signal xadc_data  : STD_LOGIC_VECTOR(15 downto 0);
    signal angle      : STD_LOGIC_VECTOR(11 downto 0);
    signal seg        : STD_LOGIC_VECTOR(6 downto 0);
begin
    -- Propojení modulů
    CA <= seg(6);
    CB <= seg(5);
    CC <= seg(4);
    CD <= seg(3);
    CE <= seg(2);
    CF <= seg(1);
    CG <= seg(0);

    -- Instance modulů
    reader: entity work.potentiometer_reader
    port map(
        clk => CLK100MHZ,
        vauxp => XA_P,
        vauxn => XA_N,
        analog_data => xadc_data
    );
    
    converter: entity work.angle_converter
    port map(
        adc_value => xadc_data,
        angle => angle
    );
    
    display: entity work.seven_segment_display
    port map(
        clk => CLK100MHZ,
        value => angle,
        seg => seg,
        dp => DP,
        an => AN
    );
end Structural;