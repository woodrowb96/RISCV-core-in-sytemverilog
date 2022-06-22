add wave sim:/tb_bubble_sort/clk
add wave sim:/tb_bubble_sort/reset_n

add wave -divider -height 20 cache_control
add wave -radix unsigned sim:/tb_bubble_sort/dut/riscv_core/data_path/stall

add wave -divider -height 20 instrucion_mem_access
add wave -radix unsigned sim:/tb_bubble_sort/dut/riscv_core/cache_control/instruction_mem_addr
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/cache_control/instruction_cache_stall
add wave -radix binary sim:/tb_bubble_sort/dut/riscv_core/cache_control/instruction_cache_miss
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/data_path/instruction.IF

add wave -divider -height 20 data_mem_access
add wave -radix unsigned sim:/tb_bubble_sort/dut/riscv_core/cache_control/data_mem_addr
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/cache_control/data_cache_stall
add wave -radix binary sim:/tb_bubble_sort/dut/riscv_core/cache_control/data_cache_miss
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/cache_control/data_cache_valid
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/cache_control/data_mem_rd_data

add wave -divider -height 20 cache_control
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/cache_control/miss
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/cache_control/valid
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/cache_control/ram_wr_done
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/cache_control/ram_rd_done
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/cache_control/cache_control_state_machine/present_state
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/cache_control/cache_wr_en
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/cache_control/cache_rd_type
add wave -radix unsigned sim:/tb_bubble_sort/dut/riscv_core/cache_control/cache_addr
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/cache_control/cache_wr_data

add wave -divider -height 20 cache
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/data_path/instruction_cache_wr_en_stall_sel
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/data_path/instruction_cache_wr_en
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/data_path/memory_access/data_cache/block_ram_0/mem
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/data_path/data_cache_wr_en_stall_sel
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/data_path/instruction_fetch/instruction_cache/block_ram_0/mem













add wave -divider -height 20 instruction_fetch
add wave -radix unsigned sim:/tb_bubble_sort/dut/riscv_core/data_path/pc.IF
add wave -radix decimal sim:/tb_bubble_sort/dut/riscv_core/data_path/branch_prediction
add wave -radix decimal sim:/tb_bubble_sort/dut/riscv_core/data_path/branch_target.IF
add wave -radix unsigned sim:/tb_bubble_sort/dut/riscv_core/data_path/instruction_fetch/pc_next
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/data_path/instruction_fetch/insert_nop
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/data_path/instruction_fetch/branch_redo
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/data_path/instruction.IF

add wave -divider -height 20 instruction_decode
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/data_path/operation_cntrl.ID
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/data_path/pc.ID
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/data_path/instruction.ID
add wave -radix unsigned sim:/tb_bubble_sort/dut/riscv_core/data_path/instruction_decode/register_file/rd_addr_1
add wave -radix unsigned sim:/tb_bubble_sort/dut/riscv_core/data_path/instruction_decode/register_file/rd_addr_2
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/data_path/reg_file_rd_data_1.ID
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/data_path/reg_file_rd_data_2.ID
add wave -radix unsigned sim:/tb_bubble_sort/dut/riscv_core/data_path/reg_file_wr_addr.ID
add wave -radix decimal sim:/tb_bubble_sort/dut/riscv_core/data_path/reg_file_wr_en_cntrl.WB
add wave -radix unsigned sim:/tb_bubble_sort/dut/riscv_core/data_path/reg_file_wr_addr.WB
add wave -radix decimal sim:/tb_bubble_sort/dut/riscv_core/data_path/write_back_data.WB
add wave -radix decimal sim:/tb_bubble_sort/dut/riscv_core/data_path/immediate.ID
add wave -radix decimal sim:/tb_bubble_sort/dut/riscv_core/data_path/instruction_decode/register_file/reg_file
add wave -radix decimal sim:/tb_bubble_sort/dut/riscv_core/data_path/branch_type_cntrl.ID
add wave -radix decimal sim:/tb_bubble_sort/dut/riscv_core/data_path/branch_decision.ID
add wave -radix decimal sim:/tb_bubble_sort/dut/riscv_core/data_path/branch_prediction_unit/wrong_take_prediction
add wave -radix decimal sim:/tb_bubble_sort/dut/riscv_core/data_path/branch_prediction_unit/wrong_not_take_prediction
add wave -radix decimal sim:/tb_bubble_sort/dut/riscv_core/data_path/branch_prediction_unit/wrong_target_branch
add wave -radix decimal sim:/tb_bubble_sort/dut/riscv_core/data_path/branch_prediction_unit/wrong_target_jump
add wave -radix decimal sim:/tb_bubble_sort/dut/riscv_core/data_path/branch_target.ID

add wave -divider -height 20 fwd_hazard
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/data_path/fwd_reg_file_rd_sel_1
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/data_path/reg_file_rd_data_1.ID
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/data_path/fwd_reg_file_rd_sel_2
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/data_path/reg_file_rd_data_2.ID
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/data_path/instruction_decode/alu_result.EX
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/data_path/instruction_decode/write_back_data.MEM
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/data_path/instruction_decode/write_back_data.WB
add wave -radix decimal sim:/tb_bubble_sort/dut/riscv_core/data_path/fwd_reg_file_rd_data_1.ID
add wave -radix decimal sim:/tb_bubble_sort/dut/riscv_core/data_path/fwd_reg_file_rd_data_2.ID


add wave -divider -height 20 execute
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/data_path/operation_cntrl.EX
add wave -radix unsigned sim:/tb_bubble_sort/dut/riscv_core/data_path/alu_sel_1_cntrl.EX
add wave -radix decimal sim:/tb_bubble_sort/dut/riscv_core/data_path/fwd_reg_file_rd_data_1.EX
add wave -radix decimal sim:/tb_bubble_sort/dut/riscv_core/data_path/pc.EX
add wave -radix unsigned sim:/tb_bubble_sort/dut/riscv_core/data_path/alu_sel_2_cntrl.EX
add wave -radix decimal sim:/tb_bubble_sort/dut/riscv_core/data_path/fwd_reg_file_rd_data_2.EX
add wave -radix decimal sim:/tb_bubble_sort/dut/riscv_core/data_path/immediate.EX	
add wave -radix decimal sim:/tb_bubble_sort/dut/riscv_core/data_path/alu_op_cntrl.EX
add wave -radix decimal sim:/tb_bubble_sort/dut/riscv_core/data_path/alu_result.EX
add wave -radix unsigned sim:/tb_bubble_sort/dut/riscv_core/data_path/reg_file_wr_addr.EX

add wave -divider -height 20 mem_access
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/data_path/operation_cntrl.MEM
add wave -radix unsigned sim:/tb_bubble_sort/dut/riscv_core/data_path/memory_access/data_mem_addr
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/data_path/data_mem_rd_data.MEM
add wave -radix decimal sim:/tb_bubble_sort/dut/riscv_core/data_path/data_mem_wr_en_cntrl.MEM
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/data_path/reg_file_rd_data_2.MEM
add wave -radix unsigned sim:/tb_bubble_sort/dut/riscv_core/data_path/reg_file_wr_addr.MEM
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/data_path/memory_access/data_cache/block_ram_0/mem
add wave -radix decimal sim:/tb_bubble_sort/dut/riscv_core/data_path/write_back_sel_cntrl.MEM
add wave -radix decimal sim:/tb_bubble_sort/dut/riscv_core/data_path/alu_result.MEM
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/data_path/data_mem_rd_data.MEM
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/data_path/pc.MEM
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/data_path/write_back_data.MEM



add wave -divider -height 20 write_back
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/data_path/operation_cntrl.WB
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/riscv_core/data_path/write_back_data.WB


add wave -divider -height 20 mem
add wave -radix hexadecimal sim:/tb_bubble_sort/dut/ram/mem

config wave -signalnamewidth 1
run 300000000


