`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jubayer Mahmod
// 
// Create Date: 10/03/2018 12:57:28 PM
// Design Name: SRAM read/ write
// Module Name: Top_WR
// Project Name: Aging
// Target Devices: ARTIX 7
// Tool Versions: Viavid 2017.2 
// Description: This module is designed to write intial zeros to on board SRAM and read those back to match uninitalized data 

// 
// Dependencies: uart.v
// 
// Revision 0.01
// Additional Comments: Top.V file is the predecessor of this file. But it has not 
// been designed for writing files to memory
// 
//////////////////////////////////////////////////////////////////////////////////

module Top_WR(clk, rst, uart_txd, uart_rxd,MemAdr,MemDB,RamOEn,RamWEn,RamCEn,a,DoneWrite);
input clk, rst;
inout [7:0]MemDB;// this one is tricky
input uart_rxd;
output uart_txd;
output reg [18:0]MemAdr;
output reg RamOEn;
output reg RamWEn;
output reg RamCEn;
output reg DoneWrite;
reg [127:0] data_in;
wire [127:0] data_out;
reg input_data_valid;
wire output_data_valid;
reg [7:0] uart_tx_data;
reg uart_tx_data_valid;
wire uart_tx_data_ack;
wire uart_txd, uart_rxd;
wire [7:0] uart_rx_data;
wire uart_rx_data_fresh;
input a;// controls the write operation;
reg [7:0]temp_MemDB;
reg [19:0] uart_byte_counter;


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

assign MemDB= a? temp_MemDB:8'bzzzzzzzz;// True: false


always @(posedge clk )
begin
	if (rst) begin
		uart_tx_data <= 8'h00;
		uart_tx_data_valid <= 1'b0;
	    MemAdr<=0;
	    uart_byte_counter <= 19'h0;
	    DoneWrite<=0;
	end
	
	else if(a==1'b1) begin
        MemAdr<=MemAdr+1;// never do this in the middle of the operation
        RamWEn<=0;
        temp_MemDB<=7'd0;
        if(MemAdr==524287) DoneWrite<=1;  //Let me know that writing is done   
        uart_tx_data_valid <= 1'b0;
	end
	else if ((a==1'b0))begin
	       RamWEn<=1;// read mode
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
