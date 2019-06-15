-- MIPS processor
library IEEE; use IEEE.STD_LOGIC_1164.all;
entity mips is 
    port(clk, reset:        in STD_LOGIC);
end;

architecture struct of mips is
    component controller
        port(op, funct:             in STD_LOGIC_VECTOR(5 downto 0);
             zero:                  in STD_LOGIC;
             memtoreg, memwrite:    out STD_LOGIC;
             branchandzero, alusrc: out STD_LOGIC;
             regdst, regwrite:      out STD_LOGIC;
             jump:                  out STD_LOGIC_VECTOR(1 downto 0);
             alucontrol:            out STD_LOGIC_VECTOR(2 downto 0));
    end component;
    component datapath
        port(clk, reset:        in STD_LOGIC;
             memtoreg, branchandzero:   in STD_LOGIC;
             alusrc, regdst:    in STD_LOGIC;
             regwrite:          in STD_LOGIC;
             jump:              in STD_LOGIC_VECTOR(1 downto 0);
             memwrite:          in STD_LOGIC;
             alucontrol:        in STD_LOGIC_VECTOR(2 downto 0);
             zero:              out STD_LOGIC;
             instr:             out STD_LOGIC_VECTOR(31 downto 0));
    end component;
    signal memtoreg, memwrite, branchandzero, alusrc, regdst, regwrite, zero: STD_LOGIC := '0';
    signal jump: STD_LOGIC_VECTOR(1 downto 0);
    signal alucontrol: STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal instr: STD_LOGIC_VECTOR(31 downto 0);
begin
    cont: controller port map(instr(31 downto 26), instr(5 downto 0), zero, memtoreg, memwrite, branchandzero, alusrc, regdst, regwrite, jump, alucontrol);
    dp: datapath port map(clk, reset, memtoreg, branchandzero, alusrc, regdst, regwrite, jump, memwrite, alucontrol, zero, instr);
end;

-- Controller
library IEEE; use IEEE.STD_LOGIC_1164.all; use IEEE.NUMERIC_STD.all;
entity controller is
    port(op, funct:             in STD_LOGIC_VECTOR(5 downto 0);
         zero:                  in STD_LOGIC;
         memtoreg, memwrite:    out STD_LOGIC;
         branchandzero, alusrc: out STD_LOGIC;
         regdst, regwrite:      out STD_LOGIC;
         jump:		            out STD_LOGIC_VECTOR(1 downto 0);
         alucontrol:            out STD_LOGIC_VECTOR(2 downto 0));
end;

architecture struct of controller is
    signal branch:  STD_LOGIC := '0';
    signal controls: STD_LOGIC_VECTOR(9 downto 0) := "0000000000";
begin    
    process(op, funct) begin
		-- TODO: Set controll signals accordingly. Use - to denote don't cares and 0 or 1 if the value is fixed.
        case op is
            when "000000" => -- R-Type
                case funct is
                    when "100000" => controls <= "0100000010"; -- ADD
                    when "100010" => controls <= "0110000010"; -- SUB
                    when "100100" => controls <= "0000000010"; -- AND
                    when "100101" => controls <= "1000000010"; -- OR
                    when "101010" => controls <= "1110000010"; -- SLT
                    when "001000" => controls <= "0111000000"; -- JR
                    when others   => controls <= "----------";
                end case;
            when "100011" => controls <= "0100000011"; -- LW
            when "100000" => controls <= "0100000011"; -- LB
            when "101011" => controls <= "0100010100"; -- SW
            when "101000" => controls <= "0100010100"; -- SB
            when "000100" => controls <= "1100001000"; -- BEQ
            when "000101" => controls <= "1100001000"; -- BNE
            when "001000" => controls <= "0000000101"; -- ADDI
            when "001010" => controls <= "1110000101"; -- SLTI
            when "000010" => controls <= "0001000000"; -- J
            when "000011" => controls <= "0001000000"; -- JAL
            when others   => controls <= "----------"; -- illegal op
        end case;
    end process;

    regwrite     <= controls(9);
    regdst       <= controls(8);
    alusrc       <= controls(7);
    branch       <= controls(6);
    memwrite     <= controls(5);
    memtoreg     <= controls(4);
    jump         <= controls(3 downto 2); -- TODO: Think again which controls have to be sent.
    alucontrol   <= controls(2 downto 0);

    branchandzero <= branch and zero;
end;

-- datapath
library IEEE; use IEEE.STD_LOGIC_1164.all; use IEEE.NUMERIC_STD.all;
entity datapath is
    port(clk, reset:        in STD_LOGIC;
         memtoreg, branchandzero:   in STD_LOGIC;
         alusrc, regdst:    in STD_LOGIC;
         regwrite:          in STD_LOGIC;
         jump:              in STD_LOGIC_VECTOR(1 downto 0);
         memwrite:          in STD_LOGIC;
         alucontrol:        in STD_LOGIC_VECTOR(2 downto 0);
         zero:              out STD_LOGIC;
         instr:             out STD_LOGIC_VECTOR(31 downto 0));
end;


-- TODO: Implement datapath of the MIPS processor
-- Important: the instance of the component regfile must be named rf. Otherwise, the testbench cannot read out the final results.
-- Important: the instance of the component dmem must be named dmem1. Otherwise, the testbench cannot read out the final results.
-- Put all parts together, the controller is already defined above, combine all other contents.
architecture datapath_architecture of datapath is
    component regfile   -- Component Register File.
        port(clk:           in STD_LOGIC;
        we3:           in STD_LOGIC;
        ra1, ra2, wa3: in STD_LOGIC_VECTOR(4 downto 0);
        wd3:           in STD_LOGIC_VECTOR(31 downto 0);
        rd1, rd2:      out STD_LOGIC_VECTOR(31 downto 0));
    end component;
    component dmem      -- Component Data Memory.
        port(clk, we: in STD_LOGIC;
            a, wd:   in STD_LOGIC_VECTOR(31 downto 0);
            rd:      out STD_LOGIC_VECTOR(31 downto 0));
    end component;  
    component imem      -- Component Instruction Memory.
        port(a:  in STD_LOGIC_VECTOR(31 downto 0);
            rd: out STD_LOGIC_VECTOR(31 downto 0));
    end component;  
    component alu      -- Component ALU.
        port(a, b:          in STD_LOGIC_VECTOR(31 downto 0);
            alucontrol:    in STD_LOGIC_VECTOR(2 downto 0);
            result:        buffer STD_LOGIC_VECTOR(31 downto 0);
            zero:          out STD_LOGIC);
    end component;
    component mux4      -- Component MUX4.
        generic(width: integer);
        port(d0, d1, d2, d3:    in STD_LOGIC_VECTOR(width-1 downto 0);
            s:         in STD_LOGIC_VECTOR(1 downto 0);
            y:         out STD_LOGIC_VECTOR(width-1 downto 0));
    end component;  
    component mux2      -- Component MUX2.
        generic(width: integer);
        port(d0, d1:    in STD_LOGIC_VECTOR(width-1 downto 0);
            s:         in STD_LOGIC;
            y:         out STD_LOGIC_VECTOR(width-1 downto 0));
    end component;  
    component ff
        generic(width: integer);
        port(clk, reset: in STD_LOGIC;
        d:          in STD_LOGIC_VECTOR(width-1 downto 0);
        q:          out STD_LOGIC_VECTOR(width-1 downto 0));
    end component;
    -- The destination register coming from the MUX below the Register File.
    signal destinationreg: STD_LOGIC_VECTOR(4 downto 0);
    -- The result coming from the MUX on the right.
    signal result: STD_LOGIC_VECTOR(31 downto 0);
    -- The srcA coming from the Register File into the ALU.
    signal srca : STD_LOGIC_VECTOR(31 downto 0);
    -- The srcB coming from the MUX controlled by ALUSrc.
    signal srcb : STD_LOGIC_VECTOR(31 downto 0);
    -- The writedata coming from the Register File.
    signal writedata : STD_LOGIC_VECTOR(31 downto 0);
    -- The aluresult coming from the ALU.
    signal aluresult : STD_LOGIC_VECTOR(31 downto 0);
    -- The readdata coming from the Data Memory.
    signal readdata : STD_LOGIC_VECTOR(31 downto 0);
    -- The programm counter coming from the PC flip flop memory.
    signal pc : STD_LOGIC_VECTOR(31 downto 0);
    -- The next address coming from the adder below Instruction Memory.
    signal nextaddress : STD_LOGIC_VECTOR(31 downto 0);
    -- Output from the MUX2_1.
    signal mux2_1_output : STD_LOGIC_VECTOR(31 downto 0);
    -- Output from the MUX4_1.
    signal mux4_1_output : STD_LOGIC_VECTOR(31 downto 0);
    -- Output from the MUX4_3.
    signal mux4_3_output : STD_LOGIC;
    -- The jump address comin the shifter below.
    signal jumpaddress : STD_LOGIC_VECTOR(31 downto 0);
    -- Definition of an null address.
    signal emptyaddress: STD_LOGIC_VECTOR(31 downto 0);
begin -- The definitions below are from left to right on the processor sheet.
    -- MUX2 most left.
    mux2_1 : mux2 generic map (width => 32) port map(d0 => nextaddress, d1 => result, s => mux4_3_output, y => mux2_1_output);
    -- MUX4 most left.
    mux4_1 : mux4 generic map (width => 32) port map(d0 => mux2_1_output, d1 => jumpaddress, d2 => srca, d3 => emptyaddress, s => jump, y => mux4_1_output);
    -- Programm Counter 31 Bit Flip Flop.
    pc1 : ff generic map (width => 32) port map(clk => clk, reset => reset, d => mux4_1_output, q => pc);
    -- Register File.
    rf: regfile port map(clk => clk, we3 => regwrite, ra1 => instr(25 downto 21), ra2 => instr(20 downto 16), wa3 => destinationreg, wd3 => result, rd1 => srca, rd2 => writedata);
    -- Data Memory.
    dmem1: dmem port map(clk => clk, we => memwrite, a => aluresult, wd => writedata, rd => readdata);
    -- Instruction Memory.
    imem1: imem port map(a => pc, rd => instr);
    -- ALU.
    alu1 : alu port map(a => srca, b => srcb, alucontrol => alucontrol, zero => zero);
end;

-- testbench
library IEEE; use IEEE.STD_LOGIC_1164.all; use IEEE.NUMERIC_STD.all; use STD.ENV.STOP;
entity testbench is
end;

architecture test of testbench is
    component mips
        port(clk, reset: in STD_LOGIC);
    end component;
    signal clk, reset:    STD_LOGIC := '0';
    type ramtype is array(31 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
    type ramtype2 is array(127 downto 64) of STD_LOGIC_VECTOR(31 downto 0);
begin
    -- initiate device to be tested
    dut: mips port map(clk, reset);

    -- generate clock with 10 ns period
    process begin
		for i in  1 to 1000 loop 
	        clk <= '1';	
	        wait for 5 ps;
	        clk <= '0';
    	    wait for 5 ps;
		end loop;
		report "Simulation ran into timeout of 1000 clock cycles" severity error;
		wait;
    end process;

    -- generate reset
    process begin
        reset <= '1';
        wait for 22 ps;
        reset <= '0';
        wait;
    end process;

    process(clk) is
        variable mem: ramtype;
        variable dmem: ramtype2;
        variable sig1,sig2,sig3: integer;
        variable pc: integer;
        variable instr: STD_LOGIC_VECTOR(31 downto 0);
        variable str: string(1 to 28);
    begin
        if (clk'event and clk='0') then
			instr := <<signal dut.instr : STD_LOGIC_VECTOR(31 downto 0)>>;
            if(instr = x"0000000c") then
                mem := (<<signal dut.dp.rf.mem : ramtype>>);
                sig1 := to_integer(signed(mem(16)));
                dmem := (<<signal dut.dp.dmem1.mem : ramtype2>>);
    
                str(1) := character'val(to_integer(signed(dmem(64)(7 downto 0))));
                str(2) := character'val(to_integer(signed(dmem(64)(15 downto 8))));
                str(3) := character'val(to_integer(signed(dmem(64)(23 downto 16))));
                str(4) := character'val(to_integer(signed(dmem(64)(31 downto 24))));

                str(5) := character'val(to_integer(signed(dmem(65)(7 downto 0))));
                str(6) := character'val(to_integer(signed(dmem(65)(15 downto 8))));
                str(7) := character'val(to_integer(signed(dmem(65)(23 downto 16))));
                str(8) := character'val(to_integer(signed(dmem(65)(31 downto 24))));

                str(9) := character'val(to_integer(signed(dmem(66)(7 downto 0))));
                str(10) := character'val(to_integer(signed(dmem(66)(15 downto 8))));
                str(11) := character'val(to_integer(signed(dmem(66)(23 downto 16))));
                str(12) := character'val(to_integer(signed(dmem(66)(31 downto 24))));

                str(13) := character'val(to_integer(signed(dmem(67)(7 downto 0))));
                str(14) := character'val(to_integer(signed(dmem(67)(15 downto 8))));
                str(15) := character'val(to_integer(signed(dmem(67)(23 downto 16))));
                str(16) := character'val(to_integer(signed(dmem(67)(31 downto 24))));
        
                str(17) := character'val(to_integer(signed(dmem(68)(7 downto 0))));
                str(18) := character'val(to_integer(signed(dmem(68)(15 downto 8))));
                str(19) := character'val(to_integer(signed(dmem(68)(23 downto 16))));
                str(20) := character'val(to_integer(signed(dmem(68)(31 downto 24))));

                str(21) := character'val(to_integer(signed(dmem(69)(7 downto 0))));
                str(22) := character'val(to_integer(signed(dmem(69)(15 downto 8))));
                str(23) := character'val(to_integer(signed(dmem(69)(23 downto 16))));
                str(24) := character'val(to_integer(signed(dmem(69)(31 downto 24))));

                str(25) := character'val(to_integer(signed(dmem(70)(7 downto 0))));
                str(26) := character'val(to_integer(signed(dmem(70)(15 downto 8))));
                str(27) := character'val(to_integer(signed(dmem(70)(23 downto 16))));
                str(28) := character'val(to_integer(signed(dmem(70)(31 downto 24))));

				report "Program terminated --- Results are:" & lf & "            Number of words in string: " & integer'image(sig1) & lf & "            Resulting string: " & str;
                stop;
            end if;
        end if;
    end process;
end;
