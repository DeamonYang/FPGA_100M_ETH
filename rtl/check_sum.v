module check_sum(
	ver		,
	hdr_len	,
	tos		,
	tot_len	,
	id			,
	offset	,
	ttl		,
	protocol	,
	src_ip	,
	dst_ip	,
	
	res_check_sum
	);

	input [3:0]ver		;
	input [3:0]hdr_len	;
	input [7:0]tos		;
	input [15:0]tot_len	;
	input [15:0]id			;
	input [15:0]offset	;
	input [7:0]ttl		;
	input [7:0]protocol	;
	input [31:0]src_ip	;
	input [31:0]dst_ip	;
	
	output[15:0]res_check_sum;
	
	wire [31:0]sum;
	
	assign sum = {ver,hdr_len,tos} + tot_len + offset + {ttl,protocol} + id
					+ src_ip[31:16] + src_ip[15:0] + dst_ip[31:16] + dst_ip[15:0];				
					
	assign res_check_sum = ~(sum[15:0] + sum[31:16]);
	
endmodule










