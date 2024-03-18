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

	reg [(width - 1):0] cypher_prev;

    

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
		#10


        message = 4096'd8;
        exponent =  4096'd13;
        modulus =  4096'd77;

		// message= 4096'hccd28fa083c6a9af7d9d12e6c549c7ddd95ae4d35417675acace3751f46865130d40b1ee7b3650d7b2ffec5b56bfedd99fd9f7ef0205b3320ea4d3229451505d0ab9f61231ac23b9f674cc019665c00a06b531d5928e70f9c462f897877fae8f8ce367f4ed51abbe11a4b9bfcf64cad9d6979a6d4cd92516b5afae9817190613;
        // exponent= 4096'h00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f3e7af;
        // modulus= 4096'ha674f0f2a01fa0a987d0ef355f36cbd7eda5a931d5eca30b18fc237a481fcea435fe514166db877ca1e645204b0e1e2a8e5f7fcf28a98306c70424f0f4025c7d8c6d89063ac7847bf52eb1f2852bdd5cc03c1cbf63875b5062f4d22b290526a5fecfe343d39c3b46626b63e91670802b4d7a066973474a757d3e5957ddc020afddbeef963643b237651f7bd58d9af4ea67da7de5620539fb904c5a0243388498013470de777c8f11924add97fa1fb11b51cab46ea38adf995ad5efd0958a98cbf022dfb0d4b128917e4b513f120629051307b4d9d1014a28c55c93aaff59f47a7c0472a8b7a1ad5dbf07252c4b2602278fe18a77ec8acb8798f9f8b720dafe03;
        

        go = 1;
		#10
        wait (done);
        $display("cypher value (hex): 0x%h", cypher);
		cypher_prev = cypher;
		go =0;

        #10
        reset = 1;
        #100
        reset = 0;
        #100

        go = 0;
		#10


        // message = 4096'd50;//cypher_prev;
        // exponent =  4096'd37;
        // modulus =  4096'd77;

		message = 4096'd8;
        exponent =  4096'd13;
        modulus =  4096'd77;

        // message = 4096'h6a4a5a9d37dde9648c8e4f1ba3c73a8229755dc01355d9a2c6d61388c016073c0ebac73afc19dbc32d2a20b875ee44009ddfcc910005629453d314f13ac405a3ada039150bd12328286d4e09c4fe5e9e2484f63b033265af9df8ffb631014a2748b2f5d9a4c7b0c0da78d3b430b4b4c1892f32dc7b79ed4390f4a2bacd2bc45d4203b3c704b3ae54d6796053ac23674def1493bbd095d7e35dfdc39a1d169678e4a0d4c8e0df74807f8f48d8a28ec8e5209e16599c52d57883fd9a7e2123df4856029b11f5ae2b0818a7ca93b52ba7539586d092859be981bcca0740a38e81370d44f6c5f61bd6f0961bd4670c084341310b2bba0a0802e9e3ed5f6ce2aa65cc;
        // exponent= 4096'h19f9641ecc4e21405d238542fc633a35a33f3ddc84dfb8dc000c27bdfbb5128c0ae3b561ca615aabf7223824d6415a8a6285ca781683aa76ab9c8542dc02bc50ce60770246fa565a1975f6ce508d3cfc30b24b7eccc02183c5bf6a9b7900d621cb3e97fe57031574ab9e54b0eb2040415262cb7f354e032c39453ac38c51d9f9d98bccde0b866d5bbb4013b84054d55ecf8677a3af7308898ef03d30c796cb020aab69002ac00e820fd0bdb176c20589eee572f8699c27353dea73f7ea9b6c83a55d05f7eec7bb77244f11895ff0f462893ead61d8e51c55eea2ffc5b522c0b86fcde09c785f418570d071ddd39d8c3c3a05d80ef51a081ed3749180b973f24f;
        // modulus= 4096'ha674f0f2a01fa0a987d0ef355f36cbd7eda5a931d5eca30b18fc237a481fcea435fe514166db877ca1e645204b0e1e2a8e5f7fcf28a98306c70424f0f4025c7d8c6d89063ac7847bf52eb1f2852bdd5cc03c1cbf63875b5062f4d22b290526a5fecfe343d39c3b46626b63e91670802b4d7a066973474a757d3e5957ddc020afddbeef963643b237651f7bd58d9af4ea67da7de5620539fb904c5a0243388498013470de777c8f11924add97fa1fb11b51cab46ea38adf995ad5efd0958a98cbf022dfb0d4b128917e4b513f120629051307b4d9d1014a28c55c93aaff59f47a7c0472a8b7a1ad5dbf07252c4b2602278fe18a77ec8acb8798f9f8b720dafe03;
        

        go = 1;
		#10
        wait (done);
		#10
        $display("Decrypted value (hex): 0x%h", cypher);


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