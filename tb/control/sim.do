add wave sim:/tb_control/clk
add wave sim:/tb_control/reset_n

add wave -divider -height 20 instruction_parse
add wave -radix hexadecimal sim:/tb_control/instruction
add wave -radix binary sim:/tb_control/dut/funct_3 
add wave -radix binary sim:/tb_control/dut/funct_7
add wave sim:/tb_control/dut/opcode

add wave -divider -height 20 instruction_decode
add wave sim:/tb_control/dut/operation
add wave sim:/tb_control/instruction_type
add wave -radix binary sim:/tb_control/reg_file_wr
add wave -radix binary sim:/tb_control/reg_wr_sel
add wave sim:/tb_control/alu_op
add wave -radix binary sim:/tb_control/alu_sel_1
add wave -radix binary sim:/tb_control/alu_sel_2
add wave -radix binary sim:/tb_control/mem_wr
add wave -radix binary sim:/tb_control/wb_sel
add wave -radix binary sim:/tb_control/branch
add wave -radix binary sim:/tb_control/jump


add wave -divider -height 20 instruction_memory
add wave sim:/tb_control/instruction_memory/block_ram_0/mem


config wave -signalnamewidth 1

run 4000


