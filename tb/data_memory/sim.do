add wave sim:/tb_data_memory/clk
add wave -radix unsigned sim:/tb_data_memory/addr_in
add wave -radix unsigned sim:/tb_data_memory/dut/block_addr_0
add wave -radix unsigned sim:/tb_data_memory/dut/block_addr_1
add wave  -radix unsigned sim:/tb_data_memory/dut/block_addr_2
add wave  -radix unsigned sim:/tb_data_memory/dut/block_addr_3
add wave  -radix unsigned sim:/tb_data_memory/dut/shifted_addr_0
add wave  -radix unsigned sim:/tb_data_memory/dut/shifted_addr_1
add wave  -radix unsigned sim:/tb_data_memory/dut/shifted_addr_2
add wave  -radix unsigned sim:/tb_data_memory/dut/shifted_addr_3
add wave -radix hexadecimal sim:/tb_data_memory/wr_data
add wave -radix binary sim:/tb_data_memory/mem_wr
add wave -radix hexadecimal sim:/tb_data_memory/rd_data
add wave -radix hexadecimal sim:/tb_data_memory/dut/block_ram_0/mem
add wave -radix hexadecimal sim:/tb_data_memory/dut/block_ram_1/mem
add wave -radix hexadecimal sim:/tb_data_memory/dut/block_ram_2/mem
add wave -radix hexadecimal sim:/tb_data_memory/dut/block_ram_3/mem



config wave -signalnamewidth 1

run 4500

