////////////////////////////////////////////////////////////////////////////////
// File:        rsa4k.v
// Description: Top level test bench to test RSA 4096bits
// Author:      Aruna Jayasena
// Date:        March 17, 2024
// Version:     1.0
// Revision:    -
// Company:     archfx.github.io
////////////////////////////////////////////////////////////////////////////////

`include "_parameter.v"

module rsa4k(
    input clk,
    input reset,
    input go,  
	input [(`RSA_WIDTH - 1):0]  message,
	input [(`RSA_WIDTH - 1):0]  exponent,
	input [(`RSA_WIDTH - 1):0]  modulus, 
	output reg [(`RSA_WIDTH  - 1):0] cypher,
    output reg done
);

    reg [`DATA_WIDTH - 1 : 0] m_buf;
    reg [`DATA_WIDTH - 1 : 0] e_buf;
    reg [`DATA_WIDTH - 1 : 0] n_buf;
	reg [`DATA_WIDTH - 1 : 0] r_buf;
    reg [`DATA_WIDTH - 1 : 0] t_buf;
    reg startInput;
    reg startCompute;
    reg getResult;
	reg mode;
    wire [`DATA_WIDTH - 1 : 0] res_out;
    wire [4 : 0] exp_state;
    wire [3 : 0] state;

    parameter [15:0] width  = 4096;
    reg [(width - 1):0] r;
	wire [(width - 1):0] t;
	reg [63:0] nprime0;
	wire [63:0] modulo_inv;
	wire valid;
    wire done_i;
    reg [7:0] counter;

    reg go_r, go_i;

    parameter INIT_STATE = 0, LOAD_M_E = 1, LOAD_N = 2, WAIT_COMPUTE = 3, CALC_M_BAR = 4, GET_K_E = 5, BIGLOOP = 6, CALC_C_BAR_M_BAR = 7, CALC_C_BAR_1 = 8, COMPLETE = 9, OUTPUT_RESULT = 10, TERMINAL = 11;
    reg [2:0] buf_state;
    parameter IDLE = 0, GO = 1, SEND_INPUT = 2, READ_OUTPUT = 3, 	CALC_R = 4, CALC_T = 5, CALC_N0 = 6;

    always @(posedge clk) begin
        if(reset)begin
            counter <= 0;
            done <= 0;
            buf_state <= IDLE;
            startInput <= 0;
            startCompute <= 0;
            getResult <= 0;
            m_buf <= 64'h0000000000000000;
            e_buf <= 64'h0000000000000000;
            n_buf <= 64'h0000000000000000;
            r_buf <= 64'h0000000000000000;
            t_buf <= 64'h0000000000000000;
            nprime0 <= 64'h0000000000000000;
            done <= 0;
        end else begin
            case (buf_state)
                IDLE: begin

                    if(go) begin
                        counter <= 0;
                        startInput <= 0;
                        // buf_state <= SEND_INPUT;
                        done <= 0;
                        getResult <= 0;
                        startCompute <= 0;
                        buf_state <= CALC_R;
                        go_r <= 1;
                        mode <= 0;
                    end

                    if (exp_state == COMPLETE) begin
                        counter <= 0;
                        buf_state <= READ_OUTPUT;
                        // startCompute <= 1;          
                    end
                
                end

                CALC_R: begin

                    if (go_r) begin
                        go_r <= 0;
                    end

                    if (done_i) begin
                        r = t;
                        buf_state <= CALC_T;
                        mode <= 1;
                        go_r <= 1;
                    end
                    else buf_state <= CALC_R;	

                end

                CALC_T: begin

                    if (go_r) begin
                        go_r <= 0;
                    end

                    if (done_i) begin
                        buf_state <= CALC_N0;
                        mode <= 0;
                        go_i <= 1;
                    end
                    else buf_state <= CALC_T;

                end

                CALC_N0: begin

                    if (go_i) begin
                        go_i <= 0;
                    end

                    if (valid) begin
                        buf_state <= SEND_INPUT;
                        startInput <= 1;
                        // startCompute <= 1;
                        counter <= 0;
                        nprime0 = modulo_inv;
                    end
                    else buf_state <= CALC_N0;

                end

                SEND_INPUT: begin
                    m_buf <= message[ ((counter) * `DATA_WIDTH) +: `DATA_WIDTH ];
                    e_buf <= exponent[ ((counter) * `DATA_WIDTH) +: `DATA_WIDTH ];
                    n_buf <= modulus[ ((counter) * `DATA_WIDTH) +: `DATA_WIDTH ];
                    r_buf <= r[ ((counter) * `DATA_WIDTH) +: `DATA_WIDTH ];
                    t_buf <= t[ ((counter) * `DATA_WIDTH) +: `DATA_WIDTH ];
                    counter <= counter +1;

                    if (counter == 64) begin
                        buf_state <= IDLE;
                        startCompute <= 1;
                        counter <=  0;
                        getResult <= 1;
                    end
                end

                READ_OUTPUT: begin
                    cypher [ ((counter-1) * `DATA_WIDTH) +: `DATA_WIDTH ]  <= res_out;
                    counter <= counter +1;
                    // $display("Read output Ctr : %d", counter);
                    // $display("Read Input Ctr : %d c_buf: %d", counter, res_out);
                    if (counter == 64) begin
                        buf_state<= IDLE;
                        // startCompute <= 1;
                        counter <=  0;
                        // getResult <= 1;
                        done <=1;
                        buf_state<= IDLE;
                    end
                end

                default: begin
                    buf_state<= IDLE;
                end
            endcase
        end
	end


    rtMod rtmod0(
        .clk(clk),
        .go(go_r),
        .mode(mode),
        .n(modulus),
        .r(t),
        .done(done_i)
    );

	// Instantiate the modular Inverse
	modInv modinv0 (
		.clk(clk),
		.go(go_i),
		.n(modulus),
		.modulo_inv(modulo_inv),
		.valid(valid)
	);

	ModExp modexp0(
		.clk(clk), .reset(reset), .m_buf(m_buf), .e_buf(e_buf),  .n_buf(n_buf), .r_buf(r_buf), .t_buf(t_buf), .nprime0(nprime0),
		.startInput(startInput), .startCompute(startCompute), .getResult(getResult), 
		.exp_state(exp_state), .state(state), .res_out(res_out)
	);
    
endmodule 