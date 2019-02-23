module ip_protocol(
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
	output [3:0]mii_tx_da	;	
	
	
	reg[11:0]data_cnt;
	
	wire crc_en;
	reg [6:0]cnt;
	wire[31:0]crc_res;
	reg[3:0] mac_data;
	wire mac_rq;
	wire [15:0]ip_totlen;
	wire [15:0]res_check_sum;
	wire [31:0]src_ip;
	wire [31:0]dst_ip;
	wire [15:0]ip_totlen_byte;
	
	assign ip_totlen = (data_len<<1) + 40;
	assign src_ip = 32'hc0_a8_89_58;
	assign dst_ip = 32'hc0_a8_89_01;
	assign fifo_rq = (cnt >= 7'd39) && (data_cnt > 0);
	assign ip_totlen_byte = data_len + 20;
	
	
	
	
	assign fifo_ck = mii_tx_clk;
	
	
	crc32_d4 crc_u1(
			.Clk		(rst_n), 
			.Rst_n		(mii_tx_clk), 
			.Data		(mii_tx_da), 
			.Enable	(crc_en), 
			.Initialize(~mii_tx_en), 
			.Crc()		, 
			.CrcError	(), 
			.Crc_eth	(crc_res)
		);
	
	eth_mac eth_mac_u0(
			.rst_n		(rst_n			),
			.tx_go		(tx_go			),
			.data_len	(ip_totlen		),
			
			.des_mac		(48'h98_ee_cb_91_f7_cb), //win10 电脑MAC地址
			.src_mac		(48'h00_0a_35_01_fe_c0),	
			
			.crc_res		(crc_res		),
			.crc_en		(crc_en		),
			
			.len_type	(16'h80_00	), //UDP 数据包
			
			.fifo_rq		(mac_rq		),
			.fifo_ck		(		),
			.fifo_da		(mac_data	),
			
			
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
	else if(cnt >= 7'd39 & data_cnt > 0)
		data_cnt <= data_cnt - 1'b1;
		
	
	
	always @(posedge mii_tx_clk or negedge rst_n)
	if(!rst_n)
		cnt <= 7'd0;
	else if(mac_rq)begin
		if(cnt > 7'd39 && data_len > 12'd1)
			cnt <= cnt;
		else
			cnt <= cnt + 1'b1;
	end else
		cnt <= 7'd0;
	

	
	always @(posedge mii_tx_clk or negedge rst_n )
	if(!rst_n)
		mac_data <= 4'd0;
	else begin
		case (cnt)
			00	:	mac_data <= 4'h5;
			01	:	mac_data <= 4'h4;
			
			02	:	mac_data <= 4'h0; //tos
			03	:	mac_data <= 4'h0;
			
			04	:	mac_data <= ip_totlen_byte[11:8];//totlen 
			05	:	mac_data <= ip_totlen_byte[15:12];
			06	:	mac_data <= ip_totlen_byte[3:0]; 
			07	:	mac_data <= ip_totlen_byte[7:4];
			
			08	:	mac_data <= 4'h1; //id
			09	:	mac_data <= 4'h2;
			10	:	mac_data <= 4'h3;
			11	:	mac_data <= 4'hb;
			
			12	:	mac_data <= 4'h0;
			13	:	mac_data <= 4'h0;
			14	:	mac_data <= 4'h0;
			15	:	mac_data <= 4'h0;
			
			
			16	:	mac_data <= 4'h0; //ttl
			17	:	mac_data <= 4'h4;
			
			18	:	mac_data <= 4'h1; //UDP protocol
			19	:	mac_data <= 4'h1;

			20	:	mac_data <= res_check_sum[11:8];
			21	:	mac_data <= res_check_sum[15:12];
			22	:	mac_data <= res_check_sum[3:0];
			23	:	mac_data <= res_check_sum[7:4];
			
			24	:	mac_data <= src_ip[27:24];
			25	:	mac_data <= src_ip[31:28];
			26	:	mac_data <= src_ip[19:16];
			27	:	mac_data <= src_ip[23:20];
			28	:	mac_data <= src_ip[11:8];
			29	:	mac_data <= src_ip[15:12];
			30	:	mac_data <= src_ip[3:0];
			31	:	mac_data <= src_ip[7:4];
	
			32	:	mac_data <= dst_ip[27:24];
			33	:	mac_data <= dst_ip[31:28];
			34	:	mac_data <= dst_ip[19:16];
			35	:	mac_data <= dst_ip[23:20];
			36	:	mac_data <= dst_ip[11:8];
			37	:	mac_data <= dst_ip[15:12];
			38	:	mac_data <= dst_ip[3:0];
			39	:	mac_data <= dst_ip[7:4];
			
			40	: 	mac_data <= fifo_da;
			
			default:mac_data <= 4'd0;
		endcase
	end
	
	
	check_sum cksum_u7(
		.ver		(4	),
		.hdr_len	(5	),
		.tos		(0	),
		.tot_len	(ip_totlen_byte),
		.id			(16'd8627	),
		.offset	(0	),
		.ttl		(64	),
		.protocol	(17	),
		.src_ip	(src_ip	),
		.dst_ip	(dst_ip	),
		.res_check_sum(res_check_sum)
	);
	
	
	
	
	
endmodule
