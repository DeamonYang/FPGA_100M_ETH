library verilog;
use verilog.vl_types.all;
entity udp_protocol is
    port(
        rst_n           : in     vl_logic;
        tx_go           : in     vl_logic;
        data_len        : in     vl_logic_vector(15 downto 0);
        fifo_rq         : out    vl_logic;
        fifo_ck         : out    vl_logic;
        fifo_da         : in     vl_logic_vector(3 downto 0);
        sour_port       : in     vl_logic_vector(15 downto 0);
        dest_port       : in     vl_logic_vector(15 downto 0);
        udp_ck_sum      : in     vl_logic_vector(15 downto 0);
        mii_tx_clk      : in     vl_logic;
        mii_tx_en       : out    vl_logic;
        mii_tx_er       : out    vl_logic;
        mii_tx_da       : out    vl_logic_vector(3 downto 0)
    );
end udp_protocol;
