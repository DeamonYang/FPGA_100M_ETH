module udp_protocol(
		rst_n		,
		tx_go			,
		data_len		,
		
		fifo_rq		,
		fifo_ck		,
		fifo_da		,
		
		sour_port	,
		dest_port	,
		udp_ck_sum	,
		
		mii_tx_clk	,
		mii_tx_en	,
		mii_tx_er	,
		mii_tx_da			
		
	);
	
	input rst_n			;
	input	tx_go			;
	

	output  fifo_rq		;
	output fifo_ck		;
	input[3:0] fifo_da;	
	
	input[15:0]	data_len	;
	input[15:0]	sour_port	;
	input[15:0]	dest_port	;
	input[15:0] udp_ck_sum	;
	
	input mii_tx_clk	;
	output mii_tx_en	;
	output mii_tx_er	;
	output [3:0]mii_tx_da;	

	reg[11:0]data_cnt;
	reg [6:0]cnt;

	reg[3:0] ip_data;
	wire ip_rq;

	wire [15:0]ip_totlen_byte;
	wire[15:0]	tot_data_len_byte = 	data_len + 4'd8;

	assign fifo_rq = (cnt >= 7'd15) && (data_cnt > 0);
	assign ip_totlen_byte = data_len + 8;
	
	
	
	
	assign fifo_ck = mii_tx_clk;
	
	
	ip_protocol ip_protocol_u3(
		.rst_n			(rst_n		),
		.tx_go			(tx_go		),
		.data_len		(tot_data_len_byte 	),
	
		.fifo_rq		(ip_rq),
		.fifo_ck		( ),
		.fifo_da		(ip_data),

		.mii_tx_clk	(mii_tx_clk	),
		.mii_tx_en	(mii_tx_en	),
		.mii_tx_er	(mii_tx_er	),
		.mii_tx_da	(mii_tx_da	)		
		
	);
	
	
	
	
	
	always@(posedge mii_tx_clk or negedge rst_n)
	if(!rst_n)
		data_cnt <= 12'd0;
	else if(cnt == 7'd1)
		data_cnt <= (data_len << 1);
	else if(cnt >= 7'd15 & data_cnt > 0)
		data_cnt <= data_cnt - 1'b1;
		
	
	
	always @(posedge mii_tx_clk or negedge rst_n)
	if(!rst_n)
		cnt <= 7'd0;
	else if(ip_rq)begin
		if(cnt > 7'd15 && data_cnt > 12'd0)
			cnt <= cnt;
		else
			cnt <= cnt + 1'b1;
	end else
		cnt <= 7'd0;
	

	
	always @(posedge mii_tx_clk or negedge rst_n )
	if(!rst_n)
		ip_data <= 4'd0;
	else begin
		case (cnt)
			00	:	ip_data <= sour_port[11:8];  
			01	:	ip_data <= sour_port[15:12];
			02	:	ip_data <= sour_port[3:0]; 
			03	:	ip_data <= sour_port[7:4];

			04	:	ip_data <= dest_port[11:8];//totlen 
			05	:	ip_data <= dest_port[15:12];
			06	:	ip_data <= dest_port[3:0]; 
			07	:	ip_data <= dest_port[7:4];
			
			08	:	ip_data <= tot_data_len_byte[11:8];  
			09	:	ip_data <= tot_data_len_byte[15:12];
			10	:	ip_data <= tot_data_len_byte[3:0]; 
			11	:	ip_data <= tot_data_len_byte[7:4];
			
			12	:	ip_data <= udp_ck_sum[11:8];  
			13	:	ip_data <= udp_ck_sum[15:12];
			14	:	ip_data <= udp_ck_sum[3:0]; 
			15	:	ip_data <= udp_ck_sum[7:4];

			16	:	ip_data <= fifo_da;
			
			
			default:ip_data <= 4'd0;
		endcase
	end
	
	



endmodule

