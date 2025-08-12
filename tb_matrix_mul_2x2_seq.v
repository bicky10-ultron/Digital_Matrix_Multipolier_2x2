`timescale 1ns / 1ps

module tb_matrix_mul_2x2_seq;

    reg clk;
    reg rst_n;
    reg start;

    reg [7:0] a11, a12, a21, a22;
    reg [7:0] b11, b12, b21, b22;

    wire [15:0] c11, c12, c21, c22;
    wire done;

    matrix_mul_2x2_seq uut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .a11(a11), .a12(a12), .a21(a21), .a22(a22),
        .b11(b11), .b12(b12), .b21(b21), .b22(b22),
        .c11(c11), .c12(c12), .c21(c21), .c22(c22),
        .done(done)
    );

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // Waveform dump commands
        $dumpfile("matrix_seq_tb.vcd");
        $dumpvars(0, tb_matrix_mul_2x2_seq);

        rst_n = 0;
        start = 0;

        // Reset the design
        #20;
        rst_n = 1;

        // Test 1: Identity matrix multiplication
        a11 = 8'd1; a12 = 8'd0; a21 = 8'd0; a22 = 8'd1;
        b11 = 8'd1; b12 = 8'd2; b21 = 8'd3; b22 = 8'd4;
        #10;
        start = 1;
        #10;
        start = 0;

        wait(done);
        $display("Test 1 done: c11=%d c12=%d c21=%d c22=%d", c11, c12, c21, c22);
        #20;

        // Test 2: All elements = 2
        a11 = 8'd2; a12 = 8'd2; a21 = 8'd2; a22 = 8'd2;
        b11 = 8'd2; b12 = 8'd2; b21 = 8'd2; b22 = 8'd2;
        #10;
        start = 1;
        #10;
        start = 0;

        wait(done);
        $display("Test 2 done: c11=%d c12=%d c21=%d c22=%d", c11, c12, c21, c22);
        #20;

        // Test 3: Random values
        a11 = 8'd5; a12 = 8'd7; a21 = 8'd3; a22 = 8'd2;
        b11 = 8'd6; b12 = 8'd1; b21 = 8'd4; b22 = 8'd8;
        #10;
        start = 1;
        #10;
        start = 0;

        wait(done);
        $display("Test 3 done: c11=%d c12=%d c21=%d c22=%d", c11, c12, c21, c22);
        #20;

        $finish;
    end

endmodule

