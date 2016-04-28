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
						elsif UN_LOAD = '1' then
					         EN<="0000010";
   							state <= UNLOAD_state;	
						else
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

