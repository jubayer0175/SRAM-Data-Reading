// This is written for extracting 512KB bits of uninitialized 
//SRAM data from ARTIX 7 FPGA CMOD board
//There may be redundant nets. 
/*The buad rate is set to 9600 with default settings
--Jubyaer
--10/03/218
Project Folder: C:/Users/mzm0175/Desktop/PR_my/Artix_7_15T
 */
module Top(clk, rst, uart_txd, uart_rxd,MemAdr,MemDB,RamOEn,RamWEn,RamCEn);
input clk, rst;
input [7:0]MemDB;
input uart_rxd;
output uart_txd;
output reg [18:0]MemAdr;
output reg RamOEn;
output reg RamWEn;
output reg RamCEn;
reg [127:0] data_in;
wire [127:0] data_out;
reg input_data_valid;
wire output_data_valid;
//SRAM control bits;
// UART
reg [7:0] uart_tx_data;
reg uart_tx_data_valid;
wire uart_tx_data_ack;
wire uart_txd, uart_rxd;
wire [7:0] uart_rx_data;
wire uart_rx_data_fresh;

// State machine
reg [1:0] state, next_state;
reg [19:0] uart_byte_counter;
reg [11:0]cont;

wire clk;
uart u (.clk(clk),
		.rst(rst),
		.tx_data(uart_tx_data),
		.tx_data_valid(uart_tx_data_valid),
		.tx_data_ack(uart_tx_data_ack),
		.txd(uart_txd),
		.rx_data(uart_rx_data),
		.rx_data_fresh(uart_rx_data_fresh),
		.rxd(uart_rxd));
defparam u .CLK_HZ = 12_000_000;
defparam u .BAUD = 9600;
initial begin
RamOEn<=0;
RamWEn<=1;
RamCEn<=0;
end
always @(posedge clk )
begin
	if (rst) begin
		uart_tx_data <= 8'h00;
		uart_tx_data_valid <= 1'b0;
	    MemAdr<=0;
	    uart_byte_counter <= 19'h0;
	end        
	else begin   
	        if (uart_byte_counter <= 20'd524287) begin		// there should be total 524288 bytes		
                        if (uart_tx_data_ack == 1'b1) begin
                            uart_tx_data_valid <= 1'b0;
                            uart_byte_counter <= uart_byte_counter + 1'b1;
                            MemAdr<=MemAdr+1;             
                        end
                        else if (uart_tx_data_valid == 1'b0) begin
                            uart_tx_data <= MemDB; 
                            uart_tx_data_valid <= 1'b1;
                        end
				    end
            end
 end
endmodule
