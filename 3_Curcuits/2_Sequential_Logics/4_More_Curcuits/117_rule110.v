module top_module(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
); 
    
    wire [511:0] l = q[511:1];
    wire [511:0] r = {q[510:0], 1'h0};

    always @(posedge clk) begin
        if (load)
            q <= data;
        else 
            q <= r & (~q | ~l) | ~r & q;
    end
    
endmodule
