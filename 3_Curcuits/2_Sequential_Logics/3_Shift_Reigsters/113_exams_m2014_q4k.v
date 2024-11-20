module top_module (
    input clk,
    input resetn,   // synchronous reset
    input in,
    output out);

    reg [3:0] d;

    always @(posedge clk) begin
        if (!resetn)
            d <= 'h0;
        else begin
            // d <= {d[2:0], in}; // a better way to do this;
            d[0] <= in;
            for (int i = 1; i < $bits(d); i++)
                d[i] <= d[i-1];
        end
    end


    assign out = d[3];

endmodule
