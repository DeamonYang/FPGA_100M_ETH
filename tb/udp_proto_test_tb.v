`timescale 1ns/1ns
module udp_proto_test_tb;


	reg rst_n;
	
	//MII 接口信号	
	reg mii_tx_clk;	//MII接口发送时钟，由PHY芯片产生，25MHz
	wire mii_tx_en;	//MII接口发送数据使能信号，高电平有效
	wire mii_tx_er;	//发送错误，用以破坏数据包发送
	wire [3:0]mii_tx_da; //MII接口发送数据线，FPGA通过该数据线将需要发送的数据依次送给PHY芯片
	wire phy_rst_n;	// PHY 复位信号

	reg mii_rx_clk;	//MII接口接收时钟，由PHY芯片产生，25MHz
	reg mii_rx_dv;	//MII接口接收数据有效信号，高电平有效
	reg mii_rx_er;	//接收错误，本实例中暂时忽略该信号
	reg [3:0]mii_rx_da;	//MII接口数据总线，FPGA通过该数据线读取PHY芯片接收到的以太网数据



	udp_proto_test udp_proto_test_ue8(
		.rst_n			(rst_n			),
		.mii_tx_clk	(mii_tx_clk	),
		.mii_tx_en	(mii_tx_en	),
		.mii_tx_er	(mii_tx_er	),
		.mii_tx_da	(mii_tx_da	),
		.mii_rx_clk	(mii_rx_clk	),
		.mii_rx_dv	(mii_rx_dv	),
		.mii_rx_er	(mii_rx_er	),
		.mii_rx_da	(mii_rx_da	),
		.phy_rst_n(phy_rst_n)
	);
	
	always #40  mii_tx_clk = ~mii_tx_clk;
	initial begin
		rst_n = 0;
		mii_tx_clk = 0;
		#2000;
		rst_n = 1;
		#40000;
		$stop;
	
	
	end

endmodule
