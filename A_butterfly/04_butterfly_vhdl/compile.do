vlib work
echo "compiling..."

vcom register_sfixed.vhd
vcom pipe_sfixed.vhd
vcom reg_rising.vhd
vcom reg_falling.vhd
vcom mux2to1_sfixed.vhd
vcom mux4to1_sfixed.vhd
vcom mux2to1.vhd
vcom mux4to1.vhd
vcom adder_pipe_sfixed.vhd
vcom subtractor_pipe_sfixed.vhd
vcom mpy_shifter_pipe_sfixed.vhd
vcom rounder_sfixed.vhd
vcom uROM_butterfly.vhd
vcom status_PLA_butterfly.vhd
vcom register_file.vhd
vcom CU_butterfly.vhd
vcom butterfly.vhd
vcom tb_butterfly.vhd

vsim -c work.tb_butterfly

run 0ns
run 26.95us

#write list counter.lst
quit -f