module modulus_TB;
 
    reg clk, go, goi, mode;
    reg [4095:0] n;
    reg [4095:0] r;
	reg [4095:0] t;
	wire [4095:0] modOut;
	wire [63:0] modulo_inv;
	wire valid;
    wire done;
    
    
 
    rtMod uut1(
        .clk(clk),
        .go(go),
        .mode(mode),
        .n(n),
        .r(modOut),
        .done(done)
    );

	// Instantiate the modular Inverse
	modInv uut2 (
		.clk(clk),
		.go(goi),
		.n(n),
		.modulo_inv(modulo_inv),
		.valid(valid)
	);
	
	always @(posedge clk) begin
	
	    case(mode)
	        0: r=modOut;
	        1: t=modOut;
	    endcase
	
	end
 
    // Clock generation
    always #5 clk = ~clk;
 
    // Test stimulus
    initial begin
        clk = 0;
        go = 0;
        // n = 4096'h44c5b4763fe31d0347fc816ac16e2284c10faa4003ba33db73f7ba8e0445d656de3a5db5154ed51212093d26ac512b01f18dd1eed77c96c0084f3dd6415af341ee52bdb6d1020a15d9ed17e3cc0e95ee8d103ed3cc667e971773308cdc6b13ab2e47dc0e959f3a518cfe5cd12d5db79ba2a7ae1f3ac7652ccdf8440407295e4299901c0475491bc354c56c9a9cc9af4ec9546b439f9d01298a449ebe89d9bf020067dba8589890086a17b9af5b569643d037cdff7c240d4969d495dd81355c53f0e642f43328ad088ded3c9691eb79fa5d5f576cdeb8fc4c7b297d0b0e5e18baf320cd576d14475b349aae908fb5262cc703806984c8199921167d8fcf23cae883333218bd91a1b7f03edca7e2dcaa37f463b337d20b5d59db610487c89da11b62397bc701762741bab9f87ff50592859be3cecb8c497c68a8c24d4244ef7febe8e5b4617589a82b5a702cfa93ea5c4ed8f33418f3d4e7115804f92283868a29678a5aa33b6fe5078c5fe8f8dc3bf364eb8ac8ce8a245e6b33138131c541013d0326324dfb695ffb3a1890c78092b4d42b28fef02b9c014ea5ac06d864c2f2e39403560d97dae38d9d643c25fbb230bbd92a4aa2b410d93c4efbc8d60b21fbac78255d6807923986bb968a437d5c8dfc5eda92d864ac5db9d707107e855c384429e821a4c74803e31ba1621582283d15a9ec0806705fca161622bd795fec898f;
        // n = 4096'ha674f0f2a01fa0a987d0ef355f36cbd7eda5a931d5eca30b18fc237a481fcea435fe514166db877ca1e645204b0e1e2a8e5f7fcf28a98306c70424f0f4025c7d8c6d89063ac7847bf52eb1f2852bdd5cc03c1cbf63875b5062f4d22b290526a5fecfe343d39c3b46626b63e91670802b4d7a066973474a757d3e5957ddc020afddbeef963643b237651f7bd58d9af4ea67da7de5620539fb904c5a0243388498013470de777c8f11924add97fa1fb11b51cab46ea38adf995ad5efd0958a98cbf022dfb0d4b128917e4b513f120629051307b4d9d1014a28c55c93aaff59f47a7c0472a8b7a1ad5dbf07252c4b2602278fe18a77ec8acb8798f9f8b720dafe03;
		n = 4096'd77;
		#10;
		mode = 0;
        go = 1;
		#10
		go = 0;
		
        wait(done)

        #100;
        // $display("Result: %h", r[0+:32]);
        // $display("Result: %b", r[4064+:32]);
        $display("Result r: %h", r);

		#10;
		mode = 1;
        go = 1;
		#10
		go = 0;
        wait(done)

        #100;
        // $display("Result: %h", r[0+:32]);
        // $display("Result: %b", r[4064+:32]);
        $display("Result t: %h", t);

		#10;
        goi = 1;
		#10
		goi = 0;

		wait(valid); // Wait for some time to observe the result
		#10
		$display("Test Case 1 Modulo Inverse = %d", modulo_inv);
			$finish;
		end
 
endmodule 