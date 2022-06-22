add wave -radix unsigned  sim:/tb_instruction_memory/clk
add wave -radix unsigned  sim:/tb_instruction_memory/addr
add wave -radix unsigned sim:/tb_instruction_memory/instruction
add wave -radix unsigned sim:/tb_instruction_memory/dut/shifted_addr
add wave -radix unsigned sim:/tb_instruction_memory/dut/block_ram_0/mem

config wave -signalnamewidth 1

run 1500

