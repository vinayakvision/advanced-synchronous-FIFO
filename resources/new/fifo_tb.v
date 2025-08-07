module tb_advanced_sync_fifo;

    parameter DATA_WIDTH = 32;
    parameter DEPTH = 256;

    reg clk, rst;
    reg wr_en, rd_en;
    reg [DATA_WIDTH-1:0] data_in;
    wire [DATA_WIDTH-1:0] data_out;
    wire full, empty, almost_full, almost_empty;
    wire [15:0] fifo_count;

    // Instantiate FIFO
    advanced_sync_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) uut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty),
        .almost_full(almost_full),
        .almost_empty(almost_empty),
        .fifo_count(fifo_count)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        // Initialize
        clk = 0; rst = 1;
        wr_en = 0; rd_en = 0;
        data_in = 0;
        #20 rst = 0;

        // Write data to FIFO
        repeat (10) begin
            wr_en = 1;
            data_in = $random;
            #10;
        end
        wr_en = 0;

        // Read data from FIFO
        repeat (10) begin
            rd_en = 1;
            #10;
        end
        rd_en = 0;

        // Write to full FIFO and attempt reading
        repeat (DEPTH) begin
            wr_en = 1;
            data_in = $random;
            #10;
        end
        wr_en = 0;

        // Test Read operation after full FIFO
        #20 rd_en = 1;
        repeat (DEPTH) #10;

        // Simulate almost empty state and test read
        wr_en = 1;
        repeat (DEPTH - 10) #10;
        wr_en = 0;
        
        // Check FIFO empty state
        #20 rd_en = 1;
        repeat (10) #10;

        // End simulation
        $stop;
    end
endmodule
