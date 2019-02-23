transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+L:/FPWG_WORK/FPGA_100ETH/rtl {L:/FPWG_WORK/FPGA_100ETH/rtl/ip_proto_test.v}
vlog -vlog01compat -work work +incdir+L:/FPWG_WORK/FPGA_100ETH/rtl {L:/FPWG_WORK/FPGA_100ETH/rtl/ip_protocol.v}
vlog -vlog01compat -work work +incdir+L:/FPWG_WORK/FPGA_100ETH/rtl {L:/FPWG_WORK/FPGA_100ETH/rtl/crc32_d4.v}
vlog -vlog01compat -work work +incdir+L:/FPWG_WORK/FPGA_100ETH/rtl {L:/FPWG_WORK/FPGA_100ETH/rtl/eth_mac.v}
vlog -vlog01compat -work work +incdir+L:/FPWG_WORK/FPGA_100ETH/rtl {L:/FPWG_WORK/FPGA_100ETH/rtl/check_sum.v}

vlog -vlog01compat -work work +incdir+L:/FPWG_WORK/FPGA_100ETH/proj/../tb {L:/FPWG_WORK/FPGA_100ETH/proj/../tb/ip_proto_test_tb.v}
vlog -vlog01compat -work work +incdir+L:/FPWG_WORK/FPGA_100ETH/proj/../rtl {L:/FPWG_WORK/FPGA_100ETH/proj/../rtl/eth_mac.v}
vlog -vlog01compat -work work +incdir+L:/FPWG_WORK/FPGA_100ETH/proj/../rtl {L:/FPWG_WORK/FPGA_100ETH/proj/../rtl/crc32_d4.v}
vlog -vlog01compat -work work +incdir+L:/FPWG_WORK/FPGA_100ETH/proj/../rtl {L:/FPWG_WORK/FPGA_100ETH/proj/../rtl/eth.v}
vlog -vlog01compat -work work +incdir+L:/FPWG_WORK/FPGA_100ETH/proj/../rtl {L:/FPWG_WORK/FPGA_100ETH/proj/../rtl/check_sum.v}
vlog -vlog01compat -work work +incdir+L:/FPWG_WORK/FPGA_100ETH/proj/../rtl {L:/FPWG_WORK/FPGA_100ETH/proj/../rtl/ip_protocol.v}
vlog -vlog01compat -work work +incdir+L:/FPWG_WORK/FPGA_100ETH/proj/../rtl {L:/FPWG_WORK/FPGA_100ETH/proj/../rtl/ip_proto_test.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  ip_proto_test_tb

add wave *
view structure
view signals
run -all
