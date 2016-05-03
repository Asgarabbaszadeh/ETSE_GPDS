library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use work.MATRIX_MUL_IP_CORE__S_INT.all;
entity CONTROL_UNIT_S_INT is
	generic(
		ADDR_WIDTH   : integer := 10;
		DATA_WIDTH	 :integer:=18;
		OPCODE_WIDTH : integer := 3;
		COLUMN_TOTAL : integer := 100);
	Port(CLK          : in  STD_LOGIC;
		 RST          : in  STD_LOGIC;
		 LOAD         : in  STD_LOGIC;
		 UN_LOAD	  : in STD_LOGIC;			
		 P            : in  STD_LOGIC;
		 G            : in  STD_LOGIC;
		 mode            : in  std_logic_vector(2 downto 0);
		 WE           : out std_logic;
		 CSEL			:out std_logic_vector(COLUMN_TOTAL-1 downto 0);
		 Read_ADDR		: out STD_LOGIC_VECTOR(ADDR_WIDTH - 2 downto 0);
		 Write_ADDR		: out STD_LOGIC_VECTOR(ADDR_WIDTH - 2 downto 0);
		 Read_SHFT       : out STD_LOGIC;
		 Write_SHFT		: out std_logic;		 
		 OPCODE       : out STD_LOGIC_VECTOR(OPCODE_WIDTH - 1 downto 0);
		 G_ROW        : out STD_LOGIC_VECTOR(ADDR_WIDTH - 1 downto 0);
		 G_COLUMN     : out STD_LOGIC_VECTOR(ADDR_WIDTH - 1 downto 0);
		 G_EN		: out STD_LOGIC;
		 READY		  : out std_logic;	
		 OP_DONE      : out std_logic;
		 LOADING_DONE : out std_logic;
		 UN_LOADING_DONE : out std_logic;
		 CONTROL_A_INPUT_OF_DSP: out std_logic);
end CONTROL_UNIT_S_INT;

architecture Behavioral of CONTROL_UNIT_S_INT is

constant PIPELINE_DELAY: integer:=7;
	

type OPCODE_t_t is array (0 to 6) of  std_logic_vector(OPCODE_WIDTH-1 downto 0);
signal OPCODE_t: OPCODE_t_t;

type Write_ADDR_t_t is array (0 to 5) of  std_logic_vector(ADDR_WIDTH-2 downto 0);
signal Write_ADDR_t: Write_ADDR_t_t;

type Read_ADDR_t_t is array (0 to 5) of  std_logic_vector(ADDR_WIDTH-2 downto 0);
signal Read_ADDR_t: Read_ADDR_t_t;

type G_ROW_t_t is array (0 to 5) of  std_logic_vector(ADDR_WIDTH-1 downto 0);
signal G_ROW_t: G_ROW_t_t;

type G_COLUMN_t_t is array (0 to 5) of  std_logic_vector(ADDR_WIDTH-1 downto 0);
signal G_COLUMN_t: G_COLUMN_t_t;

type CSEL_t_t is array (0 to 6) of  std_logic_vector(COLUMN_TOTAL-1 downto 0);
signal CSEL_t: CSEL_t_t;

signal Write_SHFT_t: std_logic_vector(4 downto 0);
signal Read_SHFT_t: std_logic_vector(5 downto 0);
signal OP_DONE_t: std_logic_vector(4 downto 0);
signal WE_t: std_logic_vector(5 downto 0);

signal Load_READY,Unload_READY,Load_OP_DONE,Unload_OP_DONE : std_logic;
signal EN: std_logic_vector(6 downto 0);
type state_type is (START_state,LOADING_state,LOAD_DONE_state,SSP_state,PpG_state,PG_state,VP_state,DONE_state,UNLOAD_state);--,UNLOAD_DONE);
signal state: state_type;
signal Load_OPCODE, Unload_OPCODE, SSP_OPCODE: std_logic_vector(OPCODE_WIDTH-1 downto 0);   

signal Read_ADDR_1: STD_LOGIC_VECTOR(ADDR_WIDTH - 2 downto 0);

component Loading
	generic(
		ADDR_WIDTH   : integer := 10;
		DATA_WIDTH	 :integer:=18;
		OPCODE_WIDTH : integer := 3;
		COLUMN_TOTAL : integer := 4);
	Port(CLK          : in  STD_LOGIC;
		 RST          : in  STD_LOGIC;
		 WE           : out std_logic;
		 CSEL			:out std_logic_vector(COLUMN_TOTAL-1 downto 0);
		 Write_ADDR		: out STD_LOGIC_VECTOR(ADDR_WIDTH - 2 downto 0);
		 READY		  : out std_logic;	
		 OP_DONE      : out std_logic);
end component;
component Unloading
	generic(
		ADDR_WIDTH   : integer := 10;
		DATA_WIDTH	 :integer:=18;
		OPCODE_WIDTH : integer := 3;
		COLUMN_TOTAL : integer := 4);
	Port(CLK          : in  STD_LOGIC;
		 RST          : in  STD_LOGIC;
		 CSEL			:out std_logic_vector(COLUMN_TOTAL-1 downto 0);
		 Read_ADDR		: out STD_LOGIC_VECTOR(ADDR_WIDTH - 2 downto 0);
		 OPCODE       : out STD_LOGIC_VECTOR(OPCODE_WIDTH - 1 downto 0);
		 READY		  : out std_logic;	
		 OP_DONE      : out std_logic;
		 CONTROL_A_INPUT_OF_DSP: out std_logic);
end component;
component SSP
generic(
		ADDR_WIDTH   : integer := 10;
		DATA_WIDTH	 :integer:=18;
		OPCODE_WIDTH : integer := 3;
		COLUMN_TOTAL : integer := 4);
	Port(CLK          : in  STD_LOGIC;
		 RST          : in  STD_LOGIC;
		 WE           : out std_logic;
		 CSEL			:out std_logic_vector(COLUMN_TOTAL-1 downto 0);
		 ADDR		: out STD_LOGIC_VECTOR(ADDR_WIDTH - 2 downto 0);
		 OPCODE       : out STD_LOGIC_VECTOR(OPCODE_WIDTH - 1 downto 0);
		 OP_DONE      : out std_logic);
end component;

component PpG_PdG
generic(
		ADDR_WIDTH   : integer := 10;
		DATA_WIDTH	 :integer:=18;
		OPCODE_WIDTH : integer := 3;
		COLUMN_TOTAL : integer := 3);
	Port(CLK         : in  STD_LOGIC;
		 RST          : in  STD_LOGIC;
		 WE           : out std_logic;
		 P            : in  STD_LOGIC;
		 G            : in  STD_LOGIC;		 
		 mode			  :in std_logic_vector(2 downto 0);
		 CSEL			  :out std_logic_vector(COLUMN_TOTAL-1 downto 0);
		 Write_ADDR	  : out STD_LOGIC_VECTOR(ADDR_WIDTH - 2 downto 0);
		 Read_ADDR	  : out STD_LOGIC_VECTOR(ADDR_WIDTH - 2 downto 0);
		 Read_SHFT       : out STD_LOGIC;
 		 G_ROW   		: out STD_LOGIC_VECTOR(ADDR_WIDTH - 1 downto 0);
		 G_COLUMN		: out STD_LOGIC_VECTOR(ADDR_WIDTH - 1 downto 0);	 	 
		 OPCODE       : out STD_LOGIC_VECTOR(OPCODE_WIDTH - 1 downto 0);
		 OP_DONE      : out std_logic);
end component;

component Multiplication
generic(
		ADDR_WIDTH   : integer := 10;
		DATA_WIDTH	 :integer:=18;
		OPCODE_WIDTH : integer := 3;
		COLUMN_TOTAL : integer := 3);
	Port(CLK         : in  STD_LOGIC;
		 RST          : in  STD_LOGIC;
		 WE           : out std_logic;
		 P            : in  STD_LOGIC;
		 G            : in  STD_LOGIC;		 
		 CSEL			  :out std_logic_vector(COLUMN_TOTAL-1 downto 0);
		 Write_ADDR	  : out STD_LOGIC_VECTOR(ADDR_WIDTH - 2 downto 0);
		 Read_ADDR	  : out STD_LOGIC_VECTOR(ADDR_WIDTH - 2 downto 0);
		 Read_SHFT       : out STD_LOGIC;
 		 G_ROW   		: out STD_LOGIC_VECTOR(ADDR_WIDTH - 1 downto 0);
		 G_COLUMN		: out STD_LOGIC_VECTOR(ADDR_WIDTH - 1 downto 0);	 	 
		 OPCODE       : out STD_LOGIC_VECTOR(OPCODE_WIDTH - 1 downto 0);
		 OP_DONE      : out std_logic);
end component;

component VP_Mult
generic(
		ADDR_WIDTH   : integer := 10;
		DATA_WIDTH	 :integer:=18;
		OPCODE_WIDTH : integer := 3;
		COLUMN_TOTAL : integer := 3);
	Port(CLK         : in  STD_LOGIC;
		 RST          : in  STD_LOGIC;
		 WE           : out std_logic;
		 P            : in  STD_LOGIC;
		 CSEL			  :out std_logic_vector(COLUMN_TOTAL-1 downto 0);
		 mode			  :in std_logic_vector(2 downto 0);
		 Read_ADDR	  : out STD_LOGIC_VECTOR(ADDR_WIDTH - 2 downto 0);
		 Read_SHFT       : out STD_LOGIC;
 		 G_ROW   		: out STD_LOGIC_VECTOR(ADDR_WIDTH - 1 downto 0);
		 G_COLUMN		: out STD_LOGIC_VECTOR(ADDR_WIDTH - 1 downto 0);	 	 
		 OPCODE       : out STD_LOGIC_VECTOR(OPCODE_WIDTH - 1 downto 0);
		 OP_DONE      : out std_logic);
end component;

begin
<<<<<<< HEAD
-----------------------------------------------------------
Load_Unit : Loading
	generic map(
		ADDR_WIDTH  => ADDR_WIDTH,
		DATA_WIDTH => DATA_WIDTH,
		OPCODE_WIDTH => OPCODE_WIDTH,
		COLUMN_TOTAL => COLUMN_TOTAL
		)
	Port map(CLK => CLK,
		 RST  => EN(0),
		 WE   => WE_t(0),
		 CSEL	=> CSEL_t(0),
		 Write_ADDR => Write_ADDR_t(0),
		 READY  => Load_READY,
		 OP_DONE => Load_OP_DONE  
		 );
Unload_Unit : Unloading
	generic map(
		ADDR_WIDTH  => ADDR_WIDTH,
		DATA_WIDTH => DATA_WIDTH,
		OPCODE_WIDTH => OPCODE_WIDTH,
		COLUMN_TOTAL => COLUMN_TOTAL
		)
	Port map(CLK => CLK,
		 RST  => EN(1),
		 CSEL	=> CSEL_t(1),
		 Read_ADDR => Read_ADDR_t(0),
		 OPCODE => OPCODE_t(0),  
		 READY  => Unload_READY,
		 OP_DONE => Unload_OP_DONE,  
		 CONTROL_A_INPUT_OF_DSP => CONTROL_A_INPUT_OF_DSP
		 );

Scalar_Prod : SSP
generic map(
		ADDR_WIDTH  => ADDR_WIDTH,
		DATA_WIDTH => DATA_WIDTH,
		OPCODE_WIDTH => OPCODE_WIDTH,
		COLUMN_TOTAL => COLUMN_TOTAL
		)
	Port map(CLK => CLK,
		 RST  => EN(2),
		 WE   => WE_t(1),
		 CSEL	=> CSEL_t(2),
		 ADDR =>Write_ADDR_t(1),
		 OPCODE =>OPCODE_t(1),
		 OP_DONE =>OP_DONE_t(0)
		 );

Addition : PpG_PdG
generic map(
		     ADDR_WIDTH  => ADDR_WIDTH,
		     DATA_WIDTH => DATA_WIDTH,
		     OPCODE_WIDTH => OPCODE_WIDTH,
		     COLUMN_TOTAL => COLUMN_TOTAL
		     )
Port map(CLK => CLK,
		 RST  => EN(3),
		 WE   => WE_t(2),
		 P    =>P,
		 G    =>G,		 
		 mode	=> mode,
		 CSEL	=>CSEL_t(3),
		 Write_ADDR => Write_ADDR_t(2),
		 Read_ADDR	=>Read_ADDR_t(1),
		 Read_SHFT  =>Read_SHFT_t(0),
 		 G_ROW      =>G_ROW_t(0),
		 G_COLUMN   =>G_COLUMN_t(0),	 	 
		 OPCODE       =>OPCODE_t(2),
		 OP_DONE=>OP_DONE_t(1)
		 );
		 
PG: Multiplication
generic map(
		     ADDR_WIDTH  => ADDR_WIDTH,
		     DATA_WIDTH => DATA_WIDTH,
		     OPCODE_WIDTH => OPCODE_WIDTH,
		     COLUMN_TOTAL => COLUMN_TOTAL
			  )
	Port map(CLK => CLK,
		 RST  => EN(4),
		 WE   => WE_t(3),
		 P    =>P,
		 G    =>G,		 
		 CSEL	=>CSEL_t(4),
		 Write_ADDR => Write_ADDR_t(3),
		 Read_ADDR	=>Read_ADDR_t(2),
		 Read_SHFT  =>Read_SHFT_t(1),
 		 G_ROW      =>G_ROW_t(1),
		 G_COLUMN   =>G_COLUMN_t(1),	 	 
		 OPCODE       =>OPCODE_t(3),
		 OP_DONE=>OP_DONE_t(2)
		 );

VP: VP_Mult
generic map(
		     ADDR_WIDTH  => ADDR_WIDTH,
		     DATA_WIDTH => DATA_WIDTH,
		     OPCODE_WIDTH => OPCODE_WIDTH,
		     COLUMN_TOTAL => COLUMN_TOTAL
			  )
	Port map(CLK => CLK,
		 RST  => EN(5),
		 WE   => WE_t(4),
		 P    =>P,
		 CSEL	=>CSEL_t(5),
		 mode	=> mode,
		 Read_ADDR	=>Read_ADDR_t(3),
		 Read_SHFT  =>Read_SHFT_t(2),
 		 G_ROW      =>G_ROW_t(2),
		 G_COLUMN   =>G_COLUMN_t(2),	 	 
		 OPCODE       =>OPCODE_t(4),
		 OP_DONE=>OP_DONE_t(3)
		 );

=======
if rising_edge(CLK) then
		if(RST='1') then
			--state<=START;
			v_cnt_delay_ready := 0;
			READY <= '0';
			LOADING_DONE <= '0';
			UN_LOADING_DONE <= '0';
			OP_DONE <= '0';			
		else
			--current_state <= next_state;   --state change.
			if state = Loading then
				v_cnt_delay_ready := v_cnt_delay_ready + 1;
-- Note if DIN input to DSP block is delayed from GRAM (3 stage Pipeline) instead of using the 2 stage Pipeline in MEMARRY then this value should be 1 otherwise set it to 4.				
				if v_cnt_delay_ready >= 4 then
					READY <= '1';
				end if;
				
				if v_cnt_delay_ready = (PIPELINE_DELAY + 1 + COLUMN_TOTAL*COLUMN_TOTAL) then
					LOADING_DONE <= '1';
				end if;
				
			elsif state = UNLOAD then
				v_cnt_delay_ready := v_cnt_delay_ready + 1;
				if v_cnt_delay_ready >= PIPELINE_DELAY then
					READY <= '1';
				end if;
				if mode<"010" then
		   		if v_cnt_delay_ready >= (PIPELINE_DELAY + COLUMN_TOTAL) then
      				UN_LOADING_DONE <= '1';
			   	end if;
				 else
				 	if v_cnt_delay_ready >= (PIPELINE_DELAY + COLUMN_TOTAL*COLUMN_TOTAL) then
      				UN_LOADING_DONE <= '1';
			      end if;
				 end if;
			elsif state = PG or state = PGt or state = PtG or state = PtGt or state = PpG or state = PpGt or state = PtpG or state = PtpGt or state = SSP or state = VP or state = VPt or state = PV or state = PtV then
				v_cnt_delay_ready := v_cnt_delay_ready + 1;
				if mode<"011" then
				   if v_cnt_delay_ready >= (PIPELINE_DELAY + COLUMN_TOTAL) then
					   OP_DONE <= '1';
				   end if;			
				else
				   if v_cnt_delay_ready >= (PIPELINE_DELAY + COLUMN_TOTAL*COLUMN_TOTAL) then
				   OP_DONE <= '1';
				   end if;			
           end if;
			else
				READY <= '0';
				LOADING_DONE <= '0';
				UN_LOADING_DONE <= '0';
				OP_DONE <= '0';
				v_cnt_delay_ready := 0;
			end if;
		end if;
end if;
cnt_delay_ready <= v_cnt_delay_ready;
g_cnt_delay_ready <= v_cnt_delay_ready;--write to global variable
end process;
>>>>>>> 18f3147bfef5a25930a06fdd3be25caa8f4ca9b6
-----------------------------------------------------------
process(CLK)
variable i,j,v_load_count: integer range 0 to COLUMN_TOTAL;
variable v_CSEL : std_logic_vector(COLUMN_TOTAL-1 downto 0);
variable v_OPCODE: std_logic_vector(OPCODE_WIDTH-1 downto 0);
variable v_WE: std_logic;
variable v_LOADING_DONE, v_OP_DONE, v_UNLOAD_DONE: std_logic:='0';
variable v_i_addr_cnt: integer range 0 to COLUMN_TOTAL;
variable Unloading_Count: integer range 0 to COLUMN_TOTAL;

begin
if (rising_edge(CLK)) then
		if rst = '1' then
					state<=START_state;
					G_EN <= '0';			
					EN<="0000000";
		else	
			case state is
	
			when START_state =>
				
						IF LOAD = '1' then
						   EN<="0000001";
							state<=LOADING_state;					
						ELSE
						   EN<="0000000";
							state<=LOAD_DONE_state;
						END IF;
							-----------------------------------
<<<<<<< HEAD
				when LOADING_state =>
--						   EN<="001";
					  if Load_OP_DONE = '1' then
					     state <= LOAD_DONE_state;
						--  EN<="000";
					  else
     					  EN<="0000001";
					     state <= LOADING_state;
					  end if;
				when LOAD_DONE_state =>
						IF LOAD = '1' then
						   EN<="0000000";
 							state <= LOAD_DONE_state;	
=======
				when LOADING =>
						--s_fsm_generate_address <= true;				
						OPCODE <="000";	-- Set DSP output to A input, the Data passes through DSP so we do not want to perform any operation on the data since we are just saving it on block RAM. (P = A)			
						if v_LOADING_DONE = '0' then					
							v_LOADING_DONE := '0';
							v_WE := '1';					
							if i = COLUMN_TOTAL then -- check if we have finished a mini-round of data loading (for a 3by3 matrix this will be when i=3)
								
								if i = COLUMN_TOTAL and j = COLUMN_TOTAL-1 then -- if loading is complete set LOADING_DONE signal.
									v_LOADING_DONE := '1';
									v_WE := '0';
									v_CSEL := (others => '0');
								else							
									v_LOADING_DONE := '0';							
									j:= j+1;
									i:= 1;
									v_CSEL :=(CSEL'length-1 =>'1', others => '0');
									if j < COLUMN_TOTAL - 1 then -- check if we are still a column less than the total number of columns							
										v_CSEL := to_stdlogicvector(to_bitvector(v_CSEL) srl (COLUMN_TOTAL - j - 1));	-- This line of code will maintain the offset of the circulant matrix whenever we start a new mini-round.										
									else       
										v_CSEL := (v_CSEL'length-1 => '1', others => '0');-- This is the defualt starting value for the last mini-round.										
									end if; 
								end if;					
							else
								i:= i + 1;						
								if i = 1 and j = 0 then -- Preset v_CEL to "0000.......1" This value is only used once when we enter this state.
									v_CSEL := (0 => '1', others => '0');
								else
									v_CSEL := v_CSEL(v_CSEL'length - 2 downto 0) & v_CSEL(v_CSEL'length - 1); --rol 1 (shift one place left with roll over).
								end if;
							end if;
						else
							if v_LOADING_DONE = '1' and cnt_delay_ready = (PIPELINE_DELAY + COLUMN_TOTAL*COLUMN_TOTAL) then -- wait until gets to BRAM. 
								state <= LOAD_DONE;
							end if;
						end if;				
						
						--s_P_ADDR <= std_logic_vector(to_unsigned(j, ADDR_WIDTH-1));
						i_addr_cnt <= j;
						s_CSEL <= v_CSEL;
						WE <= v_WE;				
				when LOAD_DONE =>
						i:=0;
						j:=0;
						Write_SHFT <= '1';
						v_UNLOAD_DONE := '0';							
						s_CSEL <= (others => '1');--Enble BRAM for Saving multiplication result.		
						IF LOAD = '1' then					
   						WE <= '0';
	   					s_CSEL <= (others => '1');--Enble BRAM for Saving multiplication result.		
							state <= LOAD_DONE;	
>>>>>>> 18f3147bfef5a25930a06fdd3be25caa8f4ca9b6
						elsif UN_LOAD = '1' then
					         EN<="0000010";
   							state <= UNLOAD_state;	
						else
<<<<<<< HEAD
   						G_EN <= '1'; -- Enable GRAM
   						if (mode="001") or (mode="010") or (mode="100") or (mode="101") then
					         EN<="0001000";
	   				      state<=PpG_state;
		   				elsif mode="011" then
							    EN<="0000100";
  				             state<=SSP_state;
		   				elsif mode="000" then
							    EN<="0010000";
  				             state<=PG_state;
						  elsif mode="110" or mode="111" then
							    EN<="0100000";
  				             state<=VP_state;
							else

							
=======
						if mode="011" then
							Write_SHFT <= '1';
						else
						    Write_SHFT <= '0';
						end if;


						G_EN <= '1'; -- Enable GRAM
--mode=0 => PG mode=1 =>VP mode=2 =>PV mode=3 =>SP mode=4 =>P+G mode=5 =>P-G mode=6 =>G-P mode=7 =>P.G							
						if (mode="011") then
						   Unloading_Count:=COLUMN_TOTAL;
--   						Write_SHFT <= '1';
							OPCODE<="001";
     						s_CSEL <= (others => '1');--Enble BRAM for Saving multiplication result.		
     						WE <= '0';
							if G='0' then
								i_row_cnt<=1;
								i_col_cnt<=0;
							else
									i_row_cnt<=0;
									i_col_cnt<=1;
							end if;
    					   if (P='0') then
      						   Read_SHFT <='1';							
								   i_addr_cnt<=COLUMN_TOTAL-1;
							   	if G='0' then
								   	state<=PG;
								   else
									   state<=PGt;
								  end if;
							 else
  							Read_SHFT <='0';
							i_addr_cnt<=1;
								if G='0' then
									state<=PtG;
								else
									state<=PtGt;
								end if;
							end if;
						elsif mode = "000" then
						      Unloading_Count:=1;
--     						   Write_SHFT <= '0';
								if G='0' then
						         Read_SHFT <='0';
									i_addr_cnt<=1;
							      state<=VP;
								else
								    Read_SHFT <='1';								
									 i_addr_cnt<=COLUMN_TOTAL-1;
 	 						       state<=VPt;
							   end if;
    					      i_row_cnt<=0;						    
  					         i_col_cnt<=1;
   							OPCODE<="001";
      						s_CSEL <= (others => '1');--Enble BRAM for Saving multiplication result.		
      						WE <= '0';

						elsif mode = "001" then
						      Unloading_Count:=1;
--     						   Write_SHFT <= '0';
						      i_row_cnt<=1;						    
  					         i_col_cnt<=0;
   							OPCODE<="001";
      						s_CSEL <= (others => '1');--Enble BRAM for Saving multiplication result.		
      						WE <= '0';
								if G='0' then
								   i_addr_cnt<=COLUMN_TOTAL-1;
									Read_SHFT <='1';
						         state<=PV;
								else
									i_addr_cnt<=1;
									Read_SHFT <='0';
						         state<=PtV;
								end if;
						elsif mode = "010" then
						      Unloading_Count:=1;
--     						   Write_SHFT <= '0';
						      Read_SHFT <='0';
    					      i_row_cnt<=0;						    
  					         i_col_cnt<=0;
   							OPCODE<="001";
      						s_CSEL <= (others => '1');--Enble BRAM for Saving multiplication result.		
      						WE <= '1';
								i_addr_cnt<=0;
						      state<=SSP;
						else
						   Unloading_Count:=COLUMN_TOTAL;
--						   Write_SHFT <= '0';
					      i_addr_cnt<=0;
					      i_row_cnt<=0;
					      i_col_cnt<=0;
  						   s_CSEL <= (0=>'1',others => '0');--Enble BRAM for Saving multiplication result.		
  						   WE <= '1';
						   if P='0' then
						      Read_SHFT <='0';
						   else
						      Read_SHFT <='1';
						   end if;   
				         if (P='0') then
						  	   if G='0' then
						   	   state<=PpG;
						      else
							      state<=PpGt;
					 	      end if;
					     else
						     if G='0' then
							     state<=PtpG;
					        else
							     state<=PtpGt;
						     end if;
                    end if;
						  if mode="100" then
						     OPCODE<="010";
   					   elsif mode="101" then
		     				   OPCODE<="100";
      					elsif mode="110" then
   						    OPCODE<="101";
	      				elsif mode="111" then
			   			    OPCODE<="001";
          				end if;		
                  end if;
					end if;
				when PG =>
							v_OPCODE :="011";
							WE <='0';					
							if v_OP_DONE = '0' then
								if (i_row_cnt=COLUMN_TOTAL-1) then				---G row
									i_row_cnt<=0;
								else
									i_row_cnt<=i_row_cnt+1;
								end if;
								if i_addr_cnt=0 then									--- P addr
									i_addr_cnt<=COLUMN_TOTAL-1;
								else
									i_addr_cnt<=i_addr_cnt-1;
								end if;
								if i= COLUMN_TOTAL-1 then 		-- full round
									j:=j+1;
									i_col_cnt<=i_col_cnt+1;			-- next G column
									i_row_cnt <= 1 + j;	-- nwzr G Row
									
									if j = COLUMN_TOTAL then -- Check G Col
										i_col_cnt<=j-1;
									end if;
									if ((i_row_cnt+1)>=COLUMN_TOTAL-1) then		-- G row
										i_row_cnt<=0;
									end if;
									i_addr_cnt<=COLUMN_TOTAL-1-j;
									i:=0;
									v_OPCODE := "001";
								else
									i:=i+1;
									if i = COLUMN_TOTAL-1 then
										WE<='1';								
									end if;
										v_OPCODE := "011";-- make parameterizable latter.
								end if;
								if j= COLUMN_TOTAL then 
									v_OP_DONE :='1';
									v_OPCODE :="111";							
								else
									v_OP_DONE :='0';						
								end if;
							else
								if v_OP_DONE = '1' and cnt_delay_ready = (PIPELINE_DELAY + COLUMN_TOTAL*COLUMN_TOTAL) then -- wait until the results are saved in BRAM.--then
									state<=DONE;
									v_OPCODE := "111";
								end if;
							end if;
							OPCODE<= v_OPCODE; --"111";
					when PGt=>
							v_OPCODE :="011";
							WE <='0';					
							if v_OP_DONE = '0' then
								if (i_col_cnt=COLUMN_TOTAL-1) then				---G col
									i_col_cnt<=0;
								else
									i_col_cnt<=i_col_cnt+1;
								end if;
								if i_addr_cnt=0 then									--- P addr
									i_addr_cnt<=COLUMN_TOTAL-1;
								else
									i_addr_cnt<=i_addr_cnt-1;
								end if;
								if i= COLUMN_TOTAL-1 then 		-- full round 
									j:=j+1;							
									i_col_cnt <= 1 + j;	--  G Col
									i_row_cnt<=i_row_cnt+1;			-- next G row
									if j = COLUMN_TOTAL then -- Check G Row
										i_row_cnt<=j-1;
									end if;
									if ((i_col_cnt+1)>=COLUMN_TOTAL-1) then		-- G Column
										i_col_cnt<=0;
									end if;
									i_addr_cnt<=COLUMN_TOTAL-1-j;
									i:=0;
									v_OPCODE := "001";
								else
									i:=i+1;
									if i = COLUMN_TOTAL-1 then
										WE<='1';								
									end if;
									v_OPCODE := "011";-- make parameterizable latter.					
								end if;
								if j= COLUMN_TOTAL then 
									v_OP_DONE :='1';
									v_OPCODE :="111";							
								else
									v_OP_DONE :='0';
								end if;
							else
								if v_OP_DONE = '1' and cnt_delay_ready = (PIPELINE_DELAY + COLUMN_TOTAL*COLUMN_TOTAL) then -- wait until the results are saved in BRAM.--then
									state<=DONE;
									v_OPCODE := "111";
								end if;
							end if;
							OPCODE<= v_OPCODE; --"111";
					when PtG=>
							v_OPCODE :="011";
							WE <='0';					
							if v_OP_DONE = '0' then
								if (i_row_cnt=COLUMN_TOTAL-1) then				---G row
									i_row_cnt<=0;
								else
									i_row_cnt<=i_row_cnt+1;
								end if;
								if i_addr_cnt=COLUMN_TOTAL-1 then									--- P addr
									i_addr_cnt<=0;
								else
									i_addr_cnt<=i_addr_cnt+1;
								end if;
								if i= COLUMN_TOTAL-1 then 		-- full round 
									j:=j+1;
									i_col_cnt<=i_col_cnt+1;			-- next G column
									i_row_cnt <= 1 + j;	-- G Row
									if j = COLUMN_TOTAL then -- Check G Col
										i_col_cnt<=j-1;
									end if;
									if ((i_row_cnt+1)>=COLUMN_TOTAL-1) then		-- G row
										i_row_cnt<=0;
									end if;
									if j=COLUMN_TOTAL-1 then									--- P addr
										i_addr_cnt<=0;
									else
										i_addr_cnt<=j+1;
									end if;
									i:=0;
									v_OPCODE := "001";
								else
									i:=i+1;
									if i = COLUMN_TOTAL-1 then
										WE<='1';								
									end if;
										v_OPCODE := "011";-- make parameterizable latter.
								end if;
								if j= COLUMN_TOTAL then 
									v_OP_DONE :='1';
									v_OPCODE :="111";
								else
									v_OP_DONE :='0';
								end if;
							else
								if v_OP_DONE = '1' and cnt_delay_ready = (PIPELINE_DELAY + COLUMN_TOTAL*COLUMN_TOTAL) then -- wait until results are saved in BRAM.--then
									state<=DONE;
									v_OPCODE := "111";
								end if;
							end if;
							OPCODE<= v_OPCODE; --"111";
					when PtGt =>
							v_OPCODE :="011";
							WE <='0';					
							if v_OP_DONE = '0' then
								if (i_col_cnt=COLUMN_TOTAL-1) then---G col
									if i /= COLUMN_TOTAL-1 then
										i_col_cnt<=0;
									end if;
								else
									if i /= COLUMN_TOTAL-1 then
										i_col_cnt<=i_col_cnt+1;
									end if;
								end if;
								if i_addr_cnt=COLUMN_TOTAL-1 then -- P addr
									if i /= COLUMN_TOTAL-1 then -- Do not reset count if a sub-round is finished. A sub round is finished when the variable 'i' is the last address (i = COLUMN_TOTAL-1). For example if COLUMN_TOTAL = 3 then if the round address ended with 
										i_addr_cnt<=0;			-- the last address (COLUMN_TOTAl-1 => 2), like this 0,1,[2] the next round will continue from [2],0,1 instead of [0],1,2. So the address pattern is like this 1,2,0:0,1,2:2,0,1
									end if;						-- We begin a new round with the last address of the previous sub-round.
								else							
									if i /= COLUMN_TOTAL-1 then -- Increase count as long as the sub-round is not finished.				
										i_addr_cnt <= i_addr_cnt+1;
									end if;
								end if;
								if i= COLUMN_TOTAL-1 then-- full round 
									j:=j+1;
									i_row_cnt<=i_row_cnt+1;-- next G row
									if i_row_cnt = 0 then -- Check G Row
										i_row_cnt<=COLUMN_TOTAL-1;
									else
										i_row_cnt <= i_row_cnt-1;
									end if;
									i:=0;
									v_OPCODE := "001";
								else
									i:=i+1;
									if i = COLUMN_TOTAL-1 then
										WE<='1';								
									end if;
									v_OPCODE := "011";-- make parameterizable latter.					
								end if;
								if j= COLUMN_TOTAL then 
									v_OP_DONE :='1';
									v_OPCODE :="111";
								else
									v_OP_DONE :='0';
								end if;
							else
								if v_OP_DONE = '1' and cnt_delay_ready = (PIPELINE_DELAY + COLUMN_TOTAL*COLUMN_TOTAL) then -- wait until gets to BRAM.--then
									state<=DONE;
									v_OPCODE := "111";
								end if;
							end if;
							OPCODE<= v_OPCODE; --"111";
-------------------------------------------------------------------------------------------------
					when VP =>
							v_OPCODE :="011";
							WE <='0';					
							if v_OP_DONE = '0' then
								if i= COLUMN_TOTAL-1 then-- full round 
									j:=j+1;
									i:=0;
									v_OPCODE := "001";
										i_addr_cnt<=0;			-- the last address (COLUMN_TOTAl-1 => 2), like this 0,1,[2] the next round will continue from [2],0,1 instead of [0],1,2. So the address pattern is like this 1,2,0:0,1,2:2,0,1

								else
									i:=i+1;

									if (i_col_cnt=COLUMN_TOTAL-1) then---G col
								   	i_col_cnt<=0;
								   else
								      i_col_cnt<=i_col_cnt+1;
								  end if;


									if i = COLUMN_TOTAL-1 then
										WE<='1';								
									end if;
								  if i_addr_cnt=COLUMN_TOTAL-1 then -- P addr
										i_addr_cnt<=0;			-- the last address (COLUMN_TOTAl-1 => 2), like this 0,1,[2] the next round will continue from [2],0,1 instead of [0],1,2. So the address pattern is like this 1,2,0:0,1,2:2,0,1
								  else							
										i_addr_cnt <= i_addr_cnt+1;
								 end if;

--																			i_addr_cnt <= i_addr_cnt+1;

									v_OPCODE := "011";-- make parameterizable latter.					
								end if;
								if j= 1 then 
									v_OP_DONE :='1';
									v_OPCODE :="111";
								else
									v_OP_DONE :='0';
								end if;
							else
								if v_OP_DONE = '1' and cnt_delay_ready = (PIPELINE_DELAY + COLUMN_TOTAL*COLUMN_TOTAL) then -- wait until gets to BRAM.--then
									state<=DONE;
									v_OPCODE := "111";
								end if;
							end if;
							OPCODE<= v_OPCODE; --"111";

-------------------------------------------------------------------------------------------------
					when VPt =>
							v_OPCODE :="011";
							WE <='0';					
							if v_OP_DONE = '0' then
								if i= COLUMN_TOTAL-1 then-- full round 
									j:=j+1;
									i:=0;
									v_OPCODE := "001";
								--		i_addr_cnt<=0;			-- the last address (COLUMN_TOTAl-1 => 2), like this 0,1,[2] the next round will continue from [2],0,1 instead of [0],1,2. So the address pattern is like this 1,2,0:0,1,2:2,0,1

								else
									i:=i+1;

									if (i_col_cnt=COLUMN_TOTAL-1) then---G col
								   	i_col_cnt<=0;
								   else
								      i_col_cnt<=i_col_cnt+1;
								  end if;


									if i = COLUMN_TOTAL-1 then
										WE<='1';								
									end if;
								  if i_addr_cnt=0 then -- P addr
										i_addr_cnt<=COLUMN_TOTAL-1;			-- the last address (COLUMN_TOTAl-1 => 2), like this 0,1,[2] the next round will continue from [2],0,1 instead of [0],1,2. So the address pattern is like this 1,2,0:0,1,2:2,0,1
								  else							
										i_addr_cnt <= i_addr_cnt-1;
								 end if;
									v_OPCODE := "011";-- make parameterizable latter.					
								end if;
								if j= 1 then 
									v_OP_DONE :='1';
									v_OPCODE :="111";
								else
									v_OP_DONE :='0';
								end if;
							else
								if v_OP_DONE = '1' and cnt_delay_ready = (PIPELINE_DELAY + COLUMN_TOTAL) then -- wait until gets to BRAM.--then
									state<=DONE;
									v_OPCODE := "111";
								end if;
							end if;
							OPCODE<= v_OPCODE; --"111";

-------------------------------------------------------------------------------------------------

					when PV =>
							v_OPCODE :="011";
							WE <='0';					
							if v_OP_DONE = '0' then
								if i= COLUMN_TOTAL-1 then-- full round 
									j:=j+1;
									i:=0;
									v_OPCODE := "001";
										i_addr_cnt<=0;			-- the last address (COLUMN_TOTAl-1 => 2), like this 0,1,[2] the next round will continue from [2],0,1 instead of [0],1,2. So the address pattern is like this 1,2,0:0,1,2:2,0,1

								else
									i:=i+1;

									if (i_row_cnt=COLUMN_TOTAL-1) then---G col
								   	i_row_cnt<=0;
								   else
								      i_row_cnt<=i_row_cnt+1;
								  end if;


									if i = COLUMN_TOTAL-1 then
										WE<='1';								
									end if;
								  if i_addr_cnt=0 then -- P addr
										i_addr_cnt<=COLUMN_TOTAL-1;			-- the last address (COLUMN_TOTAl-1 => 2), like this 0,1,[2] the next round will continue from [2],0,1 instead of [0],1,2. So the address pattern is like this 1,2,0:0,1,2:2,0,1
								  else							
										i_addr_cnt <= i_addr_cnt-1;
								 end if;

--																			i_addr_cnt <= i_addr_cnt+1;

									v_OPCODE := "011";-- make parameterizable latter.					
								end if;
								if j= 1 then 
									v_OP_DONE :='1';
									v_OPCODE :="111";
								else
									v_OP_DONE :='0';
								end if;
							else
								if v_OP_DONE = '1' and cnt_delay_ready = (PIPELINE_DELAY + COLUMN_TOTAL*COLUMN_TOTAL) then -- wait until gets to BRAM.--then
									state<=DONE;
									v_OPCODE := "111";
								end if;
							end if;
							OPCODE<= v_OPCODE; --"111";
-------------------------------------------------------------------------------------------------
					when PtV =>
							v_OPCODE :="011";
							WE <='0';					
							if v_OP_DONE = '0' then
								if i= COLUMN_TOTAL-1 then-- full round 
									j:=j+1;
									i:=0;
									v_OPCODE := "001";
										i_addr_cnt<=0;			-- the last address (COLUMN_TOTAl-1 => 2), like this 0,1,[2] the next round will continue from [2],0,1 instead of [0],1,2. So the address pattern is like this 1,2,0:0,1,2:2,0,1

								else
									i:=i+1;
									if (i_row_cnt=COLUMN_TOTAL-1) then---G col
								   	i_row_cnt<=0;
								   else
								      i_row_cnt<=i_row_cnt+1;
								  end if;


									if i = COLUMN_TOTAL-1 then
										WE<='1';								
									end if;
								  if i_addr_cnt=COLUMN_TOTAL-1 then -- P addr
										i_addr_cnt<=0;			-- the last address (COLUMN_TOTAl-1 => 2), like this 0,1,[2] the next round will continue from [2],0,1 instead of [0],1,2. So the address pattern is like this 1,2,0:0,1,2:2,0,1
								  else							
										i_addr_cnt <= i_addr_cnt+1;
								 end if;

--																			i_addr_cnt <= i_addr_cnt+1;

									v_OPCODE := "011";-- make parameterizable latter.					
								end if;
								if j= 1 then 
									v_OP_DONE :='1';
									v_OPCODE :="111";
								else
									v_OP_DONE :='0';
								end if;
							else
								if v_OP_DONE = '1' and cnt_delay_ready = (PIPELINE_DELAY + COLUMN_TOTAL*COLUMN_TOTAL) then -- wait until gets to BRAM.--then
									state<=DONE;
									v_OPCODE := "111";
								end if;
							end if;
							OPCODE<= v_OPCODE; --"111";
-------------------------------------------------------------------------------------------------

					when SSP =>
							if v_OP_DONE = '1' then
							   WE <='0';
								s_CSEL <= (others => '1');--Enble BRAM for Saving multiplication result.		
							end if;
							if v_OP_DONE = '0' then 
								WE <='1';					
--								if i= COLUMN_TOTAL-1 then-- full round 
									j:=j+1;
									if i_addr_cnt/=COLUMN_TOTAL-1 then -- P addr
									   i_addr_cnt<=j;
                           end if;
									i:=0;
--								else
--									i:=i+1;
--								end if;
   							if j= COLUMN_TOTAL then 
									s_CSEL<=(others => '0');
								else 
    							      s_CSEL <= s_CSEL(s_CSEL'length - 2 downto 0) & s_CSEL(s_CSEL'length - 1); --rol 1 (shift one place left with roll over).
								end if;	

								if j= COLUMN_TOTAL then 
									v_OP_DONE :='1';
									v_OPCODE :="111";
								else
									v_OP_DONE :='0';
								end if;
							else
								if v_OP_DONE = '1' and cnt_delay_ready = (PIPELINE_DELAY + COLUMN_TOTAL*COLUMN_TOTAL) then -- wait until gets to BRAM.--then
									WE<='0';								
									state<=DONE;
								end if;
							end if;
-------------------------------------------------------------------------------------------------
					when PpG =>
							if v_OP_DONE = '1' then
							   WE <='0';
								s_CSEL <= (others => '1');--Enble BRAM for Saving multiplication result.		
>>>>>>> 18f3147bfef5a25930a06fdd3be25caa8f4ca9b6
							end if;
							

						end if;
-----------------------------------------------------------------------------------------------
					when PG_state =>
					  if OP_DONE_t(2) = '1' then
					     state <= DONE_state;
					  else
					     state <= PG_state;
					  end if;											
-----------------------------------------------------------------------------------------------
					when SSP_state =>
					  if OP_DONE_t(0) = '1' then
					     state <= DONE_state;
					  else
					     state <= SSP_state;
					  end if;					
-----------------------------------------------------------------------------------------------
					when PpG_state =>
					  if OP_DONE_t(1) = '1' then
					     state <= DONE_state;
					  else
					     state <= PpG_state;
					  end if;					
-------------------------------------------------------------------------------------------------
					when VP_state =>
					  if OP_DONE_t(3) = '1' then
					     state <= DONE_state;
					  else
					     state <= VP_state;
					  end if;					
-------------------------------------------------------------------------------------------------

					when DONE_state =>
							G_EN <= '0';
							if UN_LOAD = '1' then
					         EN<="0000010";
   							state <= UNLOAD_state;	
							end if;
					when others =>		            
					  if Unload_OP_DONE = '1' then
    					  EN<="0000000";
					  end if;
               end case;					  
------------------------------------------------------------------
	end if;
end if;

end process;

multiplexing: process(CLK)
begin
if rising_edge(CLK) then
Read_ADDR<=Read_ADDR_1;
end if;
end process;

			READY<=Load_READY when(state=LOADING_state) else
			       Unload_READY when(state= UNLOAD_state) else '0';
			UN_LOADING_DONE<=Unload_OP_DONE;
		   LOADING_DONE <= Load_OP_DONE;
		
   		CSEL <= CSEL_t(0)   when (state= LOADING_state) else
                 CSEL_t(1)   when (state= UNLOAD_state) else
                 CSEL_t(2)   when (state= SSP_state) else
            	  CSEL_t(3)   when (state= PpG_state) else
					  CSEL_t(4)   when (state= PG_state) else
					  CSEL_t(5)   when (state= VP_state) else(others => '0'); 
			
          Write_ADDR <= Write_ADDR_t(0)  when (state= LOADING_state) else
                        Write_ADDR_t(1)  when (state= SSP_state) else
                        Write_ADDR_t(2)  when (state= PpG_state) else
 								Write_ADDR_t(3)  when (state= PG_state) else
								(others => '0')  when (state= VP_state) else(others => '1'); 
                        
          Read_ADDR_1 <=  Read_ADDR_t(0)  when (state= UNLOAD_state) else
                        Write_ADDR_t(1)  when (state= SSP_state) else 
								Read_ADDR_t(1)  when (state= PpG_state) else
								Read_ADDR_t(2)  when (state= PG_state) else
								Read_ADDR_t(3)  when (state= VP_state) else(others => '1'); 

          G_ROW    <=   G_ROW_t(0)   	 when (state= PpG_state) else
 			               G_ROW_t(1)   	 when (state= PG_state) else
								G_ROW_t(2)   	 when (state= VP_state) else(others => '0'); 

          G_COLUMN <=   G_COLUMN_t(0)	 when (state= PpG_state) else
			               G_COLUMN_t(1)	 when (state= PG_state) else
								G_COLUMN_t(2)	 when (state= VP_state) else(others => '0'); 

          WE       <=   WE_t(0)         when (state= LOADING_state) else
                        WE_t(1)	       when (state= SSP_state) else
								WE_t(2)	       when (state= PpG_state) else
                        WE_t(3)	       when (state= PG_state) else
								WE_t(4)	       when (state= VP_state) else'0'; 

        Write_SHFT <= '1' when (state= PG_state) else '0'; 
							--	Write_SHFT_t(0)   when (state= PpG_state) else '0'; 

        Read_SHFT  <= Read_SHFT_t(0) when (state= PpG_state) else
							 Read_SHFT_t(1)  when (state= PG_state) else
 							 Read_SHFT_t(2)  when (state= VP_state) else'0'; 
 
          OPCODE   <=   "000"          when (state= LOADING_state) else
                        OPCODE_t(0)     when (state= UNLOAD_state) else
                        OPCODE_t(1)     when (state= SSP_state) else
                        OPCODE_t(2)     when (state= PpG_state) else
              				OPCODE_t(3)     when (state= PG_state) else
								OPCODE_t(4)     when (state= VP_state)else (others => '1');								

          OP_DONE  <=   OP_DONE_t(0)     when (state= SSP_state) else
                        OP_DONE_t(1)     when (state= PpG_state) else
    							OP_DONE_t(2)     when (state= PG_state) else
								OP_DONE_t(3)     when (state= VP_state) else'0';								

  		
-----------------------------------------------------------
end Behavioral;

