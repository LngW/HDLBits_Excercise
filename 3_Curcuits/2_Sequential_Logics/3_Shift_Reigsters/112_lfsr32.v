module top_module(
    input clk,
    input reset,    // Active-high synchronous reset to 32'h1
    output [31:0] q
); 

    localparam int TAPS[2:0] = '{0, 1, 21};

    reg [31:0] next;
    always @* begin
        next = {q[0], q[31:1]};
        next[31] = q[0] ^ 1'b0;
        for (int i = 0; i < $size(TAPS); i++) begin
            next[TAPS[i]] = q[0] ^ q[TAPS[i] + 1];
        end
    end

    always @(posedge clk) begin
        if (reset)
            q <= 31'h1;
        else
            q <= next;
    end

endmodule
