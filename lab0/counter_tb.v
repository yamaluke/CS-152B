`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2026 10:20:18 AM
// Design Name: 
// Module Name: counter_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module counter_tb(
    );
reg clk;
reg rst;
wire [3:0] counter;
reg correct;
integer testNum;
integer i;


counter_4bit my_counter(
    .clk(clk),
    .rst(rst),
    .count(counter)
);

initial begin
    // initialization
    clk = 0;
    rst = 0;
    correct = 1;
    testNum = 0;
    
    
    // test one
    testNum = 1;
    #6;
    rst = 1;
    #0.5;
    if(counter != 0)begin
        correct = 0;
    end
    #1;
    rst = 0;
    correct = 1;
    
    
    // test two
    testNum = 2;
    
    // reset to 0
    rst = 1;
    #0.5;
    rst = 0;
    if(counter != 4'b0000)begin
            correct = 0;
    end
    
    // increment to 15
    #15;
    if(counter != 4'b1111)begin
        correct = 0;
    end
    
    // overflow 
    #1;
    if(counter != 4'b0000)begin
        correct = 0;
    end
    #1;
    
    // reset 
    correct = 1;
    
    
    
    
    
end

always begin
    #0.5 clk = ~clk;
end


    
endmodule
