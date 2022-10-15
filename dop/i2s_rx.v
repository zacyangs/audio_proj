module i2s_rx#(
    parameter   DW = 32,
    parameter   TYPE = "I2S"
)(
    input               rst,
    input               lrck,
    input               bclk,
    input               data,

    output reg          valid = 0,
    output reg [DW-1:0] l_data = 0,
    output reg [DW-1:0] r_data = 0
);

reg [8:0] bcnt;// max 512 fs
wire[8:0] bcnt_x;

reg       lrck_q;
wire      lrck_rise;
wire      lrck_fall;

reg [DW-1:0] l_shift = 0;
reg [DW-1:0] r_shift = 0;


assign bcnt_x = (rst | lrck_rise | lrck_fall)? 9'b0 : bcnt + 1'b1;

always@(posedge bclk or posedge rst)
begin
    if(lrck) //right channel
        r_shift <= {r_shift[DW-2:0], data};
    else
        l_shift <= {l_shift[DW-2:0], data};

    lrck_q <= lrck;
    
    bcnt <= bcnt_x;

    if(lrck_rise && TYPE == "RJUST" ||
       (bcnt == (DW) && TYPE == "I2S" ||
       bcnt == (DW-1) && TYPE == "LJUST") && !lrck)
        l_data <= l_shift;

    if(lrck_fall && TYPE == "RJUST" ||
       (bcnt == (DW) && TYPE == "I2S" ||
       bcnt == (DW-1) && TYPE == "LJUST") && lrck) begin
        r_data <= r_shift;
        valid <= 1;
    end
    else
        valid <= 1'b0;

end

assign lrck_rise = lrck & !lrck_q;
assign lrck_fall = !lrck & lrck_q;



endmodule
