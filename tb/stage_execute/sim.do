add wave sim:/tb_execute/clk
add wave sim:/tb_execute/reset_n

add wave -divider -height 20 alu
add wave -radix hexadecimal sim:/tb_execute/alu_sel_1

add wave -radix hexadecimal sim:/tb_execute/alu_sel_2
add wave -radix hexadecimal sim:/tb_execute/alu_op
add wave -radix decimal sim:/tb_execute/reg_file_rd_data_1
add wave -radix decimal sim:/tb_execute/pc
add wave -radix decimal sim:/tb_execute/reg_file_rd_data_2
add wave -radix decimal sim:/tb_execute/immediate
add wave -radix decimal sim:/tb_execute/alu_result



config wave -signalnamewidth 1

run 1000


