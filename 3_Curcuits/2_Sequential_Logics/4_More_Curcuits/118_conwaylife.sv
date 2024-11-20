module top_module(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q ); 

    logic [16:-1][16:-1] qe;
    logic [255:0][3:0] sum;
    always @* begin
        //assign rows
        for (int i = 0; i < 16; i++)
            qe[i][15:0] = q[16*i +: 16];
        qe[-1][15:0] = q[240 +: 16];
        qe[16][15:0] = q[  0 +: 16];

        // assign columns
        for (int i = -1; i < 17; i++)
            {qe[i][-1], qe[i][16]} = {qe[i][15], qe[i][0]};

        // calculate how many neighbers are living;
        for (int i = 0; i < 16; i++)
            for (int j = 0; j < 16; j++)
                sum[i * 16 + j] = qe[i+1][j+1] + qe[i+1][j] + qe[i+1][j-1]
                                + qe[i  ][j+1] +            + qe[i  ][j-1]
                                + qe[i-1][j+1] + qe[i-1][j] + qe[i-1][j-1];
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else 
            for (int i = 0; i < 256; i++)
                // decide what the next state will be;
                if (sum[i] <= 1 || sum[i] >= 4)
                    q[i] <= 0;
                else if (sum[i] == 3)
                    q[i] <= 1;
                else 
                    q[i] <= q[i];
    end

endmodule
