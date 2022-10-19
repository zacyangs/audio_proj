module i2s_rx#(
    parameter   DW = 32,
    parameter   TYPE = "I2S"
)(
    input               rst,
    input               lrck,
    input               bclk,
    input               data,

    output reg          valid  = 0,
    output reg [DW-1:0] l_data = 0,
    output reg [DW-1:0] r_data = 0
);

reg [8:0] bcnt;// max 512 fs
wire[8:0] bcnt_x;
wire        valid_x;

reg       lrck_q;
wire      lrck_rise;
wire      lrck_fall;

reg [31:0] l_shift = 0;
reg [31:0] r_shift = 0;


assign bcnt_x = (rst | lrck_rise | lrck_fall)? 9'b0 : bcnt + 1'b1;

always@(posedge bclk)
begin
    if(lrck) //right channel
        r_shift <= {r_shift[30:0], data};
    else
        l_shift <= {l_shift[30:0], data};

    lrck_q <= lrck;
    
    bcnt <= bcnt_x;

    if(lrck_fall)
        r_data <= TYPE == "RJUST" ? r_shift[DW-1:0] :
                  TYPE == "LJUST" ? r_shift[31 -: DW] : r_shift[30 -: DW];

    if(lrck_rise)
        l_data <= TYPE == "RJUST" ? l_shift[DW-1:0] :
                  TYPE == "LJUST" ? l_shift[31 -: DW] : l_shift[30 -: DW];
end

always@(posedge bclk or posedge rst)
begin
    if(rst)
        valid <= 1'b0;
    else if(lrck_rise)
        valid <= 1'b1;
    else
        valid <= 1'b0;
end


assign lrck_rise = lrck & !lrck_q;
assign lrck_fall = !lrck & lrck_q;



endmodule
