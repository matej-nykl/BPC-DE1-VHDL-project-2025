# Potentiometer Angle Display for Nexys A7-50T

## Team Members
- **Šimon Navrátil** - 7 segment implemetatation
- **Petr Tomeček** - Angle conversion algorithm + Bugfixes
- **Zdeněk Pospíšil** - Circuit integration specialist
- **Matěj Nykl** - XADC interface implementation
## Abstract
This VHDL project implements a real-time potentiometer angle measurement system on the Nexys A7-50T FPGA board. The system:
- Reads analog voltage from a potentiometer using the Xilinx XADC (Analog-to-Digital Converter)
- Converts the reading to an angle value (0-300°)
- Displays the current angle on the 7-segment display
- Updates the display continuously as the potentiometer is rotated

## Hardware Implementation

### Block Diagram
![System Block Diagram](Schematic.png)

### Key Components
1. **Nexys A7-50T FPGA Board**
2. **Potentiometer** connected to JXADC header (Pins A13/A14)
3. **7-segment display** for angle visualization

### Pin Connections
| FPGA Pin | Signal      | Description               |
|----------|-------------|---------------------------|
| E3       | CLK100MHZ   | 100 MHz system clock      |
| A13      | XA_P        | Potentiometer + input     |
| A14      | XA_N        | Potentiometer - input     |
| T10-R10  | CA-CG       | 7-segment display segments|
| J17-U13  | AN[0:7]     | Display digit selection   |

## Software Implementation

### Main Components
1. **Potentiometer Reader** (`potentiometer_reader.vhd`)
   - Interfaces with XADC core
   - Reads 12-bit ADC values (0-4095)
   - Handles XADC configuration and data ready signals

2. **Angle Converter** (`angle_converter.vhd`)
   - Converts raw ADC value to angle (0-300°)
   - Uses formula: `angle = (adc_value * 300) / 4095`
   - Provides 12-bit angle output

3. **7-Segment Display Controller** (`seven_segment_display.vhd`)
   - Converts binary angle to BCD format
   - Implements multiplexed display refresh
   - Handles active-low segment driving

### Simulation Results
![XADC Simulation](simulation_xadc.png)
*Figure 1: XADC interface simulation showing analog-to-digital conversion*

### Video of the project
[Click here !](https://youtu.be/ENF9i8tKyDE)

## References
1. Nexys A7 Reference Manual, Digilent Inc.
2. Xilinx 7 Series FPGAs XADC User Guide (UG480)
3. VHDL Programming by Example, Douglas Perry


