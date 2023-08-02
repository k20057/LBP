
`timescale 1ns/10ps
module LBP ( clk, reset, gray_addr, gray_req, gray_ready, gray_data, lbp_addr, lbp_valid, lbp_data, finish);
input   	clk;
input   	reset;
output  [13:0] 	gray_addr;
output         	gray_req;
input   	gray_ready;
input   [7:0] 	gray_data;
output  [13:0] 	lbp_addr;
output  	lbp_valid;
output  [7:0] 	lbp_data;
output  	finish;
//====================================================================

reg gray_req, lbp_valid, finish;
reg [13:0] gray_addr, lbp_addr;
reg [3:0] counterG;
reg [3:0] counterS;
reg [7:0] sum, lbp_data, gc_data, gp_data;

reg [13:0] counter1;
reg [13:0] counter2;
reg [13:0] counter3;
reg [13:0] counter4;
reg [13:0] counter5;
reg [13:0] counter6;
reg [13:0] counter7;
reg [13:0] counter8;
reg [13:0] counter9;

always@(posedge clk or posedge reset) 
begin
	if(reset) 
	   gray_req <=0;
	else if (gray_ready) 
	   gray_req <=1;
	else 
	   gray_req <= gray_req;
end

always@(posedge clk or posedge reset) 
begin
	if(reset) 
	   counterG <=0;
	else if (counterG >=9)
	   counterG <= 1;
	else 
	   counterG <= counterG + 1;
end

always@(posedge clk or posedge reset) 
begin
	if(reset) 
	   counterS <=0;
	else 
	   counterS <= counterG;
end

always@(posedge clk or posedge reset) 
begin
	if(reset) 
	   counter1 <=129;
	else if(counterG >=9)
	   counter1 <= counter1 + 1;
	else 
	   counter1 <= counter1;
end

always@(posedge clk or posedge reset) 
begin
	if(reset) 
	   counter2 <=0;
	else if(counterG >=9)
	   counter2 <= counter2 + 1;
	else 
	   counter2 <= counter2;
end

always@(posedge clk or posedge reset) 
begin
	if(reset) 
	   counter3 <=1;
	else if(counterG >=9)
	   counter3 <= counter3 + 1;
	else 
	   counter3 <= counter3;
end

always@(posedge clk or posedge reset) 
begin
	if(reset) 
	   counter4 <=2;
	else if(counterG >=9)
	   counter4 <= counter4 + 1;
	else 
	   counter4 <= counter4;
end

always@(posedge clk or posedge reset) 
begin
	if(reset) 
	   counter5 <=128;
	else if(counterG >=9)
	   counter5 <= counter5 + 1;
	else 
	   counter5 <= counter5;
end

always@(posedge clk or posedge reset) 
begin
	if(reset) 
	   counter6 <=130;
	else if(counterG >=9)
	   counter6 <= counter6 + 1;
	else 
	   counter6 <= counter6;
end

always@(posedge clk or posedge reset) 
begin
	if(reset) 
	   counter7 <=256;
	else if(counterG >=9)
	   counter7 <= counter7 + 1;
	else 
	   counter7 <= counter7;
end

always@(posedge clk or posedge reset) 
begin
	if(reset) 
	   counter8 <=257;
	else if(counterG >=9)
	   counter8 <= counter8 + 1;
	else 
	   counter8 <= counter8;
end

always@(posedge clk or posedge reset) 
begin
	if(reset) 
	   counter9 <=258;
	else if(counterG >=9)
	   counter9 <= counter9 + 1;
	else 
	   counter9 <= counter9;
end

always@(*)
begin
	case (counterG) 
	4'b0001: gray_addr = counter1;
	4'b0010: gray_addr = counter2;
	4'b0011: gray_addr = counter3;
	4'b0100: gray_addr = counter4;
	4'b0101: gray_addr = counter5;
	4'b0110: gray_addr = counter6;
	4'b0111: gray_addr = counter7;
	4'b1000: gray_addr = counter8;
	4'b1001: gray_addr = counter9;
	default: gray_addr = 0;
	endcase
end

always@(posedge clk or posedge reset)
begin
	if (reset) begin
		gc_data <= 0;
		gp_data <= 0;
	end
	else if (counterG ==1) 
		gc_data <= gray_data;
	else	begin
		gp_data <= gray_data;
		gc_data <= gc_data;
	end
end

always@(*)
begin
	if (gp_data >= gc_data) begin
		if(counterS >=2) begin
		case (counterS-1)
		4'b0001: sum = 1;
		4'b0010: sum = 2;
		4'b0011: sum = 4;
		4'b0100: sum = 8;
		4'b0101: sum = 16;
		4'b0110: sum = 32;
		4'b0111: sum = 64;
		4'b1000: sum = 128;
		default: sum = sum;
		endcase
		end
	end
	else 
		sum = sum;
end

integer i;
always@(posedge clk or posedge reset)
begin
	if (reset) begin
		lbp_valid <= 0;
		i <= 0;
	end
	else if (lbp_addr == 255 + 128* i) begin
		lbp_valid <= 0;
		i <= i+1;
	end
	else if (lbp_addr % 128 == 0) 
		lbp_valid <= 0;
	else if (counterS ==9) 
		lbp_valid <= 1;
	else 
		lbp_valid <= 0;
end

always@(posedge clk or posedge reset)
begin
	if (reset) 
		lbp_data <= 0;
	else if (counterS ==1)
		lbp_data <= 0;
	else if (gp_data >= gc_data) begin
		if(counterS >=1) 
		lbp_data <= lbp_data + sum;
	end
	else
		lbp_data <= lbp_data;
end

always@(posedge clk or posedge reset)
begin
	if (reset) 
		lbp_addr <= 0;
	else if (counterG ==9)
		lbp_addr <= counter1;
	else 
		lbp_addr <= lbp_addr;
end

always@(posedge clk or posedge reset)
begin	   
	if (reset) 
		finish <=0;
	else if (lbp_addr >16254)
		finish <=1;
	else 
		finish <=finish;
end

endmodule
