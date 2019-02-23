library verilog;
use verilog.vl_types.all;
entity check_sum is
    port(
        ver             : in     vl_logic_vector(3 downto 0);
        hdr_len         : in     vl_logic_vector(3 downto 0);
        tos             : in     vl_logic_vector(7 downto 0);
        tot_len         : in     vl_logic_vector(15 downto 0);
        id              : in     vl_logic_vector(15 downto 0);
        offset          : in     vl_logic_vector(15 downto 0);
        ttl             : in     vl_logic_vector(7 downto 0);
        protocol        : in     vl_logic_vector(7 downto 0);
        src_ip          : in     vl_logic_vector(31 downto 0);
        dst_ip          : in     vl_logic_vector(31 downto 0);
        res_check_sum   : out    vl_logic_vector(15 downto 0)
    );
end check_sum;
