## Clock Constraints
create_clock -period 10.000 [get_ports clk] # 100 MHz clock

## Input Pin Assignments
set_property PACKAGE_PIN J15 [get_ports rst]      # Reset pin
set_property PACKAGE_PIN H17 [get_ports wr_en]   # Write Enable
set_property PACKAGE_PIN K13 [get_ports rd_en]   # Read Enable
set_property PACKAGE_PIN M13 [get_ports data_in[*]]  # Data Input

## Output Pin Assignments
set_property PACKAGE_PIN L18 [get_ports data_out[*]] # Data Output
set_property PACKAGE_PIN P15 [get_ports full]        # Full flag
set_property PACKAGE_PIN R17 [get_ports empty]       # Empty flag
