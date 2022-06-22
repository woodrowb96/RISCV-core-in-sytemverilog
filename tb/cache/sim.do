add wave sim:/tb_cache/clk
add wave sim:/tb_cache/reset_n


add wave -divider -height 20 writting_in
add wave -radix unsigned sim:/tb_cache/rd_type_in
add wave -radix unsigned sim:/tb_cache/addr_in
add wave sim:/tb_cache/wr_en_in
add wave -radix hexadecimal sim:/tb_cache/wr_data_in
add wave sim:/tb_cache/dut/miss
add wave sim:/tb_cache/cache_miss
add wave sim:/tb_cache/valid_data


add wave -divider -height 20 cache_control
add wave sim:/tb_cache/cache_stall
add wave sim:/tb_cache/cache_wr_en
add wave -radix unsigned sim:/tb_cache/cache_addr
add wave -radix hexadecimal sim:/tb_cache/cache_wr_data
add wave sim:/tb_cache/cache_rd_type
add wave -radix hexadecimal sim:/tb_cache/rd_data_out

add wave -divider -height 20 writting
add wave sim:/tb_cache/dut/wr_en
add wave -radix unsigned sim:/tb_cache/dut/addr_val
add wave -radix hexadecimal sim:/tb_cache/dut/wr_data
add wave sim:/tb_cache/dut/rd_type
add wave -radix unsigned sim:/tb_cache/dut/block_addr.ZERO
add wave  -radix unsigned sim:/tb_cache/dut/block_wr_en.ZERO
add wave -radix unsigned  sim:/tb_cache/dut/block_wr_en.ONE
add wave -radix unsigned  sim:/tb_cache/dut/block_wr_en.TWO
add wave -radix unsigned  sim:/tb_cache/dut/block_wr_en.THREE
add wave -radix unsigned  sim:/tb_cache/dut/block_index.ZERO
add wave  -radix unsigned sim:/tb_cache/dut/block_index.ONE
add wave  -radix unsigned sim:/tb_cache/dut/block_index.TWO
add wave  -radix unsigned sim:/tb_cache/dut/block_index.THREE
add wave  -radix unsigned sim:/tb_cache/dut/block_tag.ZERO
add wave  -radix unsigned sim:/tb_cache/dut/block_tag.ONE
add wave  -radix unsigned sim:/tb_cache/dut/block_tag.TWO
add wave  -radix unsigned sim:/tb_cache/dut/block_tag.THREE

add wave -divider -height 20 cache_block_0
add wave -radix hexadecimal sim:/tb_cache/dut/valid
add wave -radix unsigned sim:/tb_cache/dut/tag
add wave -radix hexadecimal sim:/tb_cache/dut/block_ram_0/mem
add wave -radix hexadecimal sim:/tb_cache/dut/block_ram_1/mem
add wave -radix hexadecimal sim:/tb_cache/dut/block_ram_2/mem
add wave -radix hexadecimal sim:/tb_cache/dut/block_ram_3/mem


config wave -signalnamewidth 1

run 4500

