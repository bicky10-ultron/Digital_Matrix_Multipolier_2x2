module mac_unit (
    input clk,
    input rst_n,
    input start,
    input [7:0] multiplicand,
    input [7:0] multiplier,
    input accumulate_en,
    output reg [15:0] result,
    output reg done
);
    reg [15:0] product;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 0;
            done <= 0;
        end else if (start) begin
            product <= multiplicand * multiplier;
            if (accumulate_en)
                result <= result + product;
            else
                result <= product;
            done <= 1;
        end else begin
            done <= 0;
        end
    end
endmodule

module matrix_mul_2x2_seq (
    input clk,
    input rst_n,
    input start,
    input [7:0] a11, a12, a21, a22,
    input [7:0] b11, b12, b21, b22,
    output reg [15:0] c11, c12, c21, c22,
    output reg done
);
    reg [3:0] state;
    reg [15:0] accumulator;
    reg [7:0] mult_a, mult_b;
    reg accumulate_en;
    reg mac_start;
    wire [15:0] mac_result;
    wire mac_done;

    mac_unit mac (
        .clk(clk),
        .rst_n(rst_n),
        .start(mac_start),
        .multiplicand(mult_a),
        .multiplier(mult_b),
        .accumulate_en(accumulate_en),
        .result(mac_result),
        .done(mac_done)
    );

    // States for 8 multiply-accumulate ops
    // For each c[i][j] = sum_k a[i][k] * b[k][j]
    // We'll do each multiply-accumulate in one state cycle

    localparam IDLE = 0,
               C11_1 = 1, C11_2 = 2,
               C12_1 = 3, C12_2 = 4,
               C21_1 = 5, C21_2 = 6,
               C22_1 = 7, C22_2 = 8,
               DONE = 9;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            done <= 0;
            accumulator <= 0;
            mac_start <= 0;
            accumulate_en <= 0;
            c11 <= 0; c12 <= 0; c21 <= 0; c22 <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (start) begin
                        accumulator <= 0;
                        mult_a <= a11; mult_b <= b11;
                        accumulate_en <= 0;
                        mac_start <= 1;
                        state <= C11_1;
                    end
                end

                // c11 = a11*b11 + a12*b21
                C11_1: begin
                    mac_start <= 0;
                    if (mac_done) begin
                        accumulator <= mac_result;
                        mult_a <= a12; mult_b <= b21;
                        accumulate_en <= 1;
                        mac_start <= 1;
                        state <= C11_2;
                    end
                end
                C11_2: begin
                    mac_start <= 0;
                    if (mac_done) begin
                        c11 <= mac_result;
                        accumulator <= 0;
                        mult_a <= a11; mult_b <= b12;
                        accumulate_en <= 0;
                        mac_start <= 1;
                        state <= C12_1;
                    end
                end

                // c12 = a11*b12 + a12*b22
                C12_1: begin
                    mac_start <= 0;
                    if (mac_done) begin
                        accumulator <= mac_result;
                        mult_a <= a12; mult_b <= b22;
                        accumulate_en <= 1;
                        mac_start <= 1;
                        state <= C12_2;
                    end
                end
                C12_2: begin
                    mac_start <= 0;
                    if (mac_done) begin
                        c12 <= mac_result;
                        accumulator <= 0;
                        mult_a <= a21; mult_b <= b11;
                        accumulate_en <= 0;
                        mac_start <= 1;
                        state <= C21_1;
                    end
                end

                // c21 = a21*b11 + a22*b21
                C21_1: begin
                    mac_start <= 0;
                    if (mac_done) begin
                        accumulator <= mac_result;
                        mult_a <= a22; mult_b <= b21;
                        accumulate_en <= 1;
                        mac_start <= 1;
                        state <= C21_2;
                    end
                end
                C21_2: begin
                    mac_start <= 0;
                    if (mac_done) begin
                        c21 <= mac_result;
                        accumulator <= 0;
                        mult_a <= a21; mult_b <= b12;
                        accumulate_en <= 0;
                        mac_start <= 1;
                        state <= C22_1;
                    end
                end

                // c22 = a21*b12 + a22*b22
                C22_1: begin
                    mac_start <= 0;
                    if (mac_done) begin
                        accumulator <= mac_result;
                        mult_a <= a22; mult_b <= b22;
                        accumulate_en <= 1;
                        mac_start <= 1;
                        state <= C22_2;
                    end
                end
                C22_2: begin
                    mac_start <= 0;
                    if (mac_done) begin
                        c22 <= mac_result;
                        done <= 1;
                        state <= DONE;
                    end
                end

                DONE: begin
                    if (!start) begin
                        done <= 0;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule
