transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {eth_8_1200mv_85c_slow.vo}

vlog -vlog01compat -work work +incdir+L:/FPWG_WORK/FPGA_100ETH/proj/../tb {L:/FPWG_WORK/FPGA_100ETH/proj/../tb/check_sum_tb.v}
vlog -vlog01compat -work work +incdir+L:/FPWG_WORK/FPGA_100ETH/proj/../rtl {L:/FPWG_WORK/FPGA_100ETH/proj/../rtl/check_sum.v}

vsim -t 1ps +transport_int_delays +transport_path_delays -L altera_ver -L cycloneive_ver -L gate_work -L work -voptargs="+acc"  check_sum_tb

add wave *
view structure
view signals
run -all
