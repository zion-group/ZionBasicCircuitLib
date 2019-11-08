module ZionBasicCircuitLib_DatRead_tb;
`Use_ZionBasicCircuitLib(Bc)
  parameter period            = 20,
            WIDTH_TYPE_NUM    = 1,
			WIDTH_ADDR        = 1,
			WIDTH_DATA_IN     = 32,
			WIDTH_DATA_OUT    = 32,
			MULTI_DATA_WIDTH  = 0,
			ADDR_TYPE         = 0;

  logic [WIDTH_TYPE_NUM-1:0] iEn;
  logic [WIDTH_ADDR-1:0] iAddr;
  logic [WIDTH_DATA_IN-1:0] iDat;
  logic [WIDTH_DATA_OUT-1:0] oDat; 
 
  logic   [31:0]readDat;
  logic   [31:0] o;
 parameter int WIDTH_TYPE_NUM1    = 2;
 parameter int WIDTH_ADDR1        = 2;
 parameter int WIDTH_DATA_IN1     = 32;
 parameter int WIDTH_DATA_OUT1    = 32;
 parameter int ADDR_TYPE1         = 0;

  logic [WIDTH_TYPE_NUM1-1:0] iEn1;
  logic [WIDTH_ADDR1-1:0] iAddr1;
  logic [WIDTH_DATA_IN1-1:0] iDat1;
  logic [WIDTH_DATA_OUT1-1:0] oDat1;

 
  
  logic  [1:0][15:0]readDat1,datTmp1;
  logic  [3:0][7:0] readDat2,datTmp2;
  logic  [31:0] o1;
  logic  [1:0][31:0] rsltTmp;
  
   parameter  int MULTI_DATA_WIDTH1[2]  = {32'd16,32'd8};

  initial begin
    forever #(period/2) begin
	  iEn   = {$random()}%2'b10;
	  iAddr = {$random()}%2'b10;
      iDat  = {$random()}%4'b1010;
//	  $display("--->%d",MULTI_DATA_WIDTH1[2]);
	  iEn1   = {$random()}%3'b100;
	  iAddr1 = {$random()}%3'b100;
      iDat1  = {$random()}%4'b1111;	  
	end  
  end



   always_comb begin
	 if(WIDTH_TYPE_NUM==1) begin
	  if(iEn==1) begin
	    if(iAddr==0) begin
	     readDat = iDat;
         end else begin
	     readDat = 32'h0000_0000;
	   end
	  end else begin
	     readDat = 32'h0000_0000;
	 end
	 o = readDat;
   end  
 end

  
   always_comb begin
	  if(o!=oDat) begin
	   $error("in case of WIDTH_TYPE_NUM=1,oDat fault!");
       $finish;
    end
  end	
  


   always_comb begin
     if(WIDTH_TYPE_NUM1==2) begin
	  if(iEn1[0]==1)
	    datTmp1 = iDat1;
	  else 
        datTmp1 = '0;
      if(MULTI_DATA_WIDTH1[0]==WIDTH_DATA_OUT1) 
        readDat1 = datTmp1;
      else if(ADDR_TYPE1==0) begin
        if(iAddr1[1]==0)
         readDat1 = datTmp1;
        else 
         readDat1 = '0;
      end else begin 
        if(iAddr1==0)
         readDat1 = datTmp1;
        else 
         readDat1 = '0;
      end		 
	  rsltTmp[0]=readDat1;
	  
	  if(iEn1[1]==1)
	    datTmp2 = iDat1;
	  else 
        datTmp2 = '0;
      if(MULTI_DATA_WIDTH1[1]==WIDTH_DATA_OUT1) 
        readDat2 = datTmp2;
      else if(ADDR_TYPE1==0) begin
        if(iAddr1==0)
         readDat2 = datTmp2;
        else 
         readDat2 = '0;
      end else begin 
        if(iAddr1==0)
         readDat2 = datTmp2;
        else 
         readDat2 = '0;
      end      	  
	  rsltTmp[1]=readDat2;
    end
	o1 = rsltTmp[0] | rsltTmp[1];
   end	  

  initial begin
    forever #(period/2) begin
	  if(o1!=oDat1) begin
	   $error("in case of WIDTH_TYPE_NUM=2,oDat fault!");
       $finish;
    end
   end
  end  
  
  initial begin
    $fsdbDumpfile("tb.fsdb");
    $fsdbDumpvars(0,ZionBasicCircuitLib_DatRead_tb,"+all");
    #1000 $finish;
  end 

`BcDatRead  ( 
                 U_DatRead, 
                 iEn,iAddr,iDat,                        //input
		         oDat,                                  //output
		    	 MULTI_DATA_WIDTH,
		     	 ADDR_TYPE
             );

`BcDatRead  ( 
                 U_DatRead1, 
                 iEn1,iAddr1,iDat1,                        //input
		         oDat1,                                  //output
		    	 MULTI_DATA_WIDTH1,
		     	 ADDR_TYPE1
             );			 		 

`Unuse_ZionBasicCircuitLib(Bc)
endmodule : ZionBasicCircuitLib_DatRead_tb
