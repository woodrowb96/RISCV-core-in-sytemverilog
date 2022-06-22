add wave -radix decimal sim:/tb_alu/alu_op
add wave -radix decimal sim:/tb_alu/in_a
add wave -radix decimal sim:/tb_alu/in_b
add wave -radix decimal sim:/tb_alu/dut/result
add wave -radix decimal sim:/tb_alu/dut/temp
add wave -radix decimal sim:/tb_alu/result
add wave sim:/tb_alu/zero



config wave -signalnamewidth 1
run 6000

