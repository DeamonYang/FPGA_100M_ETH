module udp_protocol(
		rst_n		,
		tx_go			,
		data_len		,
		
		fifo_rq		,
		fifo_ck		,
		fifo_da		,
		
		
		mii_tx_clk	,
		mii_tx_en	,
		mii_tx_er	,
		mii_tx_da			
		
	);
	
	input rst_n			;
	input	tx_go			;
	input[11:0]	data_len	;

	output  fifo_rq		;
	output fifo_ck		;
	input[4:0] fifo_da;	
	
	input mii_tx_clk	;
	output mii_tx_en	;
	output mii_tx_er	;
	output [3:0]mii_tx_da;	

	


endmodule

