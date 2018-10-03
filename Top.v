//// This module is written for reading SRAM of the board AR7.


//module Top(clk, rst, uart_txd, uart_rxd,led);
//input clk, rst;

//input uart_rxd;
//output uart_txd;
//output reg led;

//// State machine states
//localparam IDLE = 2'b00,TRANSMITTING = 2'b01;

//// AES
//reg [127:0] data_in;
//wire [127:0] data_out;
//reg input_data_valid;
//wire output_data_valid;
//reg [127:0] aes_temp_out;

//// UART
//reg [7:0] uart_tx_data;
//reg uart_tx_data_valid;
//wire uart_tx_data_ack;
//wire uart_txd, uart_rxd;
//wire [7:0] uart_rx_data;
//wire uart_rx_data_fresh;

//// State machine
//reg [1:0] state, next_state;
//reg [4:0] uart_byte_counter;
//reg [11:0]cont;
//reg [7:0]addr;
//wire clk;
//uart u (.clk(clk),
//		.rst(rst),
//		.tx_data(uart_tx_data),
//		.tx_data_valid(uart_tx_data_valid),
//		.tx_data_ack(uart_tx_data_ack),
//		.txd(uart_txd),
//		.rx_data(uart_rx_data),
//		.rx_data_fresh(uart_rx_data_fresh),
//		.rxd(uart_rxd));

//defparam u .CLK_HZ = 12_000_000;
//defparam u .BAUD = 9600;

//BRAM D1 (.clk(clk),
//		 .Din_valid(input_data_valid),
//		 .Dout_valid(output_data_valid),
//		 .Dout(data_out),
//		 .addr_cntrl(addr[6:0]));

//always @(posedge clk )
//begin
//	if (rst) begin
//		uart_byte_counter <= 5'b00000;
//		state <= IDLE;
//		next_state <= IDLE;
//		uart_tx_data <= 8'h00;
//		uart_tx_data_valid <= 1'b0;
//		input_data_valid <= 1'b0;
//	    cont<=0;
//	    addr<=0;
//	    led<=1;
//	end
//	else begin
//	led<=0;
//    cont<=cont+1;
//    state = next_state;        
//		     case(state)
//			IDLE: begin
//			         uart_byte_counter <= 5'b00000;
//                    if((cont==12'd2048) && (addr<=8'd127)) begin
//                        input_data_valid <= 1'b1;
//                        cont<=0;
//                        addr<=addr+1; 
//                    end
//				 if (output_data_valid == 1'b1) begin
//                        input_data_valid <= 1'b0;
//                        aes_temp_out <= data_out;
//                        next_state <= TRANSMITTING;
//                        end
//				else begin
//					   next_state <= IDLE;
//				end
//			end
//			TRANSMITTING: begin
//				if (uart_byte_counter <= 4'hF) begin
//					next_state <= TRANSMITTING;
//					if (uart_tx_data_ack == 1'b1) begin
//						uart_tx_data_valid <= 1'b0;
//						uart_byte_counter <= uart_byte_counter + 1'b1;
//					end
//					else if (uart_tx_data_valid == 1'b0) begin
//					    aes_temp_out = {aes_temp_out[119:0], aes_temp_out[127:120]};
//					    uart_tx_data = aes_temp_out[7:0]; 
//						uart_tx_data_valid <= 1'b1;
//					end
//				end
//				else begin
//					next_state <= IDLE;
//				end
//			end
//		endcase
//	end
//end
//endmodule
// This module is written for reading SRAM of the board AR7.

// this is new module

module Top(clk, rst, uart_txd, uart_rxd,MemAdr,MemDB,RamOEn,RamWEn,RamCEn);
input clk, rst;
input [7:0]MemDB;
input uart_rxd;
output uart_txd;
output reg [18:0]MemAdr;// this one controls the address for the memory
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
//	             if(MemAdr<=19'd55) begin//524287
//                          if(uart_tx_data_ack==1'b0) begin
//                          uart_tx_data_valid<=0;
//                          MemAdr<=MemAdr+1;
                          
//                           end
//                           else if(uart_tx_data_valid==0) begin
//                            uart_tx_data_valid<=1;
//                            uart_tx_data<=MemDB; 
//                           end
//                    end
//                    else// this is ack=1 condition
//                    uart_tx_data_valid<=0;

//  test code  
           // if(MemAdr<=19'd55) begin
                    if (uart_byte_counter <= 20'd524287) begin
				
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
     
        //end 
 end
endmodule
