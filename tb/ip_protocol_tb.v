`timescale 1ns/1ns

module ip_protocol_tb;

	reg 	rst_n			;
	reg	tx_go			;
	reg[11:0]data_len	;
	reg[4:0] fifo_da;	
	reg mii_tx_clk	;
	
	
	wire fifo_rq		;
	wire fifo_ck		;
	wire mii_tx_en	;
	wire mii_tx_er	;
	wire [3:0]mii_tx_da	;	
	
	ip_protocol ip_pro_u4(
		.rst_n			(rst_n			),
		.tx_go			(tx_go			),
		.data_len		(data_len		),
		.fifo_rq		(fifo_rq		),
		.fifo_ck		(fifo_ck		),
		.fifo_da		(fifo_da		),	
		.mii_tx_clk	(mii_tx_clk	),
		.mii_tx_en	(mii_tx_en	),
		.mii_tx_er	(mii_tx_er	),
		.mii_tx_da	(mii_tx_da	)		
	);
	
	
	always #40 mii_tx_clk =~mii_tx_clk;
	
	initial begin
		rst_n = 0			;
		tx_go	 = 0		;
		data_len	 = 28 ;
		mii_tx_clk	 = 0;
		#2000;
		tx_go = 1;
		rst_n = 1;
		fifo_da = 4'hd;
		#50;
		tx_go = 0;
		#20000;
		$stop;
	end
	
	
	always@(posedge mii_tx_clk or negedge rst_n)
	if(!rst_n)
		fifo_da <= 4'd0;
	else if(fifo_rq)
		fifo_da <= fifo_da + 1'b1;


endmodule
