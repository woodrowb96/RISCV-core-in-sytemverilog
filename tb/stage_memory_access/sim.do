add wave sim:/tb_stage_memory_access/clk
add wave sim:/tb_stage_memory_access/reset_n

add wave -divider -height 20 mem_access
add wave -radix decimal sim:/tb_stage_memory_access/data_mem_wr_en
add wave -radix decimal sim:/tb_stage_memory_access/alu_result_in
add wave -radix decimal sim:/tb_stage_memory_access/data_mem_wr_data
add wave -radix decimal sim:/tb_stage_memory_access/data_mem_rd_data


add wave -divider -height 20 pc_sel
add wave -radix hexadecimal sim:/tb_stage_memory_access/jump_branch_signal
add wave -radix hexadecimal sim:/tb_stage_memory_access/zero
add wave -radix hexadecimal sim:/tb_stage_memory_access/pc_sel


config wave -signalnamewidth 1

run 1000


