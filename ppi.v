//`timescale 1ns / 1ps
module chip(PortA,PortB,PortC_upper,PortC_lower,PortD,Vcc,Gnd,Addresslines,CSbar,RDbar,WRbar,RESET
    );
	 //define the pins of the chip
inout wire[7:0] PortA,PortB,PortD;
inout wire[3:0] PortC_upper,PortC_lower;
input Vcc,Gnd,CSbar,RDbar,WRbar,RESET;
input wire[1:0] Addresslines;
//define registers to deal with in an always block
reg[7:0] PortA_REG,PortB_REG,PortD_REG;
reg[3:0] PortC_upper_REG,PortC_lower_REG;
//define some variables to control whether inout pins are read(in) or write(out) ,1 for read and 0 for write 
reg a,b,cu,cl,d; //should they be initialized??
integer select;
reg [7:0] PortD_IO  ; 
//assign the registers to the wires
assign PortA = (a==0)? PortA_REG : 8'bzzzzzzzz;
assign PortB = (b==0)? PortB_REG : 8'bzzzzzzzz;
assign PortC_upper = (cu==0)? PortC_upper_REG : 4'bzzzz;
assign PortC_lower = (cl==0)? PortC_lower_REG : 4'bzzzz;
 // 1st edit  
//reg [7:0]PortC_REG  ; 

///assign PortC_upper = PortC_REG[7:4] ; 
//assign PortC_lower = PortC_REG[3:0] ; 



always @ (PortA,PortB,PortC_upper,PortC_lower,PortD,Vcc,Gnd,Addresslines,CSbar,RDbar,WRbar,RESET)

begin
  if(RESET == 0)
  begin
	   if(Vcc==1&&Gnd==0&&CSbar==0)
	   begin
		     if(Addresslines==2'b00)
		     begin //PortA selected 
			  //mode = 1 ; 
				    if (RDbar==0&&WRbar==1)
				    begin
					 	
				         a=1; //not (i'm sure) sure if this line should be written
				         PortD_REG=PortA;
					  
				    end
					 if (RDbar==1&&WRbar==0)
				    begin
				    a=0;
					 // 2nd edit
					 PortD_REG = PortD ; 
				    PortA_REG=PortD_REG;
				    end
			 end
		
		
		    if(Addresslines==2'b01)
		    begin //PortB selected 
			 //mode = 1 ;
				    if (RDbar==0&&WRbar==1)
				    begin
					  
					 
				    b=1;//not (i'm sure)sure if this line should be written 
				    PortD_REG=PortB;
				    end
					 
					 if (RDbar==1&&WRbar==0)
				    begin
					 b=0 ; 
					 //3rd edit 
					 PortD_REG = PortD ; 
				    PortB_REG=PortD_REG;
				    
				    end
			end
				
				
			if(Addresslines==2'b10)
		   begin //PortC selected 
				    if (RDbar==0&&WRbar==1)
				    begin
					   
				    cu=1;cl=1;//not (i'm sure)sure if this line should be written
					 
				    PortD_REG={PortC_upper,PortC_lower};
				    end
					 
					 if (RDbar==1&&WRbar==0)
				    begin
				    cu=0;cl=0;
					
					 // 4th edit
					 PortD_REG = PortD ;
				    PortC_upper_REG=PortD_REG[7:4];
					 PortC_lower_REG=PortD_REG[3:0];
				    end
			end
		
		   if(Addresslines==2'b11)
		   begin //PortD
				
				
				//check the mode
				    if (PortD[7]==0) //BSR mode
					// mode = 0 ; 
				    begin
				    cu=0;cl=0;
					 				 
				      // if(PortD[3]==0) begin select={PortD[3],PortD[2],PortD[1]}; PortC_lower_REG[select]=PortD[0];end
						 
						 // if(PortD[3]==1) begin select={PortD[3],PortD[2],PortD[1]}; PortC_upper_REG[select]=PortD[0];end
						 				 
				       if(PortD[3]==0) begin select={PortD[3],PortD[2],PortD[1]}; PortC_lower_REG[select]=PortD[0];end
						 if(PortD[3]==1) begin select={PortD[3],PortD[2],PortD[1]}; PortC_upper_REG[select-4]=PortD[0];end
						 
						
						 
						
						 
				    end
					 // 5th edit 
					  if (PortD[7]==1) //I/O mode
				     begin
					  //mode = 1 ; 
				     a=PortD[4];
					  b=PortD[1];
					  cu=PortD[3];
					  cl=PortD[0];
				     end
			end
		
		
		
		
		end
	end
	else //if reset == 1
	begin 
	a=1;b=1;cu=1;cl=1;d=1;
	end
end
endmodule
module IO_bench() ; 

wire [7:0]porta ; 
wire [7:0]portb ; 
wire [7:4]portcup ; 
wire [3:0]portclow ; 
reg [7:0]buff ;
wire [7:0]thebuff ;
  
reg [7:0]portcreg ; 
reg [7:0]portareg;
reg [7:0]portbreg;
reg [2:0] select  ; 
reg [1:0]addr ; 
reg vcc , gnd , csbar , rdbar, wrbar , reset ; 
reg PortAc, PortBc, PortCLc, PortCUc,PortDc;

//assign thebuff = (d)? buff : 8'bzzzzzzzz;
assign thebuff = (PortDc)? buff:8'bzz ;
assign porta = (PortAc)? portareg:8'bzzzz_zzzz ; // 1: input && 0: output
//assign portb = (!PortAc)? portareg:8'bzz ; // 1: input && 0: output
//assign portc = (!PortAc)? portareg:8'bzz ; // 1: input && 0: output
//assign porta = (!PortAc)? portareg:8'bzz ; // 1: input && 0: output



initial 
begin
$monitor($time," rdbar: %b wrbar: %b addressLines: %b buff: %b  port_read: %b",rdbar,wrbar,addr,thebuff ,porta ) ; 
#5
reset = 1 ;
#5
csbar = 0 ; 
reset = 0 ;
addr = 2'b11; 
vcc = 1 ; 
gnd = 0 ; 
rdbar = 1 ; 
wrbar = 0 ; 
PortDc = 1;
buff = 8'b1000_0000 ;

#5 // Write Ouput
csbar = 0 ; 
reset = 0 ;
addr = 2'b00; 
vcc = 1 ; 
gnd = 0 ; 
rdbar = 1 ; 
wrbar = 0 ; 
PortAc = 0;
buff = 8'b1010_1010;
PortDc = 1;

#5 // Read input
csbar = 0 ; 
reset = 0 ;
addr = 2'b00; 
vcc = 1 ; 
gnd = 0 ; 
rdbar = 0 ; 
wrbar = 1 ; 
PortAc = 1;
PortDc = 0;
portareg=8'b1001_0000;

//#5
//PortAc = 1;
//portareg = 8'b1111_1010;  
 //buff=portareg;

 
 
end
chip  a(porta,portb,portcup,portclow,thebuff,vcc,gnd,addr,csbar,rdbar,wrbar,reset
    );

endmodule 