`timescale 1ns/1ns
module eth_mac_tb;

	reg 	rst_n			;
	reg 	tx_go			;
	reg 	[10:0]data_len		;
	reg 	[47:0]des_mac		;
	reg 	[47:0]src_mac		;	
	reg 	[31:0]crc_res		;
	reg 	[15:0]len_type		;
	reg 	[3:0]fifo_da		;	
	reg 	mii_tx_clk	;
	
	wire 	fifo_rq		;
	wire 	fifo_ck		;

	wire 	mii_tx_en	;
	wire 	mii_tx_er	;
	wire [3:0]mii_tx_da	;




	eth_mac mac(
		.rst_n			(rst_n			),
		.tx_go			(tx_go			),
		.data_len		(data_len		),
		.des_mac		(des_mac		),
		.src_mac		(src_mac		),	
		.crc_res		(crc_res		),
		.len_type		(len_type		),
		.fifo_rq		(fifo_rq		),
		.fifo_ck		(fifo_ck		),
		.fifo_da		(fifo_da		),
		.mii_tx_clk	(mii_tx_clk	),
		.mii_tx_en	(mii_tx_en	),
		.mii_tx_er	(mii_tx_er	),
		.mii_tx_da	(mii_tx_da	)
	);
	
	initial begin
		mii_tx_clk = 0;
		rst_n = 0;
		tx_go = 0;
		data_len = 100;
		des_mac = 48'h84_7b_eb_48_94_13;
		src_mac = 48'h00_0a_35_01_fe_c0;
		len_type = 16'h08_00;
		crc_res = 32'h12_34_56_78;
		#201;
		rst_n = 1;
		#200;
		tx_go = 1;	//启动一次发送
		#40;
		tx_go = 0;
		#40000;
		
		data_len = 10;
		des_mac = 48'h84_7b_eb_48_94_13;
		src_mac = 48'h00_0a_35_01_fe_c0;
		len_type = 16'h08_00;
		crc_res = 32'h12_34_56_78;
		#200;
		tx_go = 1;	//启动一次发送
		#40;
		tx_go = 0;
		#40000;
		
		$stop;
	end
	

	always #20 mii_tx_clk = ~mii_tx_clk;
	
	
	always@(posedge mii_tx_clk or negedge rst_n)
	if(!rst_n)
		fifo_da <= 4'd0;
	else if(fifo_rq)
		fifo_da <= fifo_da + 1'b1; 


endmodule
