library verilog;
use verilog.vl_types.all;
entity eth is
    generic(
        CRC             : vl_logic_vector(31 downto 0) := (Hi1, Hi0, Hi1, Hi1, Hi0, Hi0, Hi0, Hi1, Hi1, Hi1, Hi1, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi1, Hi1, Hi1, Hi1, Hi1, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0)
    );
    port(
        rst_n           : in     vl_logic;
        mii_tx_clk      : in     vl_logic;
        mii_tx_en       : out    vl_logic;
        mii_tx_er       : out    vl_logic;
        mii_tx_da       : out    vl_logic_vector(3 downto 0);
        mii_rx_clk      : in     vl_logic;
        mii_rx_dv       : in     vl_logic;
        mii_rx_er       : in     vl_logic;
        mii_rx_da       : in     vl_logic_vector(3 downto 0);
        phy_rst_n       : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of CRC : constant is 1;
end eth;
