`include "_parameter.v"

module ModExp_tb();
    reg clk;
    reg reset;
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
    reg [(width - 1):0] message, exponent, modulus, r, t;
	wire [(width - 1):0] modOut;
	reg [63:0] nprime0;
	wire [63:0] modulo_inv;
	wire valid;
    wire done_i;
    reg [7:0] counter;

    // Outputs  of the IP

    reg done;
    reg go_r, go_i, go;
    reg [(width - 1):0] cypher;
    
    ModExp modexp0(
        .clk(clk), .reset(reset), .m_buf(m_buf), .e_buf(e_buf),  .n_buf(n_buf), .r_buf(r_buf), .t_buf(t_buf), .nprime0(nprime0),
        .startInput(startInput), .startCompute(startCompute), .getResult(getResult), 
        .exp_state(exp_state), .state(state), .res_out(res_out)
    );

    parameter INIT_STATE = 0, LOAD_M_E = 1, LOAD_N = 2, WAIT_COMPUTE = 3, CALC_M_BAR = 4, GET_K_E = 5, BIGLOOP = 6, CALC_C_BAR_M_BAR = 7, CALC_C_BAR_1 = 8, COMPLETE = 9, OUTPUT_RESULT = 10, TERMINAL = 11;
    reg [2:0] buf_state;
    parameter IDLE = 0, GO = 1, SEND_INPUT = 2, READ_OUTPUT = 3, 	CALC_R = 4, CALC_T = 5, CALC_N0 = 6;

    initial begin

        $vcdplusfile("rsamont.vpd");
        $vcdpluson();

		// $dumpfile("rsa4k.vcd");
  		// $dumpvars(0);

        clk = 0;



        #10
        reset = 1;
        #10
        reset = 0;


        go = 0;


        message = 4096'd8;
        exponent =  4096'd13;
        modulus =  4096'd77;
        cypher = 0;

        go = 1;
        wait (done);
        // wait (exp_state == OUTPUT_RESULT);
        $display("cypher value (dec) : %d (hex) 0x%h", cypher, cypher);

        // #10
        // reset = 1;
        // #10
        // reset = 0;

        // go = 0;


        // // message = cypher;
        // // exponent =  4096'd37;
        // // modulus =  4096'd77;

        // message= 4096'hccd28fa083c6a9af7d9d12e6c549c7ddd95ae4d35417675acace3751f46865130d40b1ee7b3650d7b2ffec5b56bfedd99fd9f7ef0205b3320ea4d3229451505d0ab9f61231ac23b9f674cc019665c00a06b531d5928e70f9c462f897877fae8f8ce367f4ed51abbe11a4b9bfcf64cad9d6979a6d4cd92516b5afae9817190613;
        // exponent= 4096'h00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f3e7af;
        // modulus= 4096'ha674f0f2a01fa0a987d0ef355f36cbd7eda5a931d5eca30b18fc237a481fcea435fe514166db877ca1e645204b0e1e2a8e5f7fcf28a98306c70424f0f4025c7d8c6d89063ac7847bf52eb1f2852bdd5cc03c1cbf63875b5062f4d22b290526a5fecfe343d39c3b46626b63e91670802b4d7a066973474a757d3e5957ddc020afddbeef963643b237651f7bd58d9af4ea67da7de5620539fb904c5a0243388498013470de777c8f11924add97fa1fb11b51cab46ea38adf995ad5efd0958a98cbf022dfb0d4b128917e4b513f120629051307b4d9d1014a28c55c93aaff59f47a7c0472a8b7a1ad5dbf07252c4b2602278fe18a77ec8acb8798f9f8b720dafe03;
        
		


        // go = 1;
        // wait (done);
        // // wait (exp_state == OUTPUT_RESULT);
        // $display("cypher value (dec) : %d (hex) 0x%h", cypher, cypher);
        // buf_state = IDLE;

        // wait (exp_state == TERMINAL);

        $finish;
        end
    
    always begin
        #5 clk = ~clk;
    end

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
        end
    
    end

    always @(posedge clk) begin
    case (buf_state)
        IDLE: begin

            if(go) begin
                counter <= 0;
                // startInput <= 1;
                // buf_state <= SEND_INPUT;
                done <= 0;
                getResult <= 0;
                // startCompute <= 1;
				buf_state <= CALC_R;
				go_r <= 1;
				mode <= 0;
            end

            if (exp_state == COMPLETE) begin
                counter <= 0;
                buf_state <= READ_OUTPUT;
                startCompute <= 1;          
            end
           
        end

		CALC_R: begin

			if (go_r) begin
				go_r <= 0;
			end

			if (done_i) begin
				r = modOut;
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
				// t = modOut;
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
			t_buf <= modOut[ ((counter) * `DATA_WIDTH) +: `DATA_WIDTH ];
            counter <= counter +1;

            if (counter == 64) begin
                buf_state <= IDLE;
                startCompute <= 1;
                counter <=  0;
                getResult <= 1;

				// $display("Result r: %h", r);
				// $display("Result t: %h", t);
				// $display("Result nprime0: %h", nprime0);
            end
            // $display("Send Input Ctr : %d m_buf: %d", counter, message[ ((counter) * `DATA_WIDTH) +: `DATA_WIDTH ]);
        end

        READ_OUTPUT: begin
            cypher [ ((counter-1) * `DATA_WIDTH) +: `DATA_WIDTH ]  <= res_out;
            counter <= counter +1;
            // $display("Read output Ctr : %d", counter);
            $display("Read Input Ctr : %d c_buf: %d", counter, res_out);
            if (counter == 64) begin
                buf_state<= IDLE;
                // startCompute <= 1;
                counter <=  0;
                // getResult <= 1;
                done <=1;
            end
        end

        default: begin
            buf_state<= IDLE;
        end
    endcase
	end

	// always @(posedge clk) begin
	
	//     case(mode)
	//         0: r=modOut;
	//         1: t=modOut;
	//     endcase
	
	// end

    rtMod uut1(
        .clk(clk),
        .go(go_r),
        .mode(mode),
        .n(modulus),
        .r(modOut),
        .done(done_i)
    );

	// Instantiate the modular Inverse
	modInv uut2 (
		.clk(clk),
		.go(go_i),
		.n(modulus),
		.modulo_inv(modulo_inv),
		.valid(valid)
	);
    
endmodule 