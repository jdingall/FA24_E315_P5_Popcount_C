`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Created for Indiana University's E315 Class
//
// 
// Andrew Lukefahr     //////////MICHAEL NEEDS TO CHANGE THIS//////////
// lukefahr@iu.edu
//
// Ethan Japundza
// ejapundz@iu.edu
//
//
// 2021-02-23
// 2020-02-25
//
//////////////////////////////////////////////////////////////////////////////////


module popcount(
        input               ACLK,
        input               ARESETN,

        //MMIO Inputs
        input [31:0]        WRITE_DATA,
        input               WRITE_VALID,
        
        // Count signals
        output logic [31:0] COUNT,
        input               COUNT_RST,
        output logic        COUNT_BUSY //busy = 1 when counting is happening, busy=0 at idle 
        
    );
    integer i;
    reg [31:0] nextCount = 0;

    always_ff@(posedge ACLK) begin
        if(COUNT_RST) 
            COUNT <= 0;
        else
            COUNT <= nextCount;
    end
    
    always_comb begin
        nextCount =  COUNT;
        if(WRITE_VALID)
            for(i=0;i<32;i++) nextCount += WRITE_DATA[i];
    end
    
    assign COUNT_BUSY = WRITE_VALID;
    
endmodule
