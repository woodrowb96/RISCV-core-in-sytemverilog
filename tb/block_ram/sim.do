add wave sim:/tb_block_ram/clk
add wave sim:/tb_block_ram/reset_n


add wave -radix unsigned sim:/tb_block_ram/dut/wr_en 
add wave -radix unsigned sim:/tb_block_ram/dut/addr 
add wave -radix hexadecimal sim:/tb_block_ram/dut/data_in 
add wave -radix hexadecimal sim:/tb_block_ram/dut/data_out 


add wave -radix hexadecimal sim:/tb_block_ram/dut/mem

config wave -signalnamewidth 1

run 1500


