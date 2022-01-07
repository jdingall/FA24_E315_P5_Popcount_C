module axi4lite_synth_tb();


logic           ACLK;
logic           ARESETN;

// AXI4-Lite Interface
// (Some signals are unused in our implimentation)
logic [31: 0]                   S_AXI_LITE_AWADDR;
logic [2 : 0]                   S_AXI_LITE_AWPROT; 
logic                           S_AXI_LITE_AWVALID;
wire                            S_AXI_LITE_AWREADY;
logic [31:0]                    S_AXI_LITE_WDATA;
logic [3: 0]                    S_AXI_LITE_WSTRB;
logic                           S_AXI_LITE_WVALID;
wire                            S_AXI_LITE_WREADY;
wire [1 : 0]                    S_AXI_LITE_BRESP;
wire                            S_AXI_LITE_BVALID;
logic                           S_AXI_LITE_BREADY;
logic [31: 0]                   S_AXI_LITE_ARADDR;
logic [2 : 0]                   S_AXI_LITE_ARPROT;
logic                           S_AXI_LITE_ARVALID;
wire                            S_AXI_LITE_ARREADY;
wire [31: 0]                    S_AXI_LITE_RDATA;
wire [1 : 0]                    S_AXI_LITE_RRESP;
wire                            S_AXI_LITE_RVALID;
logic                           S_AXI_LITE_RREADY;



axi_popcount pc0 
	(       

        // AXI4-Lite Interface
        // (Some signals are unused in our implimentation)
		.S_AXI_LITE_ACLK(ACLK),
		.S_AXI_LITE_ARESETN(ARESETN),
		.S_AXI_LITE_AWADDR,
		.S_AXI_LITE_AWPROT, 
		.S_AXI_LITE_AWVALID,
		.S_AXI_LITE_AWREADY,
		.S_AXI_LITE_WDATA,
		.S_AXI_LITE_WSTRB,
		.S_AXI_LITE_WVALID,
		.S_AXI_LITE_WREADY,
		.S_AXI_LITE_BRESP,
		.S_AXI_LITE_BVALID,
		.S_AXI_LITE_BREADY,
		.S_AXI_LITE_ARADDR,
		.S_AXI_LITE_ARPROT,
		.S_AXI_LITE_ARVALID,
		.S_AXI_LITE_ARREADY,
		.S_AXI_LITE_RDATA,
		.S_AXI_LITE_RRESP,
		.S_AXI_LITE_RVALID,
		.S_AXI_LITE_RREADY
	);


always #10 ACLK=~ACLK;

task init_signals();
    ACLK='h0;
    ARESETN='h0;

    // AXI4-Lite Interface
    S_AXI_LITE_AWADDR = 32'h0;
    S_AXI_LITE_AWPROT = 3'h0; 
    S_AXI_LITE_AWVALID = 1'h0;
    S_AXI_LITE_WDATA = 32'h0;
    S_AXI_LITE_WSTRB = 4'h0;
    S_AXI_LITE_WVALID = 1'h0;
    S_AXI_LITE_BREADY = 1'h0;
    S_AXI_LITE_ARADDR = 32'h0;
    S_AXI_LITE_ARPROT = 3'h0;
    S_AXI_LITE_ARVALID = 1'h0;
    S_AXI_LITE_RREADY = 1'h0;

endtask

task send_word_axi4lite(
    input logic [31:0] addr,
    input logic [31:0] data
    );
    
    S_AXI_LITE_AWADDR = addr;
    S_AXI_LITE_AWVALID = 1'h1;
    
    S_AXI_LITE_BREADY = 1'h1;
    #1;
    while( S_AXI_LITE_AWREADY == 'h0) begin
        @(negedge ACLK);
        #1;
    end

    @(negedge ACLK);
    S_AXI_LITE_AWVALID = 1'h0;

    S_AXI_LITE_WDATA = data;
    S_AXI_LITE_WSTRB = 4'hf;
    S_AXI_LITE_WVALID = 1'h1;
    #1
    while (S_AXI_LITE_WREADY == 'h0) begin
        @(negedge ACLK);
        #1;
    end
    @(negedge ACLK);
    S_AXI_LITE_WVALID = 1'h0;
    S_AXI_LITE_BREADY = 1'h0;
 
endtask

task recv_word_axi4lite(
    input logic [31:0] addr,
    output logic [31:0] data
    );
       
    S_AXI_LITE_ARADDR = addr;
    S_AXI_LITE_ARPROT = 3'h0;
    S_AXI_LITE_ARVALID = 1'h1;
    #1
    while (S_AXI_LITE_ARREADY == 'h0) begin
        @(negedge ACLK);
        #1;
    end

    @(negedge ACLK);
    S_AXI_LITE_ARVALID = 1'h0;
    S_AXI_LITE_RREADY = 1'h1;
    #1
    while (S_AXI_LITE_RVALID == 'h0) begin
        @(negedge ACLK);
        #1;
    end
    data = S_AXI_LITE_RDATA;

    @(negedge ACLK);
    S_AXI_LITE_RREADY = 1'h0;
   
endtask    

integer mmio_addr=32'h40000000;
logic [31:0] recv_data;

initial begin
    init_signals();
    for (int i = 0;i < 16;i++) 
        @(negedge ACLK);
    ARESETN=1;
    
    @(negedge ACLK);

    //reset MMIO
    send_word_axi4lite( mmio_addr, 32'h1); 

    for ( int i = 32'h0; i < 32'h6; i++) begin
        $display("Writing Data: %h", i);
        send_word_axi4lite( mmio_addr + 4'h4, i);
        @(negedge ACLK);
    end

    @(negedge ACLK);
    
    recv_word_axi4lite(mmio_addr + 32'h4, recv_data); 
    $display( "Read Data: %h", recv_data);
    assert( recv_data == 7) else $fatal(1, "Bad Test Response: %d != %d", recv_data, 7);
    
    $display("@@@Passed");
    $finish;
end

endmodule
