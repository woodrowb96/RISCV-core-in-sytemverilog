add wave sim:/tb_data_path/clk
add wave sim:/tb_data_path/reset_n

add wave -divider -height 20 instruction_fetch 
add wave -radix unsigned sim:/tb_data_path/dut/alu/zero 
add wave -radix unsigned sim:/tb_data_path/dut/branch
add wave -radix unsigned sim:/tb_data_path/dut/pc_sel
add wave -radix unsigned sim:/tb_data_path/dut/pc
add wave -radix unsigned sim:/tb_data_path/dut/instruction_memory/shifted_addr
add wave -radix unsigned sim:/tb_data_path/dut/pc_increment
add wave -radix hexadecimal sim:/tb_data_path/dut/instruction

add wave -divider -height 20 instruction_decode
add wave -radix unsigned sim:/tb_data_path/reg_file_wr
add wave -radix unsigned sim:/tb_data_path/dut/register_file/rd_addr_1
add wave -radix unsigned sim:/tb_data_path/dut//register_file/rd_addr_2
add wave -radix decimal sim:/tb_data_path/dut/rd_data_1
add wave -radix decimal sim:/tb_data_path/dut/rd_data_2
add wave sim:/tb_data_path/instruction_type
add wave -radix decimal sim:/tb_data_path/dut/immediate

add wave -radix unsigned -divider -height 20 execute
add wave -radix unsigned sim:/tb_data_path/alu_op
add wave -radix unsigned sim:/tb_data_path/alu_sel_1
add wave -radix unsigned sim:/tb_data_path/alu_sel_2
add wave -radix decimal sim:/tb_data_path/dut/alu/in_a
add wave -radix decimal sim:/tb_data_path/dut/alu/in_b
add wave -radix decimal sim:/tb_data_path/dut/alu/result
add wave -radix unsigned sim:/tb_data_path/dut/alu/zero


add wave -divider -height 20 memory_access
add wave -radix unsigned sim:/tb_data_path/mem_wr
add wave -radix unsigned sim:/tb_data_path/dut/data_memory/addr_in
add wave -radix unsigned sim:/tb_data_path/dut/data_memory/shifted_addr_0
add wave -radix decimal sim:/tb_data_path/dut/data_memory/wr_data
add wave -radix decimal sim:/tb_data_path/dut/data_memory/rd_data

add wave -divider -height 20 write_back
add wave -radix unsigned sim:/tb_data_path/dut/wb_sel
add wave -radix unsigned sim:/tb_data_path/dut/register_file/wr_addr
add wave -radix decimal sim:/tb_data_path/dut/wr_data

add wave -divider -height 20 register_file
add wave -radix decimal sim:/tb_data_path/dut/register_file/reg_file
add wave -radix decimal sim:/tb_data_path/dut/instruction_memory/block_ram_0/mem
add wave -radix decimal sim:/tb_data_path/dut/data_memory/block_ram_0/mem


config wave -signalnamewidth 1

run 2000


