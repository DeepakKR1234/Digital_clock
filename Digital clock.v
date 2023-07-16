timescale lns/lps

module lab_6(input clk, reset_n,
 input io0_down, io1_up, io2_setminute, io4_militiary, io5_stopwatch_enable, io6_stopwatch_run, i07_stopwatch_zero,
 output ad0_L1, ad1_L2, ad3_L4,
 output io8_a, io9_b, io10_c, io11_d, io12_e, ad4_g, ad5_dp);
 
 //clock variables
 reg [5:0] second;
 reg [5:0] minute;
 reg [3:0] minute1;
 reg [3:0] minute2;
 wire am_pm;
 reg [4:0] hour;
 reg [3:0] hour1;
 reg [3:0] hour2;

 assign am_pm = (hour >= 12) ? 1:0;

 // 1 second counter and clock operation

 reg [27:0] sec_count;

 always @(posedge clk)
 begin
    if (!reset_n) 
    begin
        sec_count <=0;
        second <=0;
        hour <=0;
        minute <=0;
    end

    else 
    begin
        sec_count <= sec_count + 1;

        if (sec_count >= 99999999) begin
            second <= second +1;
            sec_count <= 0;
        end
        
        if (second >=60) begin
            second <= 0;
            minute <= minute +1;
        end
        if (minute >= 60) begin
            minute <= 0;
            hour <= hour +1;
        end
        if ( hour >=24) begin
            hour <= 0;
        end
    end


    //setting hour and minute
    if (io2_sethour && (sec_count == 99999999)) begin
        if (io0_down) begin
            if (hour <= 0) hour <=0;
            else hour <= hour - 1;
        end
        else if (io1_up) begin
            hour <= hour + 1;
        end
    end

    else if (io3_setminute && (sec_count == 99999999)) begin
        if(io0_down) begin
            if (minute <= 0) minute <= 0;
            else minute <= minute - 1;
        end
        else if (io1_up) begin
            minute <= minute + 1;
        end
    end


    // clock display
    always @* begin
        // military hour display
        if (io4_militiary) begin
            if (hour < 10)begin
                hour1 <= 0;
                hour2 <= hour;
            end
            else begin
                hour1 <= hour/10;
                hour2 <= hour%10;
            end
        end

        // AM PM display
        else begin
            if (hour <10) 
             begin
                hour1 <= 0;
                hour2 <= hour;
                end
            else if ((hour >= 10) && (hour <= 12)) begin
                 hour1 <= 1;
                 hour2 <= hour % 10;
            end
            else if ((hour > 12) && (hour < 22)) begin
                hour1 <= 0;
                hour2 <= hour2 - 12;
            end
            else begin
                hour1 <= 1;
                hour2 <= (hour - 12) % 10;
            end 
            end
 
   // Minute display
   if (minute < 10) begin
    minute1 <= 0;
    minute2 <= minute;
   end
   else begin
    minute1 <= minute / 10;
    minute2 <= minute % 10;
   end
    end


    // Display variable assignments
    reg [6:0] sw_minute;
    reg [5:0] sw_second;
    reg [3:0] sw_minute1;
    reg [3:0] sw_minute2;
    reg [3:0] sw_second1;
    reg [3:0] sw_second2;

    always @(posedge clk) begin
        if (io5_stopwatch_enable) begin
            if (i07_stopwatch_zero) begin
                sw_minute <= 0;
                sw_second <= 0;
            end
            else if (io6_stopwatch_run && (sec_count == 99999999)) begin
                sw_second <= sw_second + 1;
            end
            if (sw_second >= 60) begin
                sw_second <= 0;
                sw_minute <= sw_minute + 1
                end;
            if (sw_minute >= 100) begin
                sw_minute <= 0;
            end

            //Stopwatch display

            if (sw_minute < 10) begin
                sw_minute1 <= 0;
                sw_minute2 <= sw_minute;
            end
            else begin
                sw_minute1 <= sw_minute / 10;
                sw_minute2 <= sw_minute % 10;
            end
             
            if (sw_second < 10) begin
                sw_second1 <= 0;
                sw_second2 <= sw_second;
            end
            else begin
                sw_second1 <= sw_second / 10;
                sw_second2 <= sw_second % 10;
            end
        end
    end


   // Multiplexing four digits

   reg [17:0] count;

   always @(posedge clk) begin
    count <= count + 1;
   end

   always @* begin

    // Normal Display
    if (!io5_stopwatch_enable) begin
        case (count[17:16])
        2'b00: begin
            out_digit <= hour1;
            led_enable <= 4'b1000;
            dp = 1'b1;
        end
        2'b01: begin
            out_digit <= hour2;
            led_enable <= 4,b0100;
            dp = 1'b0;
        end
        2'b10: begin
            if (sec_count < 50000000) begin
                led_enable <= 4'b0010;
                out_digit <= minute1;
            end
            else begin
                led_enable <= 4'b0000;
            end
            dp 1'b1;
        end
        2'b11: begin
            if (sec_count < 50000000) begin
                led_enable <= 4'b0001;
                out_digit <= minute2;
            end
            else begin
                led_enable <= 4'b0000;
            end
            if (am_pm) dp <= 1'b0;
            else dp <= 1'b1;
        end
        endcase
    end

    //stopwatch display
    else begin
        case (count[17:16])
        2'b00: begin
            out_digit <= sw_minute1;
            led_enable <= 4'b1000;
            dp = 1'b1;
        end
        2'b01: begin
            out_digit <= sw_minute2;
            led_enable <= 4'b0100;
            dp = 1'b0;
        end
        2'b10: begin
            led_enable <= 4'b0010;
            out_digit <= sw_second1;
            dp = 1'b1;
        end
        2'b11: begin
            led_enable <= 4'b0001;
            out_digit <= sw_second2;
            dp <= 1'b1;
        end
        endcase
    end
   end


   /// seven segments
   always @*begin
    case(out_digit)
    4'b0000 : segments = 7'b0000001;
    4'b0001 : segments = 7'b1001111;
    4'b0010 : segments = 7'b0010010;
    4'b0011 : segments = 7'b0000110;
    4'b0100 : segments = 7'b1001100;
    4'b0101 : segments = 7'b0100100;
    4'b0110 : segments = 7'b0100000;
    4'b0111 : segments = 7'b0001111;
    4'b1000 : segments = 7'b0000000;
    4'b1001 : segments = 7'b0000100;
    4'b1010 : segments = 7'b0001000;
    4'b1011 : segments = 7'b1100000;
    4'b1100 : segments = 7'b0110001;
    4'b1101 : segments = 7'b1000010;
    4'b1110 : segments = 7'b0110000;
    4'b1111 : segments = 7'b0111000;
    endcase
   end
endmodule




