////////////////////////////////////////////////////////////////////////////////
// File:        top.v
// Description: Top level test bench to test RSA 4096bits
// Author:      Aruna Jayasena
// Date:        March 17, 2024
// Version:     1.0
// Revision:    -
// Company:     archfx.github.io
////////////////////////////////////////////////////////////////////////////////

`include "_parameter.v"

module ModExp_tb();
    reg clk;
    reg reset;
    parameter [15:0] width  = 4096;
    reg [(width - 1):0] message, exponent, modulus;
	reg go;
    wire done;
	wire [(width - 1):0] cypher;
    

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


        // message = 4096'd8;
        // exponent =  4096'd13;
        // modulus =  4096'd77;
        // cypher = 0;

        // go = 1;
        // wait (done);
        // $display("cypher value (hex): 0x%h", cypher);

        // #10
        // reset = 1;
        // #10
        // reset = 0;

        // go = 0;


        message = 4096'h32;
        exponent =  4096'd37;
        modulus =  4096'd77;

        // message= 4096'hccd28fa083c6a9af7d9d12e6c549c7ddd95ae4d35417675acace3751f46865130d40b1ee7b3650d7b2ffec5b56bfedd99fd9f7ef0205b3320ea4d3229451505d0ab9f61231ac23b9f674cc019665c00a06b531d5928e70f9c462f897877fae8f8ce367f4ed51abbe11a4b9bfcf64cad9d6979a6d4cd92516b5afae9817190613;
        // exponent= 4096'h00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f3e7af;
        // modulus= 4096'ha674f0f2a01fa0a987d0ef355f36cbd7eda5a931d5eca30b18fc237a481fcea435fe514166db877ca1e645204b0e1e2a8e5f7fcf28a98306c70424f0f4025c7d8c6d89063ac7847bf52eb1f2852bdd5cc03c1cbf63875b5062f4d22b290526a5fecfe343d39c3b46626b63e91670802b4d7a066973474a757d3e5957ddc020afddbeef963643b237651f7bd58d9af4ea67da7de5620539fb904c5a0243388498013470de777c8f11924add97fa1fb11b51cab46ea38adf995ad5efd0958a98cbf022dfb0d4b128917e4b513f120629051307b4d9d1014a28c55c93aaff59f47a7c0472a8b7a1ad5dbf07252c4b2602278fe18a77ec8acb8798f9f8b720dafe03;
        
		


        go = 1;
        wait (done);
		#10
        $display("cypher value (hex): 0x%h", cypher);


        $finish;
    end
    
    always begin
        #5 clk = ~clk;
    end

    
	rsa4k rsa4k0(
		.clk(clk),
		.reset(reset),
		.go(go),  
		.message(message),
		.exponent(exponent),
		.modulus(modulus), 
		.cypher(cypher),
		.done(done)
	);
    
endmodule 