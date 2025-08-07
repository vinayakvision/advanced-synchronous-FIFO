module advanced_sync_fifo #( 
    parameter DATA_WIDTH = 32, 
    parameter DEPTH = 256 
) (
    input wire clk,
    input wire rst,
    input wire wr_en,
    input wire rd_en,
    input wire [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out,
    output reg full,
    output reg empty,
    output reg almost_full,
    output reg almost_empty,
    output reg [15:0] fifo_count // Number of elements in FIFO
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    reg [DATA_WIDTH-1:0] fifo_mem [0:DEPTH-1];
    reg [ADDR_WIDTH-1:0] wr_ptr, rd_ptr;

    // Write operation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= 0;
        end else if (wr_en && !full) begin
            fifo_mem[wr_ptr] <= data_in;
            wr_ptr <= wr_ptr + 1;
        end
    end

    // Read operation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rd_ptr <= 0;
            data_out <= 0;
        end else if (rd_en && !empty) begin
            data_out <= fifo_mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
        end
    end

    // Full and Empty Logic (using pointers instead of fifo_count)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            full <= 0;
            empty <= 1;
            almost_full <= 0;
            almost_empty <= 1;
            fifo_count <= 0;
        end else begin
            // Update FIFO Count
            if (wr_en && !rd_en && !full) begin
                fifo_count <= fifo_count + 1;
            end else if (rd_en && !wr_en && !empty) begin
                fifo_count <= fifo_count - 1;
            end

            // Full/Empty Flags
            full <= (fifo_count == DEPTH);
            empty <= (fifo_count == 0);
            almost_full <= (fifo_count >= DEPTH - 4);
            almost_empty <= (fifo_count <= 4);
        end
    end

endmodule
