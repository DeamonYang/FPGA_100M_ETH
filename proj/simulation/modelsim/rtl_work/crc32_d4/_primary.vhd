library verilog;
use verilog.vl_types.all;
entity crc32_d4 is
    generic(
        Tp              : integer := 1
    );
    port(
        Clk             : in     vl_logic;
        Rst_n           : in     vl_logic;
        Data            : in     vl_logic_vector(0 to 3);
        Enable          : in     vl_logic;
        Initialize      : in     vl_logic;
        Crc             : out    vl_logic_vector(31 downto 0);
        CrcError        : out    vl_logic;
        Crc_eth         : out    vl_logic_vector(31 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of Tp : constant is 1;
end crc32_d4;
