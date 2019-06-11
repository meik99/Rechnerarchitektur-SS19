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
             branchandzero, alusrc:         out STD_LOGIC;
             regdst, regwrite:      out STD_LOGIC;
             jump:                  out STD_LOGIC;
             alucontrol:            out STD_LOGIC_VECTOR(2 downto 0));
    end component;
    component datapath
        port(clk, reset:        in STD_LOGIC;
             memtoreg, branchandzero:   in STD_LOGIC;
             alusrc, regdst:    in STD_LOGIC;
             regwrite, jump:    in STD_LOGIC;
             memwrite:          in STD_LOGIC;
             alucontrol:        in STD_LOGIC_VECTOR(2 downto 0);
             zero:              out STD_LOGIC;
             instr:             out STD_LOGIC_VECTOR(31 downto 0));
    end component;
    signal memtoreg, memwrite, branchandzero, alusrc, regdst, regwrite, jump, zero: STD_LOGIC := '0';
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
         jump		            out STD_LOGIC;
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
    jump         <= controls(3);
    alucontrol   <= controls(2 downto 0);

    branchandzero <= branch and zero;
end;

-- datapath
library IEEE; use IEEE.STD_LOGIC_1164.all; use IEEE.NUMERIC_STD.all;
entity datapath is
    port(clk, reset:        in STD_LOGIC;
         memtoreg, branchandzero:   in STD_LOGIC;
         alusrc, regdst:    in STD_LOGIC;
         regwrite, jump:    in STD_LOGIC;
         memwrite:          in STD_LOGIC;
         alucontrol:        in STD_LOGIC_VECTOR(2 downto 0);
         zero:              out STD_LOGIC;
         instr:             out STD_LOGIC_VECTOR(31 downto 0));
end;


-- TODO: Implement datapath of the MIPS processor
-- Important: the instance of the component regfile must be named rf. Otherwise, the testbench cannot read out the final results.
-- Important: the instance of the component dmem must be named dmem1. Otherwise, the testbench cannot read out the final results.



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
