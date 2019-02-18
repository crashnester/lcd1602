module lcd_show(clk_LCD, en, RS, RW, data);

input			clk_LCD;    
output		en,RS,RW;
output reg  [3:0] data;
reg			RS;
reg			e;
reg 			clk;
reg      	[3:0] num;
reg 			[3:0] state; 
parameter   clear_lcd_msb			= 4'b0000,
				clear_lcd_lsb			= 4'b0001,
				set_disp_mode_msb		= 4'b0010,
				set_disp_mode_lsb		= 4'b0011,
            disp_on_msb				= 4'b0100,
				disp_on_lsb				= 4'b0101,
				shift_down_msb			= 4'b0110,
            shift_down_lsb			= 4'b0111,
				write_kappa				= 4'b1000,
            idle     				= 4'b1011;
assign RW = 1'b0;                            
assign en = clk | e;

always @(posedge clk_LCD)     
begin 
	counter <= counter + 1; 
	if (counter == 16'h000f)  
		clk <= ~clk; 
end 

always @(posedge clk)
begin
	state <= clear_lcd_msb;
	num <= 4'b0;
	case (state)
	clear_lcd_msb:					//очистка дисплея
		begin
			RS	<= 1'b0;
			data <= 4'b0000;
			state <= clear_lcd_lsb;
		end
	clear_lcd_lsb:					
		begin
			RS	<= 1'b0;
			data <= 4'b0001;
			state <= set_disp_mode_msb;
		end		
	set_disp_mode_msb:				//установка режима отображения: 4-битная 1-строчная матрица 5x8 точек
		begin
			RS	<= 1'b0;
			data <= 4'b0010;
			state <= set_disp_mode_lsb;
		end
	set_disp_mode_lsb:				
		begin
			RS	<= 1'b0;
			data <= 4'b0000;
			state <= disp_on_msb;
		end		
	disp_on_msb:            		//дисплей включен, курсор не отображается, и курсор не может мигать
		begin
			RS	<= 1'b0;
			data <= 4'b0000;
			state  <= disp_on_lsb;                         
		end
	disp_on_lsb:            		
		begin
			RS	<= 1'b0;
			data <= 4'b1100;
			state  <= shift_down_msb;                         
		end
	shift_down_msb:        		//текст не перемещается, курсор автоматически перемещается вправо
		begin
			RS	<= 1'b0;
			data <= 4'b0000;
			state <= shift_down_lsb;                      
      end
	shift_down_lsb:        		
		begin
			RS	<= 1'b0;
			data <= 4'b0110;
			state <= write_kappa;                      
      end
	write_kappa:       		
		begin
		case(num)
		0: 
			begin
				RS	<= 1'b1;
				data  <= 4'b0100;
				num   <= num + 1;
				state <= write_kappa;
			end
		1: 
			begin
				RS	<= 1'b1;
				data  <= 4'b1011;
				num   <= num + 1;
				state <= write_kappa;
			end
		2: 
			begin
				RS	<= 1'b1;
				data  <= 4'b0110;
				num   <= num + 1;
				state <= write_kappa;
			end
		3: 
			begin
				RS	<= 1'b1;
				data  <= 4'b0001;
				num   <= num + 1;
				state <= write_kappa;
			end	
		4: 
			begin
				RS	<= 1'b1;
				data  <= 4'b0111;
				num   <= num + 1;
				state <= write_kappa;
			end
		5: 
			begin
				RS	<= 1'b1;
				data  <= 4'b0000;
				num   <= num + 1;
				state <= write_kappa;
			end	
		6: 
			begin
				RS	<= 1'b1;
				data  <= 4'b0111;
				num   <= num + 1;
				state <= write_kappa;
			end
		7: 
			begin
				RS	<= 1'b1;
				data  <= 4'b0000;
				num   <= num + 1;
				state <= write_kappa;
			end
		8: 
			begin
				RS	<= 1'b1;
				data  <= 4'b0110;
				num   <= num + 1;
				state <= write_kappa;
			end
		9: 
			begin
				RS	<= 1'b1;
				data  <= 4'b0001;
				num   <= num + 1;
				state <= idle;
			end	
		default:
			state <= idle;
		endcase
		end
	idle:           
		begin
			state <= idle;            
		end
   default:  
		state <= clear_lcd_msb;
   endcase
end
endmodule