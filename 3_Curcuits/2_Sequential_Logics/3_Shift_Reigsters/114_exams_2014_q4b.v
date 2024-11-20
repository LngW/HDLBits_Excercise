module top_module (
    input [3:0] SW,
    input [3:0] KEY,
    output [3:0] LEDR
); //

    generate 
        genvar i;
        for (i = 0; i < 3; i++) begin : g0
            MUXDFF(KEY[0], LEDR[i + 1], KEY[1], SW[i], KEY[2], LEDR[i]);
        end
    endgenerate

    MUXDFF(KEY[0], KEY[3], KEY[1], SW[3], KEY[2], LEDR[3]);

endmodule

module MUXDFF (
    input clk,
    input w, e, r, l,
    output q    
);

    wire d = l ? r : (e ? w : q);

    always @(posedge clk)
        q <= d;

endmodule
