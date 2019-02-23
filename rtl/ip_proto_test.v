module ip_proto_test(
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
	
	ip_protocol ui(
		.rst_n		(rst_n),
		.tx_go		(tx_go)	,
		.data_len	 (12'd29)	,
		
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
			// source port
			00: fifo_da =	4'h5;
			01: fifo_da =	4'h0;
			02: fifo_da =	4'h1;
			03: fifo_da =	4'h2;
			
			//dest port
			04: fifo_da =	4'h7;
			05: fifo_da =	4'h2;
			06: fifo_da =	4'h5;
			07: fifo_da =	4'h1;
			
			// len
			08: fifo_da =	4'h0;
			09: fifo_da =	4'h0;
			10: fifo_da =	4'hc;
			11: fifo_da =	4'h1;
			
			//check sum
			12: fifo_da =	4'h8;
			13: fifo_da =	4'h8;
			14: fifo_da =	4'hb;
			15: fifo_da =	4'h6;
			
			// data
			16: fifo_da =	4'h8;
			17: fifo_da =	4'h6;
			18: fifo_da =	4'h5;
			19: fifo_da =	4'h6;
			20: fifo_da =	4'hc;
			21: fifo_da =	4'h6;
			22: fifo_da =	4'hc;
			23: fifo_da =	4'h6;
			24: fifo_da =	4'hf;
			25: fifo_da =	4'h6;
			26: fifo_da =	4'hc;
			27: fifo_da =	4'h2;
			28: fifo_da =	4'h9;
			29: fifo_da =	4'h4;
			30: fifo_da =	4'hd;
			31: fifo_da =	4'h6;		
			32: fifo_da =	4'h0;//0
			33: fifo_da =	4'h2;
			34: fifo_da =	4'h4;
			35: fifo_da =	4'h4;//2
			36: fifo_da =	4'h5;
			37: fifo_da =	4'h6;
			38: fifo_da =	4'h1;
			39: fifo_da =	4'h6;
			40: fifo_da =	4'hd;
			41: fifo_da =	4'h6;
			42: fifo_da =	4'hf;
			43: fifo_da =	4'h6;
			44: fifo_da =	4'he;
			45: fifo_da =	4'h6;
			46: fifo_da =	4'h9;
			47: fifo_da =	4'h5;
			48: fifo_da =	4'h1;//192
			49: fifo_da =	4'h6;			
			50: fifo_da =	4'he;//168
			51: fifo_da =	4'h6;
			52: fifo_da =	4'h7;//0
			53: fifo_da =	4'h6;		
			54: fifo_da =	4'h1;//3
			55: fifo_da =	4'h2;
//			56: fifo_da =	;
//			57: fifo_da =	;
//			58: fifo_da =	;
//			59: fifo_da =	;
//			60: fifo_da =	;
//			61: fifo_da =	;
//			62: fifo_da =	;
//			63: fifo_da =	;
//			64: fifo_da =	;
//			65: fifo_da =	;
//			66: fifo_da =	;
//			67: fifo_da =	;
//			68: fifo_da =	;
//			69: fifo_da =	;
//			70: fifo_da =	;
//			71: fifo_da =	;
//			72: fifo_da =	;
//			73: fifo_da =	;
//			74: fifo_da =	;
//			75: fifo_da =	;
//			76: fifo_da =	;
//			77: fifo_da =	;
//			78: fifo_da =	;
//			79: fifo_da =	;
//			80: fifo_da =	;
//			81: fifo_da =	;
//			82: fifo_da =	;
//			83: fifo_da =	;
//			84: fifo_da =	;
//			85: fifo_da =	;
//			86: fifo_da =	;
//			87: fifo_da =	;
//			88: fifo_da =	;
//			89: fifo_da =	;
//			90: fifo_da =	;
//			91: fifo_da =	;
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
	
	
	















































































