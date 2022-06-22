add wave sim:/tb_ram_control/clk
add wave sim:/tb_ram_control/reset_n

add wave -divider -height 20 in
add wave -radix unsigned sim:/tb_ram_control/ram_wr_start
add wave -radix unsigned sim:/tb_ram_control/ram_wr_addr_base
add wave -radix hexadecimal sim:/tb_ram_control/ram_wr_data_in
add wave -radix unsigned sim:/tb_ram_control/ram_rd_start
add wave -radix unsigned sim:/tb_ram_control/ram_rd_addr_base
add wave -radix hexadecimal sim:/tb_ram_control/ram_rd_data_out

add wave -divider -height 20 out_write
add wave -radix unsigned sim:/tb_ram_control/dut/wr_state_present
add wave -radix unsigned sim:/tb_ram_control/ram_wr_done
add wave -radix unsigned sim:/tb_ram_control/ram_wr_en
add wave -radix unsigned sim:/tb_ram_control/ram_wr_addr
add wave -radix hexadecimal sim:/tb_ram_control/ram_wr_data_out

add wave -divider -height 20 out_rd
add wave -radix unsigned sim:/tb_ram_control/ram_rd_done
add wave -radix unsigned sim:/tb_ram_control/dut/rd_state_present
add wave -radix unsigned sim:/tb_ram_control/dut/ram_rd_addr
add wave -radix hexadecimal sim:/tb_ram_control/dut/ram_rd_data_in


add wave -radix hexadecimal sim:/tb_ram_control/ram/mem

config wave -signalnamewidth 1

run 1500

