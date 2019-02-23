module eth_mac(
	rst_n			,
	tx_go			,
	data_len		,
	des_mac		,
	src_mac		,	
	crc_res		,
	crc_en		,
	len_type		,
	
	fifo_rq		,
	fifo_ck		,
	fifo_da		,
	
	/*mii 接口*/
	mii_tx_clk	,
	mii_tx_en	,
	mii_tx_er	,
	mii_tx_da	
	);

	input 	rst_n			;
	input 	tx_go			;
	input 	[11:0]data_len		;
	input 	[47:0]des_mac		;
	input 	[47:0]src_mac		;	
	input 	[31:0]crc_res		;
	output	crc_en		;
	input 	[15:0]len_type		;
	
	
	output 	fifo_rq		;
	output 	fifo_ck		;
	input 	[3:0]fifo_da		;
	
	input 	mii_tx_clk	;
	output reg	mii_tx_en	;
	output 	mii_tx_er	;
	output reg	[3:0]mii_tx_da	;
	
	reg	[5:0] sta_cnt;//线性序列机计数器
	reg 	r_tx_en;
	reg 	[11:0]r_data_len		;
	reg 	[47:0]r_des_mac		;
	reg 	[47:0]r_src_mac		;	
	reg 	[31:0]r_crc_res		;
	reg 	[15:0]r_len_type		;
	reg	send_data_en;
	reg 	[11:0]r_data_num		;
	
	
	assign fifo_ck = mii_tx_clk;
	assign fifo_rq = (sta_cnt >= 6'd44)&&(r_data_num >  12'd1);//send_data_en;
/* the Destination Address, Source Address, Length/ Type field, MAC Client Data, 
		and Pad (that is, all fields except FCS)*/
	assign crc_en = (sta_cnt > 6'd17 ) && (sta_cnt <= 6'd45);  // 输出时钟延时一个时钟 故不包括 17
	
	
	/*内部发送使能*/
	always@(posedge mii_tx_clk or negedge rst_n)
	if(!rst_n)
		r_tx_en <= 1'b0;
	else if(tx_go)
		r_tx_en <= 1'b1;
	else if(sta_cnt > 6'd53 )
		r_tx_en <= 1'b0;
	
	/*起始发送数据时寄存所有数据*/
	always@(posedge mii_tx_clk or negedge rst_n)
	if(!rst_n) begin
		r_data_len	<= 12'd0;
		r_des_mac	<= 48'd0;
		r_src_mac	<= 48'd0;
		r_len_type	<= 16'd0;
	end else if(tx_go)begin
		r_data_len	<= data_len	;
		r_des_mac	<= des_mac	;
		r_src_mac	<= src_mac	;
		r_len_type	<= len_type	;
	end

	always@(posedge mii_tx_clk or negedge rst_n)
	if(!rst_n)
		r_crc_res	<= 32'd0;
	else if(crc_en)
		r_crc_res	<= crc_res	;

	always@(posedge mii_tx_clk or negedge rst_n)
	if(!rst_n)
		r_data_num <= 12'd0;
	else if(tx_go)
		r_data_num <= data_len;
	else if(sta_cnt == 6'd45 && r_data_num > 0)
		r_data_num <= r_data_num - 1'b1;
	

	always@(posedge mii_tx_clk or negedge rst_n)
	if(!rst_n)
		send_data_en <= 1'd0;
	else if((sta_cnt >= 6'd44 && r_data_num > 2) )
		send_data_en <= 1'b1;
	else 
		send_data_en <= 1'd0;

	
	/*序列机计数器*/
	always@(posedge mii_tx_clk or negedge rst_n)
	if(!rst_n)
		sta_cnt <= 6'd0;
	else if(r_tx_en) begin
		if(send_data_en)		//发送有效载荷
			sta_cnt <= sta_cnt;
		else
			sta_cnt <= sta_cnt + 1'b1;
	end else
		sta_cnt <= 6'd0;

	always@(posedge mii_tx_clk or negedge rst_n)
	if(!rst_n)
		mii_tx_da <= 4'd0;
	else case(sta_cnt)
		1,2,3,4,5,6,7,8,9,10,11,12,13,14:
				mii_tx_da <= 4'h5;
		/*帧起始*/
		15:	mii_tx_da <= 4'h5;
		16:	mii_tx_da <= 4'hd;
		/*目的地址*/
		17:	mii_tx_da <= r_des_mac[43:40];
		18:	mii_tx_da <= r_des_mac[47:44];
		19:	mii_tx_da <= r_des_mac[35:32];
		20:	mii_tx_da <= r_des_mac[39:36];
		21:	mii_tx_da <= r_des_mac[27:24];
		22:	mii_tx_da <= r_des_mac[31:28];
		23:	mii_tx_da <= r_des_mac[19:16];
		24:	mii_tx_da <= r_des_mac[23:20];
		25:	mii_tx_da <= r_des_mac[11:8];
		26:	mii_tx_da <= r_des_mac[15:12];
		27:	mii_tx_da <= r_des_mac[3:0];
		28:	mii_tx_da <= r_des_mac[7:4];
	
		/*源地址*/
		29:	mii_tx_da <= r_src_mac[43:40];
		30:	mii_tx_da <= r_src_mac[47:44];
		31:	mii_tx_da <= r_src_mac[35:32];
		32:	mii_tx_da <= r_src_mac[39:36];
		33:	mii_tx_da <= r_src_mac[27:24];
		34:	mii_tx_da <= r_src_mac[31:28];
		35:	mii_tx_da <= r_src_mac[19:16];
		36:	mii_tx_da <= r_src_mac[23:20];
		37:	mii_tx_da <= r_src_mac[11:8];
		38:	mii_tx_da <= r_src_mac[15:12];
		39:	mii_tx_da <= r_src_mac[3:0];
		40:	mii_tx_da <= r_src_mac[7:4];













	
//		/*源地址*/
//		29:	mii_tx_da <= r_src_mac[47:44];
//		30:	mii_tx_da <= r_src_mac[43:40];
//		31:	mii_tx_da <= r_src_mac[39:36];
//		32:	mii_tx_da <= r_src_mac[35:32];
//		33:	mii_tx_da <= r_src_mac[31:28];
//		34:	mii_tx_da <= r_src_mac[27:24];
//		35:	mii_tx_da <= r_src_mac[23:20];
//		36:	mii_tx_da <= r_src_mac[19:16];
//		37:	mii_tx_da <= r_src_mac[15:12];
//		38:	mii_tx_da <= r_src_mac[11:8];
//		39:	mii_tx_da <= r_src_mac[7:4];
//		40:	mii_tx_da <= r_src_mac[3:0];	
		
		
//		/*源地址*/
//		29:	mii_tx_da <= r_src_mac[3:0];
//		30:	mii_tx_da <= r_src_mac[7:4];
//		31:	mii_tx_da <= r_src_mac[11:8];
//		32:	mii_tx_da <= r_src_mac[15:12];
//		33:	mii_tx_da <= r_src_mac[19:16];
//		34:	mii_tx_da <= r_src_mac[23:20];
//		35:	mii_tx_da <= r_src_mac[27:24];
//		36:	mii_tx_da <= r_src_mac[31:28];
//		37:	mii_tx_da <= r_src_mac[35:32];
//		38:	mii_tx_da <= r_src_mac[39:36];
//		39:	mii_tx_da <= r_src_mac[43:40];
//		40:	mii_tx_da <= r_src_mac[47:44];		
		
		/*数据长度 类型*/
		41:	mii_tx_da <= r_len_type[15:12];
		42:	mii_tx_da <= r_len_type[11:8];	
		43:	mii_tx_da <= r_len_type[7:4];
		44:	mii_tx_da <= r_len_type[3:0];

		/*数据*/
		45:	mii_tx_da <= fifo_da ;	

		/*CRC校验*/

		46:	mii_tx_da <= r_crc_res[31:28];
		47:	mii_tx_da <= r_crc_res[27:24];
		48:	mii_tx_da <= r_crc_res[23:20];
		49:	mii_tx_da <= r_crc_res[19:16];
		50:	mii_tx_da <= r_crc_res[15:12];
		51:	mii_tx_da <= r_crc_res[11:8];
		52:	mii_tx_da <= r_crc_res[7:4];	
		53:	mii_tx_da <= r_crc_res[3:0];	
		default: mii_tx_da <= 4'h0;
	endcase
	
	always@(posedge mii_tx_clk or negedge rst_n)
	if(!rst_n)
		mii_tx_en <= 1'b0;
	else if(sta_cnt > 0 && sta_cnt < 54)
		mii_tx_en <= 1'b1;
	else
		mii_tx_en <= 1'b0;
	
	

endmodule
