add wave sim:/tb_branch_prediction_unit/clk
add wave sim:/tb_branch_prediction_unit/reset_n
add wave sim:/tb_branch_prediction_unit/stall

add wave -divider -height 20 instruction_fetch
add wave -radix unsigned sim:/tb_branch_prediction_unit/pc
add wave -radix unsigned sim:/tb_branch_prediction_unit/dut/opcode.IF
add wave -radix unsigned sim:/tb_branch_prediction_unit/dut/rd_addr_IF
add wave -radix unsigned sim:/tb_branch_prediction_unit/dut/state_IF
add wave -radix unsigned sim:/tb_branch_prediction_unit/dut/branch_prediction
add wave -radix unsigned sim:/tb_branch_prediction_unit/branch_target_IF
add wave -divider -height 20 instruction_decode
add wave -radix unsigned sim:/tb_branch_prediction_unit/dut/opcode.ID
add wave -radix unsigned sim:/tb_branch_prediction_unit/dut/rd_addr_ID
add wave -radix unsigned sim:/tb_branch_prediction_unit/dut/state_ID
add wave -radix unsigned sim:/tb_branch_prediction_unit/branch_decision
add wave -divider -height 20 target_redo
add wave -radix unsigned sim:/tb_branch_prediction_unit/dut/state_ID
add wave -radix unsigned sim:/tb_branch_prediction_unit/branch_decision
add wave -radix unsigned sim:/tb_branch_prediction_unit/dut/wrong_take_prediction
add wave -radix unsigned sim:/tb_branch_prediction_unit/dut/wrong_not_take_prediction
add wave -radix unsigned sim:/tb_branch_prediction_unit/dut/wrong_target_branch
add wave -radix unsigned sim:/tb_branch_prediction_unit/dut/wrong_target_jump
add wave -radix unsigned sim:/tb_branch_prediction_unit/branch_target_ID
add wave -radix unsigned sim:/tb_branch_prediction_unit/branch_target_IF
add wave -radix unsigned sim:/tb_branch_prediction_unit/branch_redo


add wave -divider -height 20 buffer
add wave -radix unsigned sim:/tb_branch_prediction_unit/dut/wr_addr_ID
add wave -radix unsigned sim:/tb_branch_prediction_unit/dut/branch_pred_buffer
add wave -radix unsigned sim:/tb_branch_prediction_unit/dut/branch_target_buffer
add wave -radix unsigned sim:/tb_branch_prediction_unit/dut/jump_target_buffer


config wave -signalnamewidth 1

run 3000


