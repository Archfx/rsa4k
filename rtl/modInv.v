////////////////////////////////////////////////////////////////////////////////
// File:        modInv.v
// Description: Compute Modular inverse of a prime number
// Author:      Aruna Jayasena
// Date:        March 17, 2024
// Version:     1.0
// Revision:    -
// Company:     archfx.github.io
////////////////////////////////////////////////////////////////////////////////

module modInv (
    input clk, go,
    input [4095:0] n,
    output reg signed [63:0] modulo_inv,
    output reg valid
);
 
reg signed [4096:0] a, b;
reg signed [63:0] x, y, prev_x, prev_y, temp_a, temp_x, temp_y;
reg signed [4096:0] quotient;
parameter [4096:0] m = 4097'd18446744073709551616;


always @(posedge clk) begin
    if (go) begin
        a <= n;
        b <= m;
        x <= 4096'd0;
        y <= 4096'd1;
        prev_x <= 4096'd1;
        prev_y <= 4096'd0;
        valid <= 1'b0;
        quotient <=0;
           end
    else begin
        // $display("b : %d", b);
        if (b != 4096'd0) begin
            quotient = a / b;
            // $display("prev_x : %d", prev_x);
            a <= b;
            b <= a % b;
            x <= prev_x - (quotient * x);
            prev_x <= x;
            y <= prev_y - (quotient * y);
            prev_y <= y;
        end else begin
            if (a != 4096'd1) begin
                // Modulo inverse does not exist
                valid <= 1'b0;
            end else begin
                // Modulo inverse exists
                modulo_inv <= (-(prev_x % m) % m);
                valid <= 1'b1;
            end
        end
    end
end

endmodule


