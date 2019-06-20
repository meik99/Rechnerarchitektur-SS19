-- MIPS processor
library IEEE; use IEEE.STD_LOGIC_1164.all;
entity mips is 
    port(clk, reset:        in STD_LOGIC);
end;

architecture struct of mips is
    component controller
        port(op, funct:             in STD_LOGIC_VECTOR(5 downto 0);
            zero:                   in STD_LOGIC;
            memtoreg:               out STD_LOGIC_VECTOR(1 downto 0);
            memwrite:               out STD_LOGIC;
            wordOrByte:             out STD_LOGIC;
            branch:                 out STD_LOGIC_VECTOR(1 downto 0);
            alusrc:                 out STD_LOGIC;
            regdst:                 out STD_LOGIC_VECTOR(1 downto 0);
            regwrite:               out STD_LOGIC;
            jump:		            out STD_LOGIC_VECTOR(1 downto 0);
            alucontrol:             out STD_LOGIC_VECTOR(2 downto 0));
    end component;
    component datapath
        port(clk, reset:        in STD_LOGIC;
            memtoreg:          in STD_LOGIC_VECTOR(1 downto 0);
            branch:            in STD_LOGIC_VECTOR(1 downto 0);
            alusrc:            in STD_LOGIC;
            regdst:            in STD_LOGIC_VECTOR(1 downto 0);
            regwrite:          in STD_LOGIC;
            jump:              in STD_LOGIC_VECTOR(1 downto 0);
            memwrite:          in STD_LOGIC;
            wordOrByte:        in STD_LOGIC;
            alucontrol:        in STD_LOGIC_VECTOR(2 downto 0);
            zero:              out STD_LOGIC;
            instr:             out STD_LOGIC_VECTOR(31 downto 0));
    end component;
    signal memwrite, wordOrByte, alusrc, regwrite, zero: STD_LOGIC := '0';
    signal memtoreg, jump, regdst, branch: STD_LOGIC_VECTOR(1 downto 0);
    signal alucontrol: STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal instr: STD_LOGIC_VECTOR(31 downto 0);
begin
    cont: controller port map(instr(31 downto 26), instr(5 downto 0), zero, memtoreg, memwrite, wordOrByte, branch, alusrc, regdst, regwrite, jump, alucontrol);
    dp: datapath port map(clk, reset, memtoreg, branch, alusrc, regdst, regwrite, jump, memwrite, wordOrByte, alucontrol, zero, instr);
end;

-- Controller
library IEEE; use IEEE.STD_LOGIC_1164.all; use IEEE.NUMERIC_STD.all;
entity controller is
    port(op, funct:             in STD_LOGIC_VECTOR(5 downto 0);
    zero:                   in STD_LOGIC;
    memtoreg:               out STD_LOGIC_VECTOR(1 downto 0);
    memwrite:               out STD_LOGIC;
    wordOrByte:             out STD_LOGIC;
    branch:                 out STD_LOGIC_VECTOR(1 downto 0);
    alusrc:                 out STD_LOGIC;
    regdst:                 out STD_LOGIC_VECTOR(1 downto 0);
    regwrite:               out STD_LOGIC;
    jump:		            out STD_LOGIC_VECTOR(1 downto 0);
    alucontrol:             out STD_LOGIC_VECTOR(2 downto 0));
end;

architecture struct of controller is
    signal controls: STD_LOGIC_VECTOR(14 downto 0) := "000000000000000";
begin    
    process(op, funct) begin
		-- TODO: Set controll signals accordingly. Use - to denote don't cares and 0 or 1 if the value is fixed.
        case op is
            when "000000" => -- R-Type
                case funct is
                    when "100000" => controls <= "1010000-0000010"; -- ADD
                    when "100010" => controls <= "1010000-0000110"; -- SUB
                    when "100100" => controls <= "1010000-0000000"; -- AND
                    when "100101" => controls <= "1010000-0000001"; -- OR
                    when "101010" => controls <= "1010000-0000111"; -- SLT
                    when "001000" => controls <= "0---000---10---"; -- JR
                    when others   => controls <= "---------------";
                end case;
            when "100011" => controls <= "100100000100010"; -- LW
            when "100000" => controls <= "100100010100010"; -- LB
            when "101011" => controls <= "0--10010--00010"; -- SW 
            when "101000" => controls <= "0--10011--00010"; -- SB
            when "000100" => controls <= "0--0010---00110"; -- BEQ
            when "000101" => controls <= "0--0100---00110"; -- BNE
            when "001000" => controls <= "1001000-0000010"; -- ADDI
            when "001010" => controls <= "1001000-0000111"; -- SLTI
            when "000010" => controls <= "0---000---01---"; -- J
            when "000011" => controls <= "110-000-1001---"; -- JAL  
            when others   => controls <= "---------------"; -- illegal op
        end case;
    end process;

    regwrite     <= controls(14);
    regdst       <= controls(13 downto 12); 
    alusrc       <= controls(11);
    branch       <= controls(10 downto 9); 
    memwrite     <= controls(8);
    wordOrByte   <= controls(7);
    memtoreg     <= controls(6 downto 5);
    jump         <= controls(4 downto 3);
    alucontrol   <= controls(2 downto 0); -- 000-AND, 001-OR, 010-ADD, 110-SUBSTRACT, 111-SETONLESSTHAN.
end;

-- datapath
library IEEE; use IEEE.STD_LOGIC_1164.all; use IEEE.NUMERIC_STD.all;
entity datapath is
    port(clk, reset:        in STD_LOGIC;
         memtoreg:          in STD_LOGIC_VECTOR(1 downto 0);
         branch:            in STD_LOGIC_VECTOR(1 downto 0);
         alusrc:            in STD_LOGIC;
         regdst:            in STD_LOGIC_VECTOR(1 downto 0);
         regwrite:          in STD_LOGIC;
         jump:              in STD_LOGIC_VECTOR(1 downto 0);
         memwrite:          in STD_LOGIC;
         wordOrByte:        in STD_LOGIC;
         alucontrol:        in STD_LOGIC_VECTOR(2 downto 0);
         zero:              out STD_LOGIC;
         instr:             out STD_LOGIC_VECTOR(31 downto 0));
end;


-- Implement datapath of the MIPS processor
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
    component ff        -- Component FlipFlop.
        generic(width: integer);
        port(clk, reset: in STD_LOGIC;
        d:          in STD_LOGIC_VECTOR(width-1 downto 0);
        q:          out STD_LOGIC_VECTOR(width-1 downto 0));
    end component;
    component adder     -- Component 32 Bit Adder.
        port(a, b: in STD_LOGIC_VECTOR(31 downto 0);
            cin: in STD_LOGIC;
            y:    buffer STD_LOGIC_VECTOR(31 downto 0));
    end component;
    component signext   -- Component Sign Extension.
        generic (width_in, width_out: integer);
        port(a: in STD_LOGIC_VECTOR(width_in-1  downto 0);
        y: out STD_LOGIC_VECTOR(width_out-1 downto 0));
    end component;
    component sl2    -- Component Shift 2 Left.
        port(a: in STD_LOGIC_VECTOR(31 downto 0);
            y: out STD_LOGIC_VECTOR(31 downto 0));
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
    -- The readdata (always whole word) coming from the Data Memory.
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
    -- Output from the ShiftLeft2.
    signal shiftLeft2_output : STD_LOGIC_VECTOR(31 downto 0);
    -- The jump address coming the shifter below.
    signal jumpaddress : STD_LOGIC_VECTOR(31 downto 0);
    -- The branch address coming the adder below.
    signal branchaddress : STD_LOGIC_VECTOR(31 downto 0);
    -- The immediate coming from sign extend below Register File.
    signal immediate: STD_LOGIC_VECTOR(31 downto 0);
    -- Temporary signals for mux 4_3.
    signal tmp1, tmp2: STD_LOGIC_VECTOR(0 downto 0);
    -- The single byte loaded for the load byte command
    signal loadbyte: STD_LOGIC_VECTOR(7 downto 0);
    -- The single byte extracted from the address for write byte
    signal writedataByte: STD_LOGIC_VECTOR(31 downto 0);
    -- Either writedata or writedataByte, depending in wordOrByte control flag
    signal writedataValue: STD_LOGIC_VECTOR(31 downto 0);
    -- Either a whole word or a single byte from the data memory.
    signal readdataresult : STD_LOGIC_VECTOR(31 downto 0);
begin -- The definitions below are from left to right on the processor sheedatapatht.
    -- MUX2 most left.
    mux2_1 : mux2 generic map (width => 32) port map(d0 => nextaddress, d1 => branchaddress, s => mux4_3_output, y => mux2_1_output);
    -- MUX4 most left.
    mux4_1 : mux4 generic map (width => 32) port map(d0 => mux2_1_output, d1 => jumpaddress, d2 => srca, d3 => srca, s => jump, y => mux4_1_output);
    -- Programm Counter 32 Bit Flip Flop.
    pc1 : ff generic map (width => 32) port map(clk => clk, reset => reset, d => mux4_1_output, q => pc);
    -- Instruction Memory.
    imem1: imem port map(a => pc, rd => instr);   
    -- Adder below Instruction Memory.
    adder1: adder port map(a => pc, b => std_logic_vector(to_unsigned(4, 32)), cin => '0', y => nextaddress);
    -- Register File.
    rf: regfile port map(clk => clk, we3 => regwrite, ra1 => instr(25 downto 21), ra2 => instr(20 downto 16), wa3 => destinationreg, wd3 => result, rd1 => srca, rd2 => writedata);
    -- Sign Extend below Register File.
    signext1 : signext generic map (width_in => 16, width_out => 32) port map (a => instr(15 downto 0), y => immediate);
    -- Shift left below Register File.
    shiftleft1: sl2 port map(a => (31 downto 26 => '0') & instr(25 downto 0), y => jumpaddress);    -- don't use the whole instruction here, as this would also contain the op code, only the last 26 bits are the address
    -- MUX4 right beside Register File.
    mux4_2 : mux4 generic map (width => 5) port map(d0 => instr(20 downto 16), d1 => instr(15 downto 11), d2 => std_logic_vector(to_unsigned(31, 5)), d3 => std_logic_vector(to_unsigned(0, 5)), s => regdst, y => destinationreg);
    -- MUX2 right beside Register File.
    mux2_2 : mux2 generic map (width => 32) port map(d0 => writedata, d1 => immediate, s => alusrc, y => srcb);
    -- ALU.
    alu1 : alu port map(a => srca, b => srcb, alucontrol => alucontrol, zero => zero, result => aluresult);
    -- Shift left below Register file.
    shiftLeft2: sl2 port map(a => immediate, y => shiftLeft2_output);
    -- Adder below ALU.
    adder2: adder port map(a => shiftLeft2_output, b => nextaddress, cin => '0', y => branchaddress);
    -- MUX4 above Data Memory.
    tmp1(0) <= zero;
    tmp2(0) <= NOT zero; 
    mux4_3 : mux4 generic map (width => 1) port map(d0 => std_logic_vector(to_unsigned(0, 1)), d1 => tmp1, d2 => tmp2, d3 => std_logic_vector(to_unsigned(0, 1)), s => branch, y(0) => mux4_3_output);
    -- write data mux
    mux4_4: mux4 generic map (width => 32) port map(d0 => readdata(31 downto 8) & writedata(7 downto 0), d1 => readdata(31 downto 16) & writedata(7 downto 0) & readdata(7 downto 0), d2 => readdata(31 downto 24) & writedata(7 downto 0) & readdata(15 downto 0), d3 => writedata(7 downto 0) & readdata(23 downto 0), s => aluresult(1 downto 0), y => writedataByte);
    -- mux to select whether or not the write the whole word or only a single byte
    mux2_3: mux2 generic map(width => 32) port map(d0 => writedata, d1 => writedataByte, s => wordOrByte, y => writedataValue);
    -- Data Memory.
    dmem1: dmem port map(clk => clk, we => memwrite, a => aluresult, wd => writedataValue, rd => readdata);
    -- MUX4 selecting a single byte from the read data memory, the byte that gets selected is in the last two bits of the address (alu result)
    mux4_5: mux4 generic map (width => 8) port map(d0 => readdata(7 downto 0), d1 => readdata(15 downto 8), d2 => readdata(23 downto 16), d3 => readdata(31 downto 24), s => aluresult(1 downto 0), y => loadbyte);
    -- MUX2 selecting if a whole word or a single byte should be read
    mux2_4: mux2 generic map(width => 32) port map(d0 => readdata, d1 => (31 downto 8 => '0') & loadbyte, s => wordOrByte, y => readdataresult);
    -- MUX4 the one at the very right (near Data Memory).
    mux4_6 : mux4 generic map (width => 32) port map(d0 => aluresult, d1 => readdataresult, d2 => nextaddress, d3 => (31 downto 0 => '0'), s => memtoreg, y => result);   

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
