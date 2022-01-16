module dcache_sram
(
    clk_i,
    rst_i,
    addr_i,
    tag_i,
    data_i,
    enable_i,
    write_i,
    tag_o,
    data_o,
    hit_o
);

// I/O Interface from/to controller
input              clk_i;
input              rst_i;
input    [3:0]     addr_i;
input    [24:0]    tag_i;
input    [255:0]   data_i;
input              enable_i;
input              write_i;

output   [24:0]    tag_o;
output   [255:0]   data_o;
output             hit_o;


// Memory
reg      [24:0]    tag [0:15][0:1];    
reg      [255:0]   data[0:15][0:1];

wire               hit_0;
wire               hit_1;
reg                lru[0:15];

integer            i, j;


// Write Data      
// 1. Write hit
// 2. Read miss: Read from memory
always@(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        for (i=0;i<16;i=i+1) begin
            lru[i] <= 1'b0;
            for (j=0;j<2;j=j+1) begin
                tag[i][j] <= 25'b0;
                data[i][j] <= 256'b0;
            end
        end
    end
    if (enable_i) begin
        // TODO: Handle your write of 2-way associative cache + LRU here
        if (write_i) begin
            if (hit_0) begin
                tag[addr_i][0] <= tag_i;
                data[addr_i][0] <= data_i;
                lru[addr_i] <= 1'b1;
            end
            else if (hit_1) begin
                tag[addr_i][1] <= tag_i;
                data[addr_i][1] <= data_i;
                lru[addr_i] <= 1'b0;
            end
            else begin
                tag[addr_i][lru[addr_i]] <= tag_i;
                data[addr_i][lru[addr_i]] <= data_i;
                lru[addr_i] <= !lru[addr_i];
            end
        end
        else begin
            if (hit_0) begin
                lru[addr_i] = 1'b1;
            end
            if (hit_1) begin
                lru[addr_i] = 1'b0;
            end
        end
    end
end

// Read Data      
// TODO: tag_o=? data_o=? hit_o=?
assign hit_0 = (tag[addr_i][0][24] && tag[addr_i][0][22:0] == tag_i[22:0]);
assign hit_1 = (tag[addr_i][1][24] && tag[addr_i][1][22:0] == tag_i[22:0]);
assign hit_o = (hit_0) || (hit_1);

assign tag_o =
    (hit_0) ? tag[addr_i][0] :
    (hit_1) ? tag[addr_i][1] :
    tag[addr_i][lru[addr_i]];
assign data_o =
    (hit_0) ? data[addr_i][0] :
    (hit_1) ? data[addr_i][1] :
    data[addr_i][lru[addr_i]];

endmodule
