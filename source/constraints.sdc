# Synopsys, Inc. constraint file
# C:/Users/ee07pc03adm/Documents/Cardboard_FPGA/source/constraints.sdc
# Written on Mon Mar 26 15:56:41 2018
# by Synplify Pro, L-2016.09L+ice40 Scope Editor

#
# Collections
#

#
# Clocks
#
define_clock   {clk} -name {clk}  -period 5 -clockgroup default_clkgroup_1
define_clock   {p:spi_clk} -name {spi_clk}  -period 1000 -clockgroup default_clkgroup_0

#
# Clock to Clock
#

#
# Inputs/Outputs
#

#
# Registers
#

#
# Delay Paths
#

#
# Attributes
#

#
# I/O Standards
#
define_io_standard               {sensor_signals}
define_io_standard               {spi_clk}
define_io_standard               {spi_out}
define_io_standard               {spi_sn}
define_io_standard               {spi_in}

#
# Compile Points
#

#
# Other
#
