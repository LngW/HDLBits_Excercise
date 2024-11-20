module top_module (
	input [2:0] SW,      // R
	input [1:0] KEY,     // L and clk
	output [2:0] LEDR);  // Q

    reg [2:0] raw_next;
    always @* begin
        raw_next = {LEDR[1:0], LEDR[2]};
        raw_next[2] = LEDR[2] ^ LEDR[1];
    end

    always @(posedge KEY[0]) begin
        if (KEY[1])
            LEDR <= SW;
        else
            LEDR <= raw_next;
    end

endmodule
