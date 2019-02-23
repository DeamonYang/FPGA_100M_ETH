transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+L:/FPWG_WORK/FPGA_100ETH/rtl {L:/FPWG_WORK/FPGA_100ETH/rtl/eth_mac.v}
vlog -vlog01compat -work work +incdir+L:/FPWG_WORK/FPGA_100ETH/rtl {L:/FPWG_WORK/FPGA_100ETH/rtl/eth.v}

vlog -vlog01compat -work work +incdir+L:/FPWG_WORK/FPGA_100ETH/proj/../tb {L:/FPWG_WORK/FPGA_100ETH/proj/../tb/eth_tb.v}
vlog -vlog01compat -work work +incdir+L:/FPWG_WORK/FPGA_100ETH/proj/../rtl {L:/FPWG_WORK/FPGA_100ETH/proj/../rtl/eth_mac.v}
vlog -vlog01compat -work work +incdir+L:/FPWG_WORK/FPGA_100ETH/proj/../rtl {L:/FPWG_WORK/FPGA_100ETH/proj/../rtl/eth.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  eth_tb

add wave *
view structure
view signals
run -all
