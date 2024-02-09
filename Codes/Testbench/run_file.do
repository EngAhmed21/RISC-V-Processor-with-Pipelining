vlog *.v

vsim -voptargs=+acc work.RISC_tb

add wave -position insertpoint sim:/RISC_tb/uut/*
add wave -position insertpoint  \
sim:/RISC_tb/uut/SQ/SQ_MEM/QUEUE
add wave -position insertpoint  \
sim:/RISC_tb/uut/ROB_STAGE/RO_Buffer/ROB_MEM

run -all