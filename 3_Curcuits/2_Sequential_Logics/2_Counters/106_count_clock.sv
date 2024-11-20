module top_module (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss);

    wire [2:0][7:0] col;
    assign {hh, mm, ss} = col;

    // 进位条件
    localparam [2:0][7:0] CARRY_CONDS = {8'h11, 8'h59, 8'h59};

    // 进制设定
    localparam [2:0][7:0] UPTO = {8'h12, 8'h59, 8'h59};
    localparam [2:0][7:0] DOWNTO = {8'h01, 8'h00, 8'h00};

    // 重置设定
    localparam [2:0][7:0] RESETTO = {8'h12, 8'h00, 8'h00};
    localparam PM_RESETTO = 1'b0;

    wire [3:0] enables;
    assign enables[0] = ena;

    // control pm clk logics
    always @(posedge clk) begin
        if (reset) 
            pm <= PM_RESETTO;
        else if (enables[3])
            pm <= ~pm;
    end

    // instantiate bcdcount2 modules to handle each group of numbers;
    generate
        genvar i;
        for (i = 0; i < 3; i += 1) begin : bcd_gen_block
            assign enables[i+1] = enables[i] && (col[i] == CARRY_CONDS[i]);
            bcdcount2 #(RESETTO[i], UPTO[i], DOWNTO[i]) wbcd (clk, reset, enables[i], col[i]);
        end
    endgenerate

endmodule

module bcdcount2 #(
    parameter [1:0][3:0] RESETTO,
    parameter [1:0][3:0] UPTO,
    parameter [1:0][3:0] DOWNTO
) (
    input clk,
    input reset,
    input ena,
    output reg [1:0][3:0] q);

    localparam LOGIT_HIGH = 4'h9;
    localparam LOGIT_LOW = 4'h0;

    wire loop = ena & q == UPTO;

    wire [2:0] enables;
    assign enables[0] = ena;

    generate
        genvar i;
        for (i = 0; i < 2; i++) begin : g2
            bcdcount #(RESETTO[i], DOWNTO[i], LOGIT_HIGH, LOGIT_LOW) (clk, reset, loop, enables[i], q[i], enables[i+1]);
        end
    endgenerate

endmodule

module bcdcount #(
    parameter [3:0] RESETTO,
    parameter [3:0] SETTO,
    parameter [3:0] DIGIT_HIGHT = 4'h9,
    parameter [3:0] DIGIT_LOW = 4'h0
) (
    input clk,
    input reset,
    input set,
    input ena,
    output reg [3:0] q,
    output cout
);
    wire cout0 = q == DIGIT_HIGHT;
    assign cout = cout0 & ena;

    always @(posedge clk) begin
        if (reset)
            q <= RESETTO;
        else if (set)
            q <= SETTO;
        else if (ena) begin
            if (cout0)
                q <= DIGIT_LOW;
            else
                q <= q + 4'h1;
        end
    end

endmodule