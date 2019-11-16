module ZionBasicCircuitLib_DatRead_tb;
`Use_ZionBasicCircuitLib(Bc)
  parameter period            = 20,
            WIDTH_TYPE_NUM    = 1,
			WIDTH_ADDR        = 1,
			WIDTH_DATA_IN     = 32,
			WIDTH_DATA_OUT    = 32,
			MULTI_DATA_WIDTH  = 0,
			ADDR_TYPE         = 0;

  logic                        iSignedRd;
  logic [WIDTH_TYPE_NUM-1:0]   iEn;
  logic [WIDTH_ADDR-1:0]       iAddr;
  logic [WIDTH_DATA_IN-1:0]    iDat;
  logic [WIDTH_DATA_OUT-1:0]   oDat; 

  logic   [31:0]readDat;
  logic   [31:0] o;
 parameter int WIDTH_TYPE_NUM1    = 2;
 parameter int WIDTH_ADDR1        = 2;
 parameter int WIDTH_DATA_IN1     = 32;
 parameter int WIDTH_DATA_OUT1    = 32;
 parameter int ADDR_TYPE1         = 1;

  logic                           iSignedRd1;
  logic [WIDTH_TYPE_NUM1-1:0]     iEn1;
  logic [WIDTH_ADDR1-1:0]         iAddr1;
  logic [WIDTH_DATA_IN1-1:0]      iDat1;
  logic [WIDTH_DATA_OUT1-1:0]     oDat1;

  logic  [1:0][15:0]readDat1,datTmp1;
  logic  [3:0][7:0] readDat2,datTmp2;
  logic  [31:0] o1;
  logic  [1:0][31:0] rsltTmp;
  
   parameter  int MULTI_DATA_WIDTH1[2]  = {32'd16,32'd8};

  initial begin
    forever #(period/2) begin
	  iEn       = {$random()}%2'b10;
	  iAddr     = {$random()}%2'b10;
      iDat      = {$random()}%4'b1010;
	  iSignedRd = {$random()}%2'b10;
//	  $display("--->%d",MULTI_DATA_WIDTH1[2]);
	  iEn1      = {$random()}%3'b100;
	  iAddr1    = {$random()}%3'b100;
      iDat1     = {$random()}%32'hffff_ffff;
      iSignedRd1= {$random()}%2'b10;	  
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
  

/*
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
*/


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
         readDat1 = {{16{1'b0}},datTmp1[0]};
        else 
         readDat1 = {datTmp1[1],{16{1'b0}}};
      end else begin 
        if(iAddr1==0)
         readDat1 = {{16{1'b0}},datTmp1[0]};
        else if(iAddr1==1)
         readDat1 = {datTmp1[1],{16{1'b0}}};
		else 
		 readDat1 = '0;
      end
	  
	  if(iEn1[1]==1)
	    datTmp2 = iDat1;
	  else 
        datTmp2 = '0;
      if(MULTI_DATA_WIDTH1[1]==WIDTH_DATA_OUT1) 
        readDat2 = datTmp2;
      else if(ADDR_TYPE1==0) begin
	    if(iAddr1==0)
         readDat2 = {{24{1'b0}},datTmp2[0]};
        else if(iAddr1==1)
         readDat2 = {{16{1'b0}},datTmp2[1],{8{1'b0}}};
	    else if(iAddr1==2)
	     readDat2 = {{8{1'b0}},datTmp2[2],{16{1'b0}}};
	    else if(iAddr1==3)
	     readDat2 = {datTmp2[3],{24{1'b0}}};
      end else if(iAddr1==0)
         readDat2 = {{24{1'b0}},datTmp2[0]};
        else if(iAddr1==1)
         readDat2 = {{16{1'b0}},datTmp2[1],{8{1'b0}}};
	    else if(iAddr1==2)
	     readDat2 = {{8{1'b0}},datTmp2[2],{16{1'b0}}};
	    else if(iAddr1==3)
	     readDat2 = {datTmp2[3],{24{1'b0}}};
	  
	  if(iSignedRd1==1) begin
	    rsltTmp[0] = {{16{readDat1[0][15]}},readDat1[0]} | {{16{readDat1[1][15]}},readDat1[1]};
		rsltTmp[1] = {{24{readDat2[0][7]}},readDat2[0]} | {{24{readDat2[1][7]}},readDat2[1]} | {{24{readDat2[2][7]}},readDat2[2]} | {{24{readDat2[3][7]}},readDat2[3]};
	  end else begin
	    rsltTmp[0] = {{16{1'b0}},readDat1[0]} | {{16{1'b0}},readDat1[1]};
		rsltTmp[1] = {{24{1'b0}},readDat2[0]} | {{24{1'b0}},readDat2[1]} | {{24{1'b0}},readDat2[2]} | {{24{1'b0}},readDat2[3]};
	  end
	  	o1 = rsltTmp[0] | rsltTmp[1];
    end
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
                 iSignedRd,				                //input
                 iEn,iAddr,iDat,                       
		         oDat,                                  //output
		    	 MULTI_DATA_WIDTH,
		     	 ADDR_TYPE
             );

`BcDatRead  ( 
                 U_DatRead1,
                 iSignedRd1,				                 //input
                 iEn1,iAddr1,iDat1,                        
		         oDat1,                                  //output
		    	 MULTI_DATA_WIDTH1,
		     	 ADDR_TYPE1
             );			 		 

`Unuse_ZionBasicCircuitLib(Bc)
endmodule : ZionBasicCircuitLib_DatRead_tb
