add wave sim:/tb_branch_decision/clk
add wave sim:/tb_branch_decision/reset_n

add wave -radix decimal sim:/tb_branch_decision/branch_type
add wave -radix decimal sim:/tb_branch_decision/reg_file_rd_data_1
add wave -radix decimal sim:/tb_branch_decision/reg_file_rd_data_2
add wave -radix decimal sim:/tb_branch_decision/branch_decision
add wave -radix decimal sim:/tb_branch_decision/pc
add wave -radix decimal sim:/tb_branch_decision/immediate
add wave -radix decimal sim:/tb_branch_decision/branch_target

config wave -signalnamewidth 1

run 2000


