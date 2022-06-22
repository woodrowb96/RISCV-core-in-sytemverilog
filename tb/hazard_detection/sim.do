
add wave sim:/tb_hazard_detection/opcode
add wave sim:/tb_hazard_detection/reg_file_wr_addr.ID
add wave sim:/tb_hazard_detection/reg_file_rd_addr_1.IF
add wave sim:/tb_hazard_detection/reg_file_rd_addr_2.IF
add wave sim:/tb_hazard_detection/insert_nop

config wave -signalnamewidth 1
run 1500


