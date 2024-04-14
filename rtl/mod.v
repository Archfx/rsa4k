////////////////////////////////////////////////////////////////////////////////
// File:        mod.v
// Description: Modular computation to compute parameters r and t.
// Author:      Aruna Jayasena
// Date:        March 17, 2024
// Version:     1.0
// Revision:    -
// Company:     archfx.github.io
////////////////////////////////////////////////////////////////////////////////


module rtMod(
    input wire clk,
    input wire go,
    input wire mode,
    input wire [4095:0] n,
    output wire [4095:0] r,
    output reg done
);
 
parameter [4097:0] mainreg = { 2'd1, 4096'd0};
reg [11:0] count;
reg [8193:0] r_temp;

assign r = r_temp[4095:0];
 
parameter op_R = 0, op_T =1;
 
parameter START = 0, SUB = 1, DONE =2 , R2= 3;
reg r2;
  
always @(posedge clk) begin

    if (go) begin
        r_temp <= mainreg;
        done <= 0;
        count<=SUB;
        r2<=0;
    end

    case (count)
        SUB: begin
            if (r_temp > n) begin
                r_temp <= r_temp % n;
                count<=SUB;
                if (mode == op_R) begin
                    done <= 1;
                end
            end
            else begin 
                if (mode == op_T) begin
                    count <= R2;
                    done <= 0;
                end
            end
        end
        R2: begin
            r_temp <= (r_temp * r_temp)%n;
            done <= 0;
            count<=DONE;
        end
        DONE: begin
            done <= 1;
        end
        default: begin
        end
    endcase
end
 
endmodule
 
 
