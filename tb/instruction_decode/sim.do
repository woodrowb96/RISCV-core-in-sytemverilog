add wave sim:/tb_instruction_decode/clk
add wave sim:/tb_instruction_decode/reset_n

add wave -divider -height 20 instruction_decode
add wave -radix hexadecimal sim:/tb_instruction_decode/instruction
add wave -radix unsigned sim:/tb_instruction_decode/reg_file_wr_addr_out

add wave -divider -height 20 register_file_read
add wave -radix unsigned sim:/tb_instruction_decode/dut/register_file/rd_addr_1
add wave -radix unsigned sim:/tb_instruction_decode/dut/register_file/rd_addr_2
add wave -radix unsigned sim:/tb_instruction_decode/reg_file_rd_data_1
add wave -radix unsigned sim:/tb_instruction_decode/reg_file_rd_data_2

add wave -divider -height 20 register_file_write
add wave -radix unsigned sim:/tb_instruction_decode/reg_file_wr_addr_in
add wave -radix unsigned sim:/tb_instruction_decode/reg_file_wr_en
add wave -radix unsigned sim:/tb_instruction_decode/reg_file_wr_sel
add wave -radix unsigned sim:/tb_instruction_decode/write_back_data
add wave -radix unsigned sim:/tb_instruction_decode/pc_jump_return_addr

add wave -divider -height 20 immediate_gen
add wave -radix unsigned sim:/tb_instruction_decode/instruction_type
add wave -radix decimal sim:/tb_instruction_decode/immediate




add wave -divider -height 20 register_file
add wave -radix unsigned sim:/tb_instruction_decode/dut/register_file/reg_file


config wave -signalnamewidth 1

run 1000


