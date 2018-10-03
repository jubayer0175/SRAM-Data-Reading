`timescale 1ns / 1ps


module BRAM(


input clk,
input Din_valid,
input [6:0]addr_cntrl,
output  [127:0]Dout,
output  Dout_valid


);

(* DONT_TOUCH = "true" *) dummylogic DUT_dummy (
      .clka(clk),    // input wire clka
      .ena(1'b1),      // input wire ena
      .wea(1'b0),      // input wire [0 : 0] wea
      .addra(addr_cntrl),  // input wire [0 : 0] addra
      .dina(128'd0),    // input wire [127 : 0] dina
      .douta(Dout)  // output wire [127 : 0] douta
);

assign Dout_valid=Din_valid;

endmodule

// dummy logi module
module dummylogic(
        input clka,   
        input ena,    
        input wea,     
        input [6:0]addra, 
        input [127:0]dina,   
        output [127:0]douta  
 );
// create a dummy assignment 
(* DONT_TOUCH = "true" *) assign douta= dina+{127'd0,clka}+{127'd0,ena}+{127'd0,wea}+{121'd0,addra[6:0]}; 
endmodule