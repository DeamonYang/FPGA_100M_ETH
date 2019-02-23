module eth(
	rst_n			,

	mii_tx_clk	,
	mii_tx_en	,
	mii_tx_er	,
	mii_tx_da	,
	
	mii_rx_clk	,
	mii_rx_dv	,
	mii_rx_er	,
	mii_rx_da	,
	
	phy_rst_n
	);
	
	
	
	input rst_n;
	
	//MII 接口信号	
	input mii_tx_clk;	//MII接口发送时钟，由PHY芯片产生，25MHz
	output mii_tx_en;	//MII接口发送数据使能信号，高电平有效
	output mii_tx_er;	//发送错误，用以破坏数据包发送
	output [3:0]mii_tx_da; //MII接口发送数据线，FPGA通过该数据线将需要发送的数据依次送给PHY芯片
	output phy_rst_n;	// PHY 复位信号

	input mii_rx_clk;	//MII接口接收时钟，由PHY芯片产生，25MHz
	input mii_rx_dv;	//MII接口接收数据有效信号，高电平有效
	input mii_rx_er;	//接收错误，本实例中暂时忽略该信号
	input [3:0]mii_rx_da;	//MII接口数据总线，FPGA通过该数据线读取PHY芯片接收到的以太网数据
	
	
	assign phy_rst_n = 1'b1;
	
	reg [10:0]data_cnt;
	wire [31:0]crc_result;  
	parameter CRC = 32'hB1E85F40; //整个数据包CRC校验值，本例中使用CRC计算软件计算得出。
	
	assign crc_result = {CRC[7:0],CRC[15:8],CRC[23:16],CRC[31:24]};
	
	wire fifo_ck;
	wire fifo_rq;
	reg[3:0] fifo_da;
	
	wire[3:0]crc_res;
	wire crc_en;
	
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
	
	
	
	eth_mac mac_lay(
		.rst_n		(rst_n			),
		.tx_go		(tx_go			),
		.data_len	(11'd105		),
		.des_mac		(48'hff_ff_ff_ff_ff_ff		),
		.src_mac		(48'h00_0a_35_01_fe_c0		),	
		.crc_res		(crc_res	),
		.crc_en		(crc_en),
		.len_type	(16'h08_06		),
		.fifo_rq		(fifo_rq		),
		.fifo_ck		(fifo_ck		),
		.fifo_da		(fifo_da		),
		.mii_tx_clk	(mii_tx_clk	),
		.mii_tx_en	(mii_tx_en	),
		.mii_tx_er	(mii_tx_er	),
		.mii_tx_da	(mii_tx_da	)
	);	
	
	always @(posedge mii_tx_clk or negedge rst_n)
	if(!rst_n)
		data_cnt <= 11'd0;
	else if(fifo_rq)
		data_cnt <= data_cnt + 1'b1;
	else
		data_cnt <= 11'd0;

		
	always @(posedge mii_tx_clk or negedge rst_n)
	if(!rst_n)
		fifo_da <= 4'd0;
	else begin
		case(data_cnt)
			//hdwr type
			00: fifo_da =	4'h0;
			01: fifo_da =	4'h0;
			02: fifo_da =	4'h1;
			03: fifo_da =	4'h0;
			
			//protocol type
			04: fifo_da =	4'h8;
			05: fifo_da =	4'h0;
			06: fifo_da =	4'h0;
			07: fifo_da =	4'h0;
			
			//hdwr size
			08: fifo_da =	4'h6;
			09: fifo_da =	4'h0;
			
			//protocol size
			10: fifo_da =	4'h4;
			11: fifo_da =	4'h0;
			
			//opcode
			12: fifo_da =	4'h0;
			13: fifo_da =	4'h0;
			14: fifo_da =	4'h1;
			15: fifo_da =	4'h0;
			
			//sender mac
			16: fifo_da =	4'h0;
			17: fifo_da =	4'h0;
			18: fifo_da =	4'ha;
			19: fifo_da =	4'h0;
			20: fifo_da =	4'h5;
			21: fifo_da =	4'h3;
			22: fifo_da =	4'h1;
			23: fifo_da =	4'h0;
			24: fifo_da =	4'he;
			25: fifo_da =	4'hf;
			26: fifo_da =	4'h0;
			27: fifo_da =	4'hc;
			
			//sender ip : 192.168.0.2
			28: fifo_da =	4'h0;//192
			29: fifo_da =	4'hc;
			
			30: fifo_da =	4'h8;//168
			31: fifo_da =	4'ha;
			
			32: fifo_da =	4'h9;//0
			33: fifo_da =	4'h8;
			
			34: fifo_da =	4'h8;
			35: fifo_da =	4'h5;//2
			
			//target mac
			36: fifo_da =	4'hf;
			37: fifo_da =	4'hf;
			38: fifo_da =	4'hf;
			39: fifo_da =	4'hf;
			40: fifo_da =	4'hf;
			41: fifo_da =	4'hf;
			42: fifo_da =	4'hf;
			43: fifo_da =	4'hf;
			44: fifo_da =	4'hf;
			45: fifo_da =	4'hf;
			46: fifo_da =	4'hf;
			47: fifo_da =	4'hf;
			
			//target ip : 192.168.0.3
			48: fifo_da =	4'h0;//192
			49: fifo_da =	4'hc;
			
			50: fifo_da =	4'h8;//168
			51: fifo_da =	4'ha;
			
			52: fifo_da =	4'h9;//0
			53: fifo_da =	4'h8;
			
			54: fifo_da =	4'h1;//3
			55: fifo_da =	4'h0;
			
			//填充字段，以使整个数据帧长度达到64字节
			56: fifo_da =	4'h0;
			57: fifo_da =	4'h0;
			58: fifo_da =	4'h0;
			59: fifo_da =	4'h0;
			60: fifo_da =	4'hf;
			61: fifo_da =	4'hf;
			62: fifo_da =	4'hf;
			63: fifo_da =	4'hf;
			64: fifo_da =	4'hf;
			65: fifo_da =	4'hf;
			66: fifo_da =	4'hf;
			67: fifo_da =	4'hf;
			68: fifo_da =	4'hf;
			69: fifo_da =	4'hf;
			70: fifo_da =	4'hf;
			71: fifo_da =	4'hf;
			72: fifo_da =	4'h0;
			73: fifo_da =	4'h0;
			74: fifo_da =	4'h3;
			75: fifo_da =	4'h2;
			76: fifo_da =	4'hd;
			77: fifo_da =	4'hc;
			78: fifo_da =	4'h6;
			79: fifo_da =	4'h7;
			80: fifo_da =	4'h3;
			81: fifo_da =	4'h6;
			82: fifo_da =	4'ha;
			83: fifo_da =	4'h1;
			84: fifo_da =	4'h8;
			85: fifo_da =	4'h0;
			86: fifo_da =	4'h6;
			87: fifo_da =	4'h0;
			88: fifo_da =	4'h0;
			89: fifo_da =	4'h0;
			90: fifo_da =	4'h1;
			91: fifo_da =	4'h0;
			default:fifo_da = 4'hd;
		endcase
	end
	
		//发送间隔计数器
	reg [23:0]cnt;
	
	always@(posedge mii_tx_clk or negedge rst_n)
	if(!rst_n)
		cnt <=  0;
		else //计数器自增，不考虑溢出，接受溢出自动清零
		cnt <=  cnt + 1'b1;
		
	//每671ms启动一次发送数据	
	assign tx_go = (cnt == 24'd1);
	

endmodule



	