--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:22:55 07/03/2015
-- Design Name:   
-- Module Name:   C:/FPGA/Internship Jobs/Codes/ETSE_GDSP/Matrix_for_RBM/TB_MEMARRAY_V3.vhd
-- Project Name:  BRAM_build
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MEMARRAY_V3
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use STD.textio.all;
use ieee.std_logic_textio.all; 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
use STD.textio.all;
use work.txt_util.all;
use work.MATRIX_MUL_IP_CORE_LIBRARY.all;
 
ENTITY TB_MATRIX_MUL_IP_CORE_S_INT IS
generic(
		COLUMN_TOTAL: integer:=4;
      ADDR_WIDTH: integer:=10;
      DATA_WIDTH:integer:=18;
		DATA_WIDE_WIDTH: integer:=48;
		OPCODE_WIDTH: integer:=3
   );

END TB_MATRIX_MUL_IP_CORE_S_INT;
 
ARCHITECTURE behavior OF TB_MATRIX_MUL_IP_CORE_S_INT IS    

---------------------------------------------------General Signals----------------------------------------------

	--Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal Mul_DIN: std_logic_vector(DATA_WIDTH-1 downto 0);

   -- Clock period definitions
   constant  CLK_period : time := 10 ns;
   
   -- Control Signals----
   signal DATA_INPUT: std_logic:='0';
   signal GREAD_DONE: std_logic :='0';   
   type COMMAND is (cmd_G_READ_START,cmd_P_READ_START,cmd_Unload_BRAM_Content,cmd_PG,cmd_PGt,cmd_PtG,cmd_PtGt,cmd_PpG,cmd_PpGt,cmd_PtpG,cmd_PtpGt,cmd_PmG,cmd_PmGt,cmd_PtmG,cmd_PtmGt,cmd_GmP,cmd_GmPt,cmd_GtmP,cmd_GtmPt,cmd_PdG,cmd_PdGt,cmd_PtdG,cmd_PtdGt,cmd_VP,cmd_VPt,cmd_PV,cmd_PtV,cmd_SP,cmd_SPt,cmd_dummy);
	signal CMD: COMMAND;
   signal r_loop_count : std_logic_vector(2 downto 0) := (others => '0');
   
	signal MSG: string(1 to 40);
   shared variable sv_line: line;
   shared variable sv_Result_File_Open: boolean;
   file Result_file_pointer: Text; 
	
-------------------------------------------------End of General Signals------------------------------------------
	
---------------------------------------------------MEMARRY_V3 Signals--------------------------------------------   
	
	--Inputs
--   signal Ctrl_BRAM : STD_LOGIC:='0';
--   signal P_SHFT_IN : STD_LOGIC:='0';
--   signal ADDRB : std_logic_vector(ADDR_WIDTH-1 downto 0) := std_logic_vector(to_unsigned(3,10));--(others => '0');
   signal OE : std_logic := '0';
   signal SSEN : std_logic := '0';
   
   signal LOAD : std_logic := '1';
   signal P : std_logic := '0';
   signal G : std_logic := '0';
	signal mode : std_logic_vector(2 downto 0) := "000";
   signal DIN : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
	signal UN_LOAD : STD_LOGIC;
 	--Outputs
   signal DOUT : std_logic_vector(DATA_WIDTH-1 downto 0);
		

	
   signal f_gROW : std_logic_vector(ADDR_WIDTH-1 downto 0);
   signal f_gCOL : std_logic_vector(ADDR_WIDTH-1 downto 0);
   signal READY : std_logic;
   signal OP_DONE : std_logic;
   signal LOADING_DONE : std_logic;   
	signal UN_LOADING_DONE : std_logic;
	signal delay_latency: integer:=0;
	signal WE :std_logic;
   signal CSEL			: std_logic_vector(COLUMN_TOTAL-1 downto 0);
 	signal OPCODE       :  STD_LOGIC_VECTOR(OPCODE_WIDTH - 1 downto 0);
	signal CONTROL_A_INPUT_OF_DSP:  std_logic;
   signal Write_ADDR	: STD_LOGIC_VECTOR(ADDR_WIDTH - 2 downto 0);
   signal Read_ADDR	:  STD_LOGIC_VECTOR(ADDR_WIDTH - 2 downto 0);

-------------------------------------------------End of MEMARRY_V3 Signals---------------------------------------

--------------------------------------------------------GRAM Signals--------------------------------------------- 

   signal gROW : STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);
   signal gCOL : STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);
   signal gDIN : STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
   signal gDOUT : STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
   signal gWE : STD_LOGIC;
   signal f_gOE : STD_LOGIC;
   
	signal MUL_GCOL : std_logic_vector(ADDR_WIDTH-1 downto 0);
	signal MUL_GROW : std_logic_vector(ADDR_WIDTH-1 downto 0);	
	signal Bank_sel_in : STD_LOGIC:='0';
 	   
----------------------------------------------------End of GRAM Signals ------------------------------------------

---------------------------------------------------------Procedures-----------------------------------------------
procedure PrintResultToConsole is
file  Result_file_pointer: Text;
variable line_num: line;
begin
			file_open(Result_file_pointer,"../../TestingFiles/MATRIX_MUL_IP_CORE_S_INT.txt",READ_MODE);
			while not endfile(Result_file_pointer) loop
			Readline(Result_file_pointer,line_num);
			--wait for clk_period;
			Writeline(output,line_num);
			end loop;
			file_close(Result_file_pointer);
end;

procedure PrintResultInCSVFormat is
variable line_num, line_num2: line;
variable v_IsTheValueReadGood: boolean:=true;
variable v_Value: string(1 to 10);
file Result_file_pointer, Result_file_pointer2: Text; 
variable line_num_cnt: integer:=0;
begin

         file_open(Result_file_pointer2,"../../TestingFiles/MATRIX_MUL_IP_CORE_S_INT_CSV.txt",WRITE_MODE);
			file_open(Result_file_pointer,"../../TestingFiles/MATRIX_MUL_IP_CORE_S_INT.txt",READ_MODE);
   		--file_open(CMD_SEQ,"../../TestingFiles/CMD_Sequencies.txt",READ_MODE);

			line_num_cnt := 0;
			
			while not endfile(Result_file_pointer) loop
				ReadLine(Result_file_pointer,line_num);
				if line_num_cnt > 0 and line_num_cnt <= COLUMN_TOTAL then
					--ReadLine(Result_file_pointer,line_num); --procedure read(l : inout line; value : out string; good : out boolean);				
					while v_IsTheValueReadGood = true loop
						str_read_remove_spaces(line_num,v_Value,v_IsTheValueReadGood);
					if v_IsTheValueReadGood = true then
						for i in 1 to string_valid_length(v_Value) loop
							write(line_num2, v_Value(i));
						end loop;
						write(line_num2, ',');
					end if;
					end loop;
					Writeline(Result_file_pointer2,line_num2);
					v_IsTheValueReadGood := true;
				end if;
				line_num_cnt := line_num_cnt + 1;
				if line_num_cnt = (COLUMN_TOTAL + 4) then
					line_num_cnt := 1;
				end if;
			end loop;
			file_close(Result_file_pointer2);
			file_close(Result_file_pointer);
end;
------------------------------------------------------End of Procedures-------------------------------------------

type t_BRAM_DATA is array (0 to COLUMN_TOTAL-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
signal BRAM_DATA : t_BRAM_DATA;

 
BEGIN
	
	
Mul_DIN	 <= DIN when DATA_INPUT = '0' else gDOUT;


process(cmd, f_gCOL, f_gROW, gCOL, gROW)
begin
	if cmd = cmd_G_READ_START then
		MUL_GCOL <= gCOL;
		MUL_GROW <= gROW;
  	else 
  		MUL_GCOL <=	f_gCOL;
  		MUL_GROW <= f_gROW;
  	end if;
end process;

   uut: entity work.MATRIX_MUL_IP_CORE_S_INT 
generic map(
	COLUMN_TOTAL => COLUMN_TOTAL,
	OPCODE_WIDTH => OPCODE_WIDTH,
    ADDR_WIDTH => ADDR_WIDTH,
    DATA_WIDTH => DATA_WIDTH,
	DATA_WIDE_WIDTH => DATA_WIDE_WIDTH
   )
	PORT MAP (
          CLK => CLK,
          RST => RST,
          LOAD => LOAD,
          UN_LOAD => UN_LOAD,
          P => P,
          G => G,
          mode => mode,
          Bank_sel_in => Bank_sel_in,
          DIN => Mul_DIN,
          DOUT => DOUT,         
          G_ROW => f_gROW,
          G_COLUMN => f_gCOL,

          G_O_EN => f_gOE,
          READY		=> READY,
          OP_DONE => OP_DONE,
          LOADING_DONE => LOADING_DONE,
          UN_LOADING_DONE => UN_LOADING_DONE,
			 WE=>WE,
			 CSEL=>CSEL,
          OPCODE=>OPCODE,
			 Write_ADDR=>Write_ADDR,
			 Read_ADDR=>Read_ADDR,
          CONTROL_A_INPUT_OF_DSP=>CONTROL_A_INPUT_OF_DSP

        );
		  
GRAM:	entity work.STANDARD_RAM
generic map(
		COLUMN_TOTAL => COLUMN_TOTAL,		-- num columns in ram
      ADDR_WIDTH => ADDR_WIDTH,		-- log2 of rows
      DATA_WIDTH => DATA_WIDTH			--
   )
    Port map ( CLK 	=> CLK ,
           ROW 		=> Mul_gROW,
           COL 		=> Mul_gCOL,
           DIN 		=> gDIN,
           DOUT 	=> gDOUT,
           WE 		=> gWE,
           OE 		=> f_gOE
           );

 
    -- Clock process definitions
CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
	end process;
--
operation_seq :process	

variable line_num, line_num2: line;
variable v_IsTheValueReadGood: boolean:=true;
variable v_Value: string(1 to 10);
file Result_file_pointer, Result_file_pointer2: Text; 
variable line_num_cnt: integer:=0;
variable c:         character;
variable is_string: boolean;
--(cmd_G_READ_START,cmd_P_READ_START,cmd_Unload_BRAM_Content,cmd_PG,cmd_PGt,cmd_PtG,cmd_PtGt);
variable v_delay_latency: integer;
variable loop_count: integer:=0;




variable Ptrans,Gtrans: std_logic;
variable Oper: std_logic_vector(3 downto 0);
variable P_source: std_logic;
variable v_space,v_space1,v_space2 : character;
variable line_num3: line;
file Result_file_pointer3: Text; 

  begin
          	   CMD <= cmd_G_READ_START;
	            wait until GREAD_DONE<='1';	
	            CMD <= cmd_P_READ_START;	
	            wait until LOADING_DONE ='1';	
					v_delay_latency := g_cnt_delay_ready; --get the time at which the operation completed
					sv_Result_File_Open := false;
					Bank_sel_in <= '1'; -- Tell BRAM to Read from upper Bank. Note MSB of ADDR Port B is Banksel and it is inverted.
					CMD <= cmd_Unload_BRAM_Content;
					write(sv_line,"---------------" & " Data loaded into BRAM. " & str(v_delay_latency) & " clock cycles to load,");
					wait until UN_LOADING_DONE = '1';
 
file_open(Result_file_pointer3,"../../TestingFiles/CMD.txt",READ_MODE); 

--         	   CMD <= cmd_G_READ_START;
--	            wait until GREAD_DONE<='1';	
--	            CMD <= cmd_P_READ_START;	
--	            wait until LOADING_DONE ='1';	
--					v_delay_latency := g_cnt_delay_ready; --get the time at which the operation completed
--					sv_Result_File_Open := false;
--					Bank_sel_in <= '1'; -- Tell BRAM to Read from upper Bank. Note MSB of ADDR Port B is Banksel and it is inverted.
--					CMD <= cmd_Unload_BRAM_Content;
--					write(sv_line,"---------------" & " Data loaded into BRAM. " & str(v_delay_latency) & " clock cycles to load,");
--					wait until UN_LOADING_DONE = '1';
while not endfile(Result_file_pointer3) loop
				Readline(Result_file_pointer3,line_num3);
				read(line_num3,P_source);
				read(line_num3,v_space);
				read(line_num3,Ptrans);
				read(line_num3,v_space2);
				read(line_num3,Gtrans);
				read(line_num3,v_space1);
				read(line_num3,oper);
				loop_count:=loop_count+1;
            r_loop_count<=std_logic_vector(to_unsigned(loop_count,3));

			if oper="0000" then
				  if P_source='0' then
					   Bank_sel_in <= '0'; -- Tell BRAM to Write data to upper Bank.
					else
					   Bank_sel_in <= '1'; -- Tell BRAM to Write data to upper Bank.
					end if;					   
           	   CMD <= cmd_dummy; -- fake command. This was necessary because the simulator will not respond unless this fake command is used to create an event. I guess it is a bug.
           	   wait for clk_period;
	            CMD <= cmd_P_READ_START;	
	            wait until LOADING_DONE ='1';	
					v_delay_latency := g_cnt_delay_ready; --get the time at which the operation completed
					sv_Result_File_Open := true;
				   if P_source='0' then
					   Bank_sel_in <= '1'; -- Tell BRAM to Write data to upper Bank.
					else
					   Bank_sel_in <= '0'; -- Tell BRAM to Write data to upper Bank.
					end if;					   

					CMD <= cmd_Unload_BRAM_Content;
					write(sv_line,"---------------" & " Data loaded into BRAM. " & str(v_delay_latency) & " clock cycles to load,");
					wait until UN_LOADING_DONE = '1';
		  else
			   if P_source='1' then
				   Bank_sel_in <= '0'; -- Tell BRAM to save result in lower bank.
				else
				   Bank_sel_in <= '1'; -- Tell BRAM to save result in upper bank.
				end if;

				 if Ptrans='0' and Gtrans='0' and oper="0001" then
           	      CMD <= cmd_dummy; -- fake command. This was necessary because the simulator will not respond unless this fake command is used to create an event. I guess it is a bug.
           	      wait for clk_period;
	               CMD <= cmd_PG; --Real Command	
				elsif Ptrans='0' and Gtrans='1' and oper="0001" then
           	      CMD <= cmd_dummy; -- fake command. This was necessary because the simulator will not respond unless this fake command is used to create an event. I guess it is a bug.
           	      wait for clk_period;
				      CMD <= cmd_PGt; --Real Command
						
            elsif	Ptrans='1' and Gtrans='0' and oper="0001" then					
           	      CMD <= cmd_dummy; -- fake command. This was necessary because the simulator will not respond unless this fake command is used to create an event. I guess it is a bug.
           	      wait for clk_period;
				       CMD <= cmd_PtG; --Real Command
            elsif	Ptrans='1' and Gtrans='1' and oper="0001" then					
           	      CMD <= cmd_dummy; -- fake command. This was necessary because the simulator will not respond unless this fake command is used to create an event. I guess it is a bug.
           	      wait for clk_period;
				       CMD <= cmd_PtGt; --Real Command
            elsif	Ptrans='0' and Gtrans='0' and oper="0010" then					
           	      CMD <= cmd_dummy; -- fake command. This was necessary because the simulator will not respond unless this fake command is used to create an event. I guess it is a bug.
           	      wait for clk_period;
				       CMD <= cmd_PpG; --Real Command				
            elsif	Ptrans='0' and Gtrans='1' and oper="0010" then					
           	      CMD <= cmd_dummy; -- fake command. This was necessary because the simulator will not respond unless this fake command is used to create an event. I guess it is a bug.
           	      wait for clk_period;
				       CMD <= cmd_PpGt; --Real Command						 
            elsif	Ptrans='1' and Gtrans='0' and oper="0010" then					
           	      CMD <= cmd_dummy; -- fake command. This was necessary because the simulator will not respond unless this fake command is used to create an event. I guess it is a bug.
           	      wait for clk_period;
				      CMD <= cmd_PtpG; --Real Command
            elsif	Ptrans='1' and Gtrans='1' and oper="0010" then					
           	      CMD <= cmd_dummy; -- fake command. This was necessary because the simulator will not respond unless this fake command is used to create an event. I guess it is a bug.
           	      wait for clk_period;
				       CMD <= cmd_PtpGt; --Real Command
            elsif	Ptrans='0' and Gtrans='0' and oper="0011" then					
           	      CMD <= cmd_dummy; -- fake command. This was necessary because the simulator will not respond unless this fake command is used to create an event. I guess it is a bug.
           	      wait for clk_period;
				       CMD <= cmd_PmG; --Real Command
            elsif	Ptrans='0' and Gtrans='1' and oper="0011" then					
           	      CMD <= cmd_dummy; -- fake command. This was necessary because the simulator will not respond unless this fake command is used to create an event. I guess it is a bug.
           	      wait for clk_period;
				       CMD <= cmd_PmGt; --Real Command
            elsif	Ptrans='1' and Gtrans='0' and oper="0011" then					
           	      CMD <= cmd_dummy; -- fake command. This was necessary because the simulator will not respond unless this fake command is used to create an event. I guess it is a bug.
           	      wait for clk_period;
				       CMD <= cmd_PtmG; --Real Command
            elsif	Ptrans='1' and Gtrans='1' and oper="0011" then					
           	      CMD <= cmd_dummy; -- fake command. This was necessary because the simulator will not respond unless this fake command is used to create an event. I guess it is a bug.
           	      wait for clk_period;
				       CMD <= cmd_PtmGt; --Real Command
            elsif	Ptrans='0' and Gtrans='0' and oper="0100" then					
           	      CMD <= cmd_dummy; -- fake command. This was necessary because the simulator will not respond unless this fake command is used to create an event. I guess it is a bug.
           	      wait for clk_period;
				       CMD <= cmd_GmP; --Real Command
            elsif	Ptrans='0' and Gtrans='1' and oper="0100" then					
           	      CMD <= cmd_dummy; -- fake command. This was necessary because the simulator will not respond unless this fake command is used to create an event. I guess it is a bug.
           	      wait for clk_period;
				       CMD <= cmd_GtmP; --Real Command
            elsif	Ptrans='1' and Gtrans='0' and oper="0100" then					
           	      CMD <= cmd_dummy; -- fake command. This was necessary because the simulator will not respond unless this fake command is used to create an event. I guess it is a bug.
           	      wait for clk_period;
				       CMD <= cmd_GmPt; --Real Command
            elsif	Ptrans='1' and Gtrans='1' and oper="0100" then					
           	      CMD <= cmd_dummy; -- fake command. This was necessary because the simulator will not respond unless this fake command is used to create an event. I guess it is a bug.
           	      wait for clk_period;
				       CMD <= cmd_GtmPt; --Real Command
            elsif	Ptrans='0' and Gtrans='0' and oper="0101" then					
           	      CMD <= cmd_dummy; -- fake command. This was necessary because the simulator will not respond unless this fake command is used to create an event. I guess it is a bug.
           	      wait for clk_period;
				       CMD <= cmd_PdG; --Real Command
            elsif	Ptrans='0' and Gtrans='1' and oper="0101" then					
           	      CMD <= cmd_dummy; -- fake command. This was necessary because the simulator will not respond unless this fake command is used to create an event. I guess it is a bug.
           	      wait for clk_period;
				       CMD <= cmd_PdGt; --Real Command
            elsif	 Ptrans='1' and Gtrans='0' and oper="0101" then					
           	      CMD <= cmd_dummy; -- fake command. This was necessary because the simulator will not respond unless this fake command is used to create an event. I guess it is a bug.
           	      wait for clk_period;
				       CMD <= cmd_PtdG; --Real Command
            elsif	 Ptrans='1' and Gtrans='1' and oper="0101" then					
           	      CMD <= cmd_dummy; -- fake command. This was necessary because the simulator will not respond unless this fake command is used to create an event. I guess it is a bug.
           	      wait for clk_period;
				       CMD <= cmd_PtdGt; --Real Command
            elsif	 Ptrans='0' and Gtrans='0' and oper="0110" then					
           	      CMD <= cmd_dummy; -- fake command. This was necessary because the simulator will not respond unless this fake command is used to create an event. I guess it is a bug.
           	      wait for clk_period;
				      CMD <= cmd_VP; --Real Command	
            elsif	 Ptrans='0' and Gtrans='1' and oper="0110" then					
           	      CMD <= cmd_dummy; -- fake command. This was necessary because the simulator will not respond unless this fake command is used to create an event. I guess it is a bug.
           	      wait for clk_period;
				      CMD <= cmd_VPt; --Real Command	
            elsif	 Ptrans='0' and Gtrans='0' and oper="0111" then					
           	      CMD <= cmd_dummy; -- fake command. This was necessary because the simulator will not respond unless this fake command is used to create an event. I guess it is a bug.
           	      wait for clk_period;
				      CMD <= cmd_PV; --Real Command		 
            elsif	 Ptrans='0' and Gtrans='1' and oper="0111" then					
           	      CMD <= cmd_dummy; -- fake command. This was necessary because the simulator will not respond unless this fake command is used to create an event. I guess it is a bug.
           	      wait for clk_period;
				      CMD <= cmd_PtV; --Real Command		 
            elsif	 Ptrans='0' and Gtrans='0' and oper="1000" then					
           	      CMD <= cmd_dummy; -- fake command. This was necessary because the simulator will not respond unless this fake command is used to create an event. I guess it is a bug.
           	      wait for clk_period;
				      CMD <= cmd_SP; --Real Command		 
            elsif	 Ptrans='0' and Gtrans='1' and oper="1000" then					
           	      CMD <= cmd_dummy; -- fake command. This was necessary because the simulator will not respond unless this fake command is used to create an event. I guess it is a bug.
           	      wait for clk_period;
				      CMD <= cmd_SPt; --Real Command		 					
				else
           	      CMD <= cmd_dummy; -- fake command. This was necessary because the simulator will not respond unless this fake command is used to create an event. I guess it is a bug.
           	      wait for clk_period;				
				end if;

	         wait until OP_DONE= '1';
            v_delay_latency := g_cnt_delay_ready;--get the time at which the operation completed	
   	      sv_Result_File_Open := true;
            CMD <= cmd_Unload_BRAM_Content;	
            if P_source='1' then
				   Bank_sel_in <= '1'; -- Tell BRAM to Read from lower Bank. Note MSB of ADDR Port B is Banksel and it is inverted.
				else
				   Bank_sel_in <= '0'; -- Tell BRAM to Read from lower Bank. Note MSB of ADDR Port B is Banksel and it is inverted.
				end if;
 --           write(sv_line,"---------------" & " result of P * G from upper bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish multiplication, ");


        if P_source='1' then
  				if Ptrans='0' and Gtrans='0' and oper="0001" then
                 write(sv_line,"---------------" & " result of R * G from lower bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish multiplication, ");
				elsif Ptrans='0' and Gtrans='1' and oper="0001" then
                 write(sv_line,"---------------" & " result of R * Gt from lower bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish multiplication, ");
            elsif	Ptrans='1' and Gtrans='0' and oper="0001" then					
                 write(sv_line,"---------------" & " result of Rt * G from lower bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish multiplication, ");
            elsif	Ptrans='1' and Gtrans='1' and oper="0001" then					
                 write(sv_line,"---------------" & " result of Rt * Gt from lower bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish multiplication, ");
            elsif	Ptrans='0' and Gtrans='0' and oper="0010" then					
                 write(sv_line,"---------------" & " result of R + G from lower bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish addition, ");
            elsif	Ptrans='0' and Gtrans='1' and oper="0010" then					
                 write(sv_line,"---------------" & " result of R + Gt from lower bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish addition, ");
            elsif	Ptrans='1' and Gtrans='0' and oper="0010" then					
                 write(sv_line,"---------------" & " result of Rt + G from lower bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish addition, ");
            elsif	Ptrans='1' and Gtrans='1' and oper="0010" then					
                 write(sv_line,"---------------" & " result of Rt + Gt from lower bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish addition, ");
            elsif	Ptrans='0' and Gtrans='0' and oper="0011" then					
                 write(sv_line,"---------------" & " result of R - G from lower bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish subtraction, ");
            elsif	Ptrans='0' and Gtrans='1' and oper="0011" then					
                 write(sv_line,"---------------" & " result of R - Gt from lower bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish subtraction, ");
            elsif	Ptrans='1' and Gtrans='0' and oper="0011" then					
                 write(sv_line,"---------------" & " result of Rt - G from lower bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish subtraction, ");
            elsif	Ptrans='1' and Gtrans='1' and oper="0011" then					
                  write(sv_line,"---------------" & " result of Rt - Gt from lower bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish subtraction, ");
            elsif	Ptrans='0' and Gtrans='0' and oper="0100" then					
                 write(sv_line,"---------------" & " result of G-R from lower bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish subtraction, ");
            elsif	Ptrans='0' and Gtrans='1' and oper="0100" then					
                 write(sv_line,"---------------" & " result of Gt-R from lower bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish subtraction, ");
            elsif	Ptrans='1' and Gtrans='0' and oper="0100" then					
                 write(sv_line,"---------------" & " result of G-Rt from lower bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish subtraction, ");
            elsif	Ptrans='1' and Gtrans='1' and oper="0100" then					
                 write(sv_line,"---------------" & " result of Gt-Rt from lower bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish subtraction, ");
            elsif	Ptrans='0' and Gtrans='0' and oper="0101" then					
                 write(sv_line,"---------------" & " result of R.G from lower bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish dot multiplication, ");
            elsif	Ptrans='0' and Gtrans='1' and oper="0101" then					
                 write(sv_line,"---------------" & " result of R.Gt from lower bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish dot multiplication, ");
            elsif	 Ptrans='1' and Gtrans='0' and oper="0101" then					
                 write(sv_line,"---------------" & " result of Rt.G from lower bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish dot multiplication, ");
            elsif Ptrans='1' and Gtrans='1' and oper="0101" then					
                 write(sv_line,"---------------" & " result of Rt.Gt from lower bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish dot multiplication, ");
            elsif Ptrans='0' and Gtrans='0' and oper="0110" then					
                 write(sv_line,"---------------" & " result of V*R from lower bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish dot multiplication, ");
            elsif Ptrans='0' and Gtrans='1' and oper="0110" then					
                 write(sv_line,"---------------" & " result of V*Rt from lower bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish dot multiplication, ");
            elsif Ptrans='0' and Gtrans='0' and oper="0111" then					
                 write(sv_line,"---------------" & " result of R*V from lower bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish dot multiplication, ");
            elsif Ptrans='0' and Gtrans='1' and oper="0111" then					
                 write(sv_line,"---------------" & " result of Rt*V from lower bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish dot multiplication, ");
            elsif Ptrans='0' and Gtrans='0' and oper="1000" then					
                 write(sv_line,"---------------" & " result of S.R from lower bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish dot multiplication, ");
           elsif Ptrans='0' and Gtrans='0' and oper="1000" then					
                 write(sv_line,"---------------" & " result of S.Rt from lower bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish dot multiplication, ");
				end if;

	     else
				if Ptrans='0' and Gtrans='0' and oper="0001" then
                 write(sv_line,"---------------" & " result of P * G from upper bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish multiplication, ");
				elsif Ptrans='0' and Gtrans='1' and oper="0001" then
                 write(sv_line,"---------------" & " result of P * Gt from upper bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish multiplication, ");
            elsif	Ptrans='1' and Gtrans='0' and oper="0001" then					
                 write(sv_line,"---------------" & " result of Pt * G from upper bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish multiplication, ");
            elsif	Ptrans='1' and Gtrans='1' and oper="0001" then					
                 write(sv_line,"---------------" & " result of Pt * Gt from upper bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish multiplication, ");
            elsif	Ptrans='0' and Gtrans='0' and oper="0010" then					
                 write(sv_line,"---------------" & " result of P + G from upper bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish addition, ");
            elsif	Ptrans='0' and Gtrans='1' and oper="0010" then					
                 write(sv_line,"---------------" & " result of P + Gt from upper bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish addition, ");
            elsif	Ptrans='1' and Gtrans='0' and oper="0010" then					
                 write(sv_line,"---------------" & " result of Pt + G from upper bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish addition, ");
            elsif	Ptrans='1' and Gtrans='1' and oper="0010" then					
                 write(sv_line,"---------------" & " result of Pt + Gt from upper bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish addition, ");
            elsif	Ptrans='0' and Gtrans='0' and oper="0011" then					
                 write(sv_line,"---------------" & " result of P - G from upper bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish subtraction, ");
            elsif	Ptrans='0' and Gtrans='1' and oper="0011" then					
                 write(sv_line,"---------------" & " result of P - Gt from upper bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish subtraction, ");
            elsif	Ptrans='1' and Gtrans='0' and oper="0011" then					
                 write(sv_line,"---------------" & " result of Pt - G from upper bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish subtraction, ");
            elsif	Ptrans='1' and Gtrans='1' and oper="0011" then					
                  write(sv_line,"---------------" & " result of Pt - Gt from upper bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish subtraction, ");
            elsif	Ptrans='0' and Gtrans='0' and oper="0100" then					
                 write(sv_line,"---------------" & " result of G-P from upper bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish subtraction, ");
            elsif	Ptrans='0' and Gtrans='1' and oper="0100" then					
                 write(sv_line,"---------------" & " result of Gt-P from upper bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish subtraction, ");
            elsif	Ptrans='1' and Gtrans='0' and oper="0100" then					
                 write(sv_line,"---------------" & " result of G-Pt from upper bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish subtraction, ");
            elsif	Ptrans='1' and Gtrans='1' and oper="0100" then					
                 write(sv_line,"---------------" & " result of Gt-Pt from upper bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish subtraction, ");
            elsif	Ptrans='0' and Gtrans='0' and oper="0101" then					
                 write(sv_line,"---------------" & " result of P.G from upper bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish dot multiplication, ");
            elsif	Ptrans='0' and Gtrans='1' and oper="0101" then					
                 write(sv_line,"---------------" & " result of P.Gt from upper bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish dot multiplication, ");
            elsif	 Ptrans='1' and Gtrans='0' and oper="0101" then					
                 write(sv_line,"---------------" & " result of Pt.G from upper bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish dot multiplication, ");
            elsif Ptrans='1' and Gtrans='1' and oper="0101" then					
                 write(sv_line,"---------------" & " result of Pt.Gt from upper bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish dot multiplication, ");
            elsif Ptrans='0' and Gtrans='0' and oper="0110" then					
                 write(sv_line,"---------------" & " result of V*P from upper bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish dot multiplication, ");
            elsif Ptrans='0' and Gtrans='1' and oper="0110" then					
                 write(sv_line,"---------------" & " result of V*Pt from upper bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish dot multiplication, ");
            elsif Ptrans='0' and Gtrans='0' and oper="0111" then					
                 write(sv_line,"---------------" & " result of P*V from upper bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish dot multiplication, ");
            elsif Ptrans='0' and Gtrans='1' and oper="0111" then					
                 write(sv_line,"---------------" & " result of Pt*V from upper bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish dot multiplication, ");
            elsif Ptrans='0' and Gtrans='0' and oper="1000" then					
                 write(sv_line,"---------------" & " result of S.P from upper bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish dot multiplication, ");
            elsif Ptrans='0' and Gtrans='1' and oper="1000" then					
                 write(sv_line,"---------------" & " result of S.Pt from upper bank of BRAM. " & str(v_delay_latency) & " clock cycles to finish dot multiplication, ");
            end if;
		end if;




            wait until UN_LOADING_DONE = '1';
			end if;
        end loop;
            wait for clk_period; -- wait for the all values to be written to file

PrintResultToConsole; -- Procedure to print the result to console. Read from Result file then print to console.
PrintResultInCSVFormat; -- Procedure to print the result to a file in CSV format.

            wait for clk_period; -- wait for the all values to be written to file


wait;
 				
				

end process;

Execution_Process:process
file file_pointer : text;
file Result_file_pointer: text;
variable line_num, line_num2: line;
type t_line_array is array (0 to COLUMN_TOTAL-1) of line;
variable v_line_array: t_line_array;
variable x: integer:=0;
variable I_MAX,J_MAX :integer:=0;
variable i:integer:=0;
begin	
	
	case cmd is
		when cmd_G_READ_START =>
		---------------------------------------Begining of GRAM LOAD-----------------------------------------------------			
					rst <= '1';
					file_open(file_pointer,"../../TestingFiles/Gdata.txt",READ_MODE); 
					readline (file_pointer,line_num); 
					read(line_num,I_MAX);
					readline (file_pointer,line_num); 
					read(line_num,J_MAX);	
					report "COLS number: " & integer'image(I_MAX);
					report "ROWS number:" & integer'image(J_MAX);
					GWE<='1';
					--  Assuming that file has enough lines as stated in first two lines COLS and ROWS
					      for i in 1 to I_MAX loop				      				
									for j in 1 to J_MAX loop
										readline (file_pointer,line_num);  --Read the whole line from the file
										READ (line_num,x);
										--report "The value of G" & integer'image(i) & integer'image(j) &" = " & integer'image(x);
												GCOL<=std_logic_vector(to_unsigned(i-1,ADDR_WIDTH));
												GROW<=std_logic_vector(to_signed(j-1,ADDR_WIDTH));
												GDIN<=std_logic_vector(to_signed(x,DATA_WIDTH));
												wait for CLK_period;																					
									end loop;
					        end loop;  
			       	file_close(file_pointer);  --after reading all the lines close the file. 
					GWE<='0';--disable writing.
			      	GREAD_DONE<='1';		      	
			      	
		----------------------------------------End of GRAM LOAD---------------------------------------------------------	
		when cmd_P_READ_START =>
		---------------------------------------Begining of BRAM LOAD-----------------------------------------------------		
				mode<="111";
				rst <= '1'; --release FSM from Reset state
				LOAD <= '1';--PUT the FSM in MEMARRAY_V3 in Loading State.
				wait for clk_period*3;
				rst <= '0'; 
				DATA_INPUT <= '0';-- Switch Input data of MEMARRAY_V3 to DIN
			    -------------------------------------------------- READING THE P MATRIX from file to device
				  file_open(file_pointer,"../../TestingFiles/Pdata.txt",READ_MODE);				
					--LOAD <= '1';--PUT the FSM in MEMARRAY_V3 in Loading State.
 
					wait until READY = '1';-- wait unitl MEMARRAY_V3 sends ready signal.					
					for i in 1 to COLUMN_TOTAL loop
						for j in 1 to COLUMN_TOTAL loop
							readline (file_pointer,line_num);  --Read the whole line from the file
							READ (line_num,x);
							--report "The value of P" & integer'image(i) & integer'image(j) &" = " & integer'image(x);
							DIN <= std_logic_vector(to_signed(x,DATA_WIDTH));				
							wait for CLK_period;
						end loop;
					end loop;
					file_close(file_pointer);  --after reading all the lines close the file.		
					DIN <= (others => '0');						
							
		----------------------------------------End of BRAM LOAD---------------------------------------------------------	
		
		when cmd_Unload_BRAM_Content =>
		-----------------------------------------Begining of UNLOAD BRAM-------------------------------------------------
			LOAD <= '0';
			UN_LOAD <= '1'; -- Tell FSM to go to unloading state.
			--Bank_sel_in <= '1'; -- Tell BRAM to read data from upper bank. Note that this bit is the MSB of ADDRB and it is inverted For Address B. making it 1 means it is 0 for address B
			wait for clk_period*3;
			wait until READY = '1';
			wait for clk_period;
		---------------------------------Write the values to Terminal---------------------		
			i:=0;
			--write(line_num,"#############" & MSG & "#############");--write(line_num,"############# These are the values loaded into BRAM ##############");
			--writeline(output, sv_line);
			if sv_Result_File_Open = false then
				file_open(Result_file_pointer,"../../TestingFiles/MATRIX_MUL_IP_CORE_S_INT.txt", WRITE_MODE);
			else
				file_open(Result_file_pointer,"../../TestingFiles/MATRIX_MUL_IP_CORE_S_INT.txt", APPEND_MODE);
			end if;			
			write(line_num,"---------------BEGINNING OF SECTION (See end of Section for details)---------------");
--			writeline(output, line_num);
			writeline(Result_file_pointer,line_num);			
			while UN_LOADING_DONE = '0' loop	-- Read out the values stored in BRAM and display on simulator waveform viewer. The values are read out in exactly the way they were saved.
				
				BRAM_DATA(i) <= dout;
				wait for CLK_period;
				i := i + 1;
				if i = COLUMN_TOTAL then
					for k in 0 to COLUMN_TOTAL-1 loop
						if k = 0 then
							write(line_num,str(to_integer(unsigned(BRAM_DATA(COLUMN_TOTAL-1-k)))),LEFT,10);
							--write(v_line_array(k),str(to_integer(unsigned(BRAM_DATA(COLUMN_TOTAL-1-k)))),RIGHT,10);
						else						
							write(line_num, str(to_integer(unsigned(BRAM_DATA(COLUMN_TOTAL-1-k)))),LEFT,10);
							--write(v_line_array(k),str(to_integer(unsigned(BRAM_DATA(COLUMN_TOTAL-1-k)))),RIGHT,10);
						end if;
					end loop;
					--writeline(output, line_num);
					writeline(Result_file_pointer,line_num);					
					i:=0;
				end if;
			end loop;			
			
			write(sv_line, str(g_cnt_delay_ready) & " clock cycles to unload" & "---------------");
			--writeline(output, sv_line);
			writeline(Result_file_pointer,sv_line);
			write(line_num," ");-- write empty space 
			--writeline(output, line_num);-- write empty new line
			writeline(Result_file_pointer,line_num);
			file_close(Result_file_pointer);		
			
--			write(sv_line, str(g_cnt_delay_ready) & " clock cycles to unload" & "---------------");
--			writeline(Result_file_pointer,sv_line);
--			for s in 0 to v_line_array'length-1 loop
--				writeline(Result_file_pointer,v_line_array(s));
--			end loop;			
--			write(line_num,"-----------------------------------------------------------------------");
--			writeline(Result_file_pointer,line_num);
--			file_close(Result_file_pointer);
--			
--			file_open(Result_file_pointer,"../TestingFiles/PG_Result.txt",READ_MODE);
--			while not endfile(Result_file_pointer) loop
--				Readline(Result_file_pointer,line_num2);
--				--wait for clk_period;
--				Writeline(output,line_num2);
--			end loop;
--			file_close(Result_file_pointer);
			
		----------------------------------------End of UNLOAD BRAM--------------------------------------------------------
		when cmd_PG =>		
			LOAD <= '0';	-- Tell FSM not to LOAD data.
			UN_LOAD <= '0'; -- Tell FSM not to go to unloading state.
			DATA_INPUT <= '1'; -- Switch Input data of MEMARRAY_V3 to GRAM. 
			P <= '0';
			G <= '0';
			mode <= "011";
			rst <= '1';
			wait for clk_period*3;
			rst <= '0';
			wait until OP_DONE = '1';
		
		when cmd_PGt =>		
			LOAD <= '0';	-- Tell FSM not to LOAD data.
			UN_LOAD <= '0'; -- Tell FSM not to go to unloading state.
			DATA_INPUT <= '1'; -- Switch Input data of MEMARRAY_V3 to GRAM. 
			P <= '0';
			G <= '1';
			mode <= "011";
			rst <= '1';
			wait for clk_period*3;
			rst <= '0';
			wait until OP_DONE = '1';
			
		when cmd_PtG =>		
			LOAD <= '0';	-- Tell FSM not to LOAD data.
			UN_LOAD <= '0'; -- Tell FSM not to go to unloading state.
			DATA_INPUT <= '1'; -- Switch Input data of MEMARRAY_V3 to GRAM. 
			P <= '1';
			G <= '0';
			mode <= "011";
			rst <= '1';
			wait for clk_period*3;
			rst <= '0';
			wait until OP_DONE = '1';						
		when cmd_PtGt =>		
			LOAD <= '0';	-- Tell FSM not to LOAD data.
			UN_LOAD <= '0'; -- Tell FSM not to go to unloading state.
			DATA_INPUT <= '1'; -- Switch Input data of MEMARRAY_V3 to GRAM. 
			P <= '1';
			G <= '1';
			mode <= "011";
			rst <= '1';
			wait for clk_period*3;
			rst <= '0';
			wait until OP_DONE = '1';
		when cmd_PpG =>		
			LOAD <= '0';	-- Tell FSM not to LOAD data.
			UN_LOAD <= '0'; -- Tell FSM not to go to unloading state.
			DATA_INPUT <= '1'; -- Switch Input data of MEMARRAY_V3 to GRAM. 
			P <= '0';
			G <= '0';
<<<<<<< HEAD
			mode <= "010";
=======
			mode <= "100";
>>>>>>> 18f3147bfef5a25930a06fdd3be25caa8f4ca9b6
			rst <= '1';
			wait for clk_period*3;
			rst <= '0';
			wait until OP_DONE = '1';
		when cmd_PpGt =>		
			LOAD <= '0';	-- Tell FSM not to LOAD data.
			UN_LOAD <= '0'; -- Tell FSM not to go to unloading state.
			DATA_INPUT <= '1'; -- Switch Input data of MEMARRAY_V3 to GRAM. 
			P <= '0';
			G <= '1';
<<<<<<< HEAD
			mode <= "010";
=======
			mode <= "100";
>>>>>>> 18f3147bfef5a25930a06fdd3be25caa8f4ca9b6
			rst <= '1';
			wait for clk_period*3;
			rst <= '0';
			wait until OP_DONE = '1';
		when cmd_PtpG =>		
			LOAD <= '0';	-- Tell FSM not to LOAD data.
			UN_LOAD <= '0'; -- Tell FSM not to go to unloading state.
			DATA_INPUT <= '1'; -- Switch Input data of MEMARRAY_V3 to GRAM. 
			P <= '1';
			G <= '0';
<<<<<<< HEAD
			mode <= "010";
=======
			mode <= "100";
>>>>>>> 18f3147bfef5a25930a06fdd3be25caa8f4ca9b6
			rst <= '1';
			wait for clk_period*3;
			rst <= '0';
			wait until OP_DONE = '1';
		when cmd_PtpGt =>		
			LOAD <= '0';	-- Tell FSM not to LOAD data.
			UN_LOAD <= '0'; -- Tell FSM not to go to unloading state.
			DATA_INPUT <= '1'; -- Switch Input data of MEMARRAY_V3 to GRAM. 
			P <= '1';
			G <= '1';
<<<<<<< HEAD
			mode <= "010";
=======
			mode <= "100";
>>>>>>> 18f3147bfef5a25930a06fdd3be25caa8f4ca9b6
			rst <= '1';
			wait for clk_period*3;
			rst <= '0';
			wait until OP_DONE = '1';
			
		when cmd_PmG =>		
			LOAD <= '0';	-- Tell FSM not to LOAD data.
			UN_LOAD <= '0'; -- Tell FSM not to go to unloading state.
			DATA_INPUT <= '1'; -- Switch Input data of MEMARRAY_V3 to GRAM. 
			P <= '0';
			G <= '0';
<<<<<<< HEAD
			mode <= "100";
=======
			mode <= "101";
>>>>>>> 18f3147bfef5a25930a06fdd3be25caa8f4ca9b6
			rst <= '1';
			wait for clk_period*3;
			rst <= '0';
			wait until OP_DONE = '1';
		when cmd_PmGt =>		
			LOAD <= '0';	-- Tell FSM not to LOAD data.
			UN_LOAD <= '0'; -- Tell FSM not to go to unloading state.
			DATA_INPUT <= '1'; -- Switch Input data of MEMARRAY_V3 to GRAM. 
			P <= '0';
			G <= '1';
<<<<<<< HEAD
			mode <= "100";
=======
			mode <= "101";
>>>>>>> 18f3147bfef5a25930a06fdd3be25caa8f4ca9b6
			rst <= '1';
			wait for clk_period*3;
			rst <= '0';
			wait until OP_DONE = '1';
		when cmd_PtmG =>		
			LOAD <= '0';	-- Tell FSM not to LOAD data.
			UN_LOAD <= '0'; -- Tell FSM not to go to unloading state.
			DATA_INPUT <= '1'; -- Switch Input data of MEMARRAY_V3 to GRAM. 
			P <= '1';
			G <= '0';
<<<<<<< HEAD
			mode <= "100";
=======
			mode <= "101";
>>>>>>> 18f3147bfef5a25930a06fdd3be25caa8f4ca9b6
			rst <= '1';
			wait for clk_period*3;
			rst <= '0';
			wait until OP_DONE = '1';
		when cmd_PtmGt =>		
			LOAD <= '0';	-- Tell FSM not to LOAD data.
			UN_LOAD <= '0'; -- Tell FSM not to go to unloading state.
			DATA_INPUT <= '1'; -- Switch Input data of MEMARRAY_V3 to GRAM. 
			P <= '1';
			G <= '1';
<<<<<<< HEAD
			mode <= "100";
=======
			mode <= "101";
>>>>>>> 18f3147bfef5a25930a06fdd3be25caa8f4ca9b6
			rst <= '1';
			wait for clk_period*3;
			rst <= '0';
			wait until OP_DONE = '1';
			
		when cmd_GmP =>		
			LOAD <= '0';	-- Tell FSM not to LOAD data.
			UN_LOAD <= '0'; -- Tell FSM not to go to unloading state.
			DATA_INPUT <= '1'; -- Switch Input data of MEMARRAY_V3 to GRAM. 
			P <= '0';
			G <= '0';
<<<<<<< HEAD
			mode <= "101";
=======
			mode <= "110";
>>>>>>> 18f3147bfef5a25930a06fdd3be25caa8f4ca9b6
			rst <= '1';
			wait for clk_period*3;
			rst <= '0';
			wait until OP_DONE = '1';
		when cmd_GtmP =>		
			LOAD <= '0';	-- Tell FSM not to LOAD data.
			UN_LOAD <= '0'; -- Tell FSM not to go to unloading state.
			DATA_INPUT <= '1'; -- Switch Input data of MEMARRAY_V3 to GRAM. 
			P <= '0';
			G <= '1';
<<<<<<< HEAD
			mode <= "101";
=======
			mode <= "110";
>>>>>>> 18f3147bfef5a25930a06fdd3be25caa8f4ca9b6
			rst <= '1';
			wait for clk_period*3;
			rst <= '0';
			wait until OP_DONE = '1';
		when cmd_GmPt =>		
			LOAD <= '0';	-- Tell FSM not to LOAD data.
			UN_LOAD <= '0'; -- Tell FSM not to go to unloading state.
			DATA_INPUT <= '1'; -- Switch Input data of MEMARRAY_V3 to GRAM. 
			P <= '1';
			G <= '0';
<<<<<<< HEAD
			mode <= "101";
=======
			mode <= "110";
>>>>>>> 18f3147bfef5a25930a06fdd3be25caa8f4ca9b6
			rst <= '1';
			wait for clk_period*3;
			rst <= '0';
			wait until OP_DONE = '1';
		when cmd_GtmPt =>		
			LOAD <= '0';	-- Tell FSM not to LOAD data.
			UN_LOAD <= '0'; -- Tell FSM not to go to unloading state.
			DATA_INPUT <= '1'; -- Switch Input data of MEMARRAY_V3 to GRAM. 
			P <= '1';
			G <= '1';
<<<<<<< HEAD
			mode <= "101";
=======
			mode <= "110";
>>>>>>> 18f3147bfef5a25930a06fdd3be25caa8f4ca9b6
			rst <= '1';
			wait for clk_period*3;
			rst <= '0';
			wait until OP_DONE = '1';

		when cmd_PdG =>		
			LOAD <= '0';	-- Tell FSM not to LOAD data.
			UN_LOAD <= '0'; -- Tell FSM not to go to unloading state.
			DATA_INPUT <= '1'; -- Switch Input data of MEMARRAY_V3 to GRAM. 
			P <= '0';
			G <= '0';
<<<<<<< HEAD
			mode <= "001";
=======
			mode <= "111";
>>>>>>> 18f3147bfef5a25930a06fdd3be25caa8f4ca9b6
			rst <= '1';
			wait for clk_period*3;
			rst <= '0';
			wait until OP_DONE = '1';
		when cmd_PdGt =>		
			LOAD <= '0';	-- Tell FSM not to LOAD data.
			UN_LOAD <= '0'; -- Tell FSM not to go to unloading state.
			DATA_INPUT <= '1'; -- Switch Input data of MEMARRAY_V3 to GRAM. 
			P <= '0';
			G <= '1';
<<<<<<< HEAD
			mode <= "001";
=======
			mode <= "111";
>>>>>>> 18f3147bfef5a25930a06fdd3be25caa8f4ca9b6
			rst <= '1';
			wait for clk_period*3;
			rst <= '0';
			wait until OP_DONE = '1';
		when cmd_PtdG =>		
			LOAD <= '0';	-- Tell FSM not to LOAD data.
			UN_LOAD <= '0'; -- Tell FSM not to go to unloading state.
			DATA_INPUT <= '1'; -- Switch Input data of MEMARRAY_V3 to GRAM. 
			P <= '1';
			G <= '0';
<<<<<<< HEAD
			mode <= "001";
=======
			mode <= "111";
>>>>>>> 18f3147bfef5a25930a06fdd3be25caa8f4ca9b6
			rst <= '1';
			wait for clk_period*3;
			rst <= '0';
			wait until OP_DONE = '1';
		when cmd_PtdGt =>		
			LOAD <= '0';	-- Tell FSM not to LOAD data.
			UN_LOAD <= '0'; -- Tell FSM not to go to unloading state.
			DATA_INPUT <= '1'; -- Switch Input data of MEMARRAY_V3 to GRAM. 
			P <= '1';
			G <= '1';
<<<<<<< HEAD
			mode <= "001";
=======
			mode <= "111";
>>>>>>> 18f3147bfef5a25930a06fdd3be25caa8f4ca9b6
			rst <= '1';
			wait for clk_period*3;
			rst <= '0';
			wait until OP_DONE = '1';
		when cmd_VP =>		
			LOAD <= '0';	-- Tell FSM not to LOAD data.
			UN_LOAD <= '0'; -- Tell FSM not to go to unloading state.
			DATA_INPUT <= '1'; -- Switch Input data of MEMARRAY_V3 to GRAM. 
			P <= '0';
			G <= '0';
			mode <= "000";
			rst <= '1';
			wait for clk_period*3;
			rst <= '0';
			wait until OP_DONE = '1';
		when cmd_VPt =>		
			LOAD <= '0';	-- Tell FSM not to LOAD data.
			UN_LOAD <= '0'; -- Tell FSM not to go to unloading state.
			DATA_INPUT <= '1'; -- Switch Input data of MEMARRAY_V3 to GRAM. 
<<<<<<< HEAD
			P <= '1';
			G <= '0';
			mode <= "110";
=======
			P <= '0';
			G <= '1';
			mode <= "000";
>>>>>>> 18f3147bfef5a25930a06fdd3be25caa8f4ca9b6
			rst <= '1';
			wait for clk_period*3;
			rst <= '0';
			wait until OP_DONE = '1';
		when cmd_PV =>		
			LOAD <= '0';	-- Tell FSM not to LOAD data.
			UN_LOAD <= '0'; -- Tell FSM not to go to unloading state.
			DATA_INPUT <= '1'; -- Switch Input data of MEMARRAY_V3 to GRAM. 
			P <= '0';
			G <= '0';
			mode <= "001";
			rst <= '1';
			wait for clk_period*3;
			rst <= '0';
			wait until OP_DONE = '1';
		when cmd_PtV =>		
			LOAD <= '0';	-- Tell FSM not to LOAD data.
			UN_LOAD <= '0'; -- Tell FSM not to go to unloading state.
			DATA_INPUT <= '1'; -- Switch Input data of MEMARRAY_V3 to GRAM. 
<<<<<<< HEAD
			P <= '1';
			G <= '0';
			mode <= "111";
=======
			P <= '0';
			G <= '1';
			mode <= "001";
>>>>>>> 18f3147bfef5a25930a06fdd3be25caa8f4ca9b6
			rst <= '1';
			wait for clk_period*3;
			rst <= '0';
			wait until OP_DONE = '1';

 		when cmd_SP =>		
			LOAD <= '0';	-- Tell FSM not to LOAD data.
			UN_LOAD <= '0'; -- Tell FSM not to go to unloading state.
			DATA_INPUT <= '1'; -- Switch Input data of MEMARRAY_V3 to GRAM. 
			P <= '0';
			G <= '0';
<<<<<<< HEAD
			mode <= "011";
=======
			mode <= "010";
>>>>>>> 18f3147bfef5a25930a06fdd3be25caa8f4ca9b6
			rst <= '1';
			wait for clk_period*3;
			rst <= '0';
			wait until OP_DONE = '1';
 		when cmd_SPt =>		
			LOAD <= '0';	-- Tell FSM not to LOAD data.
			UN_LOAD <= '0'; -- Tell FSM not to go to unloading state.
			DATA_INPUT <= '1'; -- Switch Input data of MEMARRAY_V3 to GRAM. 
			P <= '0';
			G <= '0';
<<<<<<< HEAD
			mode <= "011";
=======
			mode <= "010";
>>>>>>> 18f3147bfef5a25930a06fdd3be25caa8f4ca9b6
			rst <= '1';
			wait for clk_period*3;
			rst <= '0';
			wait until OP_DONE = '1';

		when others =>
			--do nothing dummy command.
	end case;
	
	wait on cmd;
	
end process;

END;