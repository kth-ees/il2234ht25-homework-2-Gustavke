
`timescale 1ns/1ps
module shift_register_tb;

    parameter N = 4;

    logic clk;
    logic rst_n;

    logic serial_parallel;
    logic load_enable;

    logic serial_in;
    logic [N-1:0] parallel_in;
    logic serial_out;
    logic [N-1:0] parallel_out;

    shift_register #(N) dut (
        .clk(clk),
        .rst_n(rst_n),
        .serial_parallel(serial_parallel),
        .load_enable(load_enable),
        .serial_in(serial_in),
        .parallel_in(parallel_in),
        .parallel_out(parallel_out),
        .serial_out(serial_out)
    );


    // clock generation
    initial begin
        clk = 0;
        forever #1 clk = ~clk; 
    end

    initial begin
        
        // init signals
        rst_n = 0;
        load_enable = 0;
        serial_parallel = 0;
        serial_in = 0;
        parallel_in = 4'b0000;

        

        // release reset
        #2
        rst_n = 1;

        // test parallel load
        #2
        load_enable = 1;
        serial_parallel = 1;
        parallel_in = 4'b1010;
        #2;
        load_enable = 0;
        parallel_in = 4'b0101; // should not change
        
        // test serial shift
        #2
        load_enable = 1;
        serial_parallel = 0;
        serial_in = 1'b0;
        #2;
        serial_in = 1'b1;
        #2;
        serial_in = 1'b0;
        #2;
        serial_in = 1'b1;
        #2;
        load_enable = 0;
        serial_in = 1'b0; // should not change

        // test reset
        #4 
        rst_n = 0;
        #2
        rst_n = 1;
        #4
        $stop;
    end

    

endmodule