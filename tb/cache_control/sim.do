add wave sim:/tb_cache_control/clk
add wave sim:/tb_cache_control/reset_n

add wave -divider -height 20 instrucion_mem_access
add wave -radix unsigned sim:/tb_cache_control/instruction_mem_addr
add wave -radix hexadecimal sim:/tb_cache_control/instruction_cache_stall
add wave -radix hexadecimal sim:/tb_cache_control/instruction_cache_wr_en
add wave -radix hexadecimal sim:/tb_cache_control/instruction_cache/block_addr.ZERO
add wave -radix hexadecimal sim:/tb_cache_control/instruction_cache/block_index.ZERO
add wave -radix binary sim:/tb_cache_control/instruction_cache_miss
add wave -radix hexadecimal sim:/tb_cache_control/instruction_cache_tag
add wave -radix hexadecimal sim:/tb_cache_control/instruction

add wave -divider -height 20 data_mem_access
add wave -radix unsigned sim:/tb_cache_control/data_mem_addr
add wave -radix unsigned sim:/tb_cache_control/data_mem_wr_en
add wave -radix unsigned sim:/tb_cache_control/data_mem_wr_data
add wave -radix hexadecimal sim:/tb_cache_control/data_cache_stall
add wave -radix hexadecimal sim:/tb_cache_control/data_cache_wr_en
add wave -radix hexadecimal sim:/tb_cache_control/data_cache/block_addr.ZERO
add wave -radix hexadecimal sim:/tb_cache_control/data_cache/block_index.ZERO
add wave -radix hexadecimal sim:/tb_cache_control/data_cache/access_addr.ZERO
add wave -radix hexadecimal sim:/tb_cache_control/data_cache/access_addr.ONE
add wave -radix hexadecimal sim:/tb_cache_control/data_cache/access_addr.TWO
add wave -radix hexadecimal sim:/tb_cache_control/data_cache/access_addr.THREE
add wave -radix binary sim:/tb_cache_control/data_cache/miss
add wave -radix binary sim:/tb_cache_control/data_cache_miss
add wave -radix binary sim:/tb_cache_control/data_cache_valid
add wave -radix hexadecimal sim:/tb_cache_control/data_cache_tag
add wave -radix hexadecimal sim:/tb_cache_control/data_mem_rd_type
add wave -radix hexadecimal sim:/tb_cache_control/data_mem_rd_data


add wave -divider -height 20 cache_control
add wave -radix hexadecimal sim:/tb_cache_control/instruction_cache_stall
add wave -radix hexadecimal sim:/tb_cache_control/data_cache_stall
add wave -radix hexadecimal sim:/tb_cache_control/dut/miss
add wave -radix hexadecimal sim:/tb_cache_control/dut/valid
add wave -radix hexadecimal sim:/tb_cache_control/dut/ram_wr_done
add wave -radix hexadecimal sim:/tb_cache_control/dut/ram_rd_done
add wave -radix hexadecimal sim:/tb_cache_control/dut/cache_control_state_machine/present_state
add wave -radix hexadecimal sim:/tb_cache_control/cache_wr_en
add wave -radix hexadecimal sim:/tb_cache_control/cache_rd_type
add wave -radix unsigned sim:/tb_cache_control/cache_addr
add wave -radix hexadecimal sim:/tb_cache_control/cache_wr_data

add wave -divider -height 20 ram_control_wr
add wave -radix hexadecimal sim:/tb_cache_control/dut/ram_control/wr_present_state
add wave -radix hexadecimal sim:/tb_cache_control/ram_wr_en
add wave -radix hexadecimal sim:/tb_cache_control/dut/cache_control_state_machine/tag
add wave -radix unsigned sim:/tb_cache_control/ram_wr_addr_out
add wave -radix hexadecimal sim:/tb_cache_control/dut/ram_wr_data
add wave -radix hexadecimal sim:/tb_cache_control/ram_wr_data_out

add wave -divider -height 20 ram_control_rd
add wave -radix hexadecimal sim:/tb_cache_control/dut/ram_control/rd_present_state
add wave -radix unsigned sim:/tb_cache_control/ram_rd_addr_out
add wave -radix hexadecimal sim:/tb_cache_control/ram_rd_data_in
add wave -radix hexadecimal sim:/tb_cache_control/dut/ram_rd_data

add wave -divider -height 20 ram
add wave -radix hexadecimal sim:/tb_cache_control/ram/mem

add wave -divider -height 20 instruction_cache
add wave -radix hexadecimal sim:/tb_cache_control/instruction_cache/valid
add wave -radix hexadecimal sim:/tb_cache_control/instruction_cache/tag
add wave -radix hexadecimal sim:/tb_cache_control/instruction_cache/block_ram_0/mem
add wave -radix hexadecimal sim:/tb_cache_control/instruction_cache/block_ram_1/mem
add wave -radix hexadecimal sim:/tb_cache_control/instruction_cache/block_ram_2/mem
add wave -radix hexadecimal sim:/tb_cache_control/instruction_cache/block_ram_3/mem


add wave -divider -height 20 data_cache
add wave -radix hexadecimal sim:/tb_cache_control/data_cache/valid
add wave -radix hexadecimal sim:/tb_cache_control/data_cache/tag
add wave -radix hexadecimal sim:/tb_cache_control/data_cache/block_ram_0/mem
add wave -radix hexadecimal sim:/tb_cache_control/data_cache/block_ram_1/mem
add wave -radix hexadecimal sim:/tb_cache_control/data_cache/block_ram_2/mem
add wave -radix hexadecimal sim:/tb_cache_control/data_cache/block_ram_3/mem



config wave -signalnamewidth 1

run 7000

