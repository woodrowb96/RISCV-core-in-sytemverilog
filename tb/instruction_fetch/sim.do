add wave sim:/tb_instruction_fetch/clk
add wave sim:/tb_instruction_fetch/reset_n

add wave -divider -height 20 instruction_fetch 
add wave -radix unsigned sim:/tb_instruction_fetch/jump_branch_condition
add wave -radix unsigned sim:/tb_instruction_fetch/jump_branch_address
add wave -radix unsigned sim:/tb_instruction_fetch/pc
add wave -radix unsigned sim:/tb_instruction_fetch/dut/instruction_memory/shifted_addr
add wave -radix unsigned sim:/tb_instruction_fetch/instruction

add wave -divider -height 20 register_file
add wave -radix hexadecimal sim:/tb_instruction_fetch/dut/instruction_memory/block_ram_0/mem


config wave -signalnamewidth 1

run 1000


