add wave sim:/tb_register_file/clk
add wave sim:/tb_register_file/reg_file_wr_en

add wave sim:/tb_register_file/wr_addr
add wave -radix hexadecimal sim:/tb_register_file/data_in
add wave sim:/tb_register_file/dut/data_in
add wave sim:/tb_register_file/rd_addr_1
add wave sim:/tb_register_file/rd_addr_2
add wave sim:/tb_register_file/rd_data_1
add wave sim:/tb_register_file/rd_data_2
add wave sim:/tb_register_file/dut/reg_file

radix signal sim:/tb_register_file/wr_addr  hexadecimal
radix signal sim:/tb_register_file/rd_addr_1  unsigned
radix signal sim:/tb_register_file/rd_addr_2 unsigned
radix signal sim:/tb_register_file/rd_data_1 unsigned
radix signal sim:/tb_register_file/rd_data_2  unsigned
radix signal sim:/tb_register_file/dut/reg_file  hexadecimal

config wave -signalnamewidth 1


run 1000

