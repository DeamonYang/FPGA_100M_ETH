library verilog;
use verilog.vl_types.all;
entity eth_mac is
    port(
        rst_n           : in     vl_logic;
        tx_go           : in     vl_logic;
        data_len        : in     vl_logic_vector(10 downto 0);
        des_mac         : in     vl_logic_vector(47 downto 0);
        src_mac         : in     vl_logic_vector(47 downto 0);
        crc_res         : in     vl_logic_vector(31 downto 0);
        len_type        : in     vl_logic_vector(15 downto 0);
        fifo_rq         : out    vl_logic;
        fifo_ck         : out    vl_logic;
        fifo_da         : in     vl_logic_vector(3 downto 0);
        mii_tx_clk      : in     vl_logic;
        mii_tx_en       : out    vl_logic;
        mii_tx_er       : out    vl_logic;
        mii_tx_da       : out    vl_logic_vector(3 downto 0)
    );
end eth_mac;
