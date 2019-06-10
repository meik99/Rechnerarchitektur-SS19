library IEEE; use IEEE.STD_LOGIC_1164.all;

entity FA is
  port(a,b,cin:  in STD_LOGIC;
       cout,sum: out STD_LOGIC);
end;

architecture behav of FA is
begin
	sum <= a XOR b XOR cin;
	cout <= (a AND b) OR (b AND cin) OR (a AND cin);
end;


library IEEE; use IEEE.STD_LOGIC_1164.all;

entity ff is
port(clk, reset: in STD_LOGIC;
     d: in STD_LOGIC;
	 q: out STD_LOGIC);
end;

architecture asynchronous of ff is
begin
	process(clk, reset)
	begin
		if reset = '1' then
            q <= '0';
		elsif clk'event and clk='1' then
			q <= d;
		end if;
	end process;
end;

library IEEE; use IEEE.STD_LOGIC_1164.all;

entity setable_shift_reg is generic(width: integer);
port(clk, set: in STD_LOGIC;
     d: in STD_LOGIC_VECTOR(width-1 downto 0);
	 q: out STD_LOGIC);
end;
architecture behaviour of setable_shift_reg is
	component ff
	port(clk, reset: in STD_LOGIC;
		d: in STD_LOGIC;
		q: out STD_LOGIC);
	end component;
	signal inputCache: STD_LOGIC_VECTOR(width-1 downto 0);
	signal shiftOutput : STD_LOGIC_VECTOR(width-1 downto 0);
begin
	inputCache(0) <= d(0) when set = '1' else '0';
	register0: ff port map(clk => clk, reset => set, d => inputCache(0), q => shiftOutput(0));

	generateRegisters : for i in 1 to (width-1) generate
		inputCache(i) <= d(i) when set = '1' else shiftOutput(i-1);
		registerN: ff port map(clk => clk, reset => set, d => inputCache(i), q => shiftOutput(i));
	end generate generateRegisters;

	q <= shiftOutput(width-1);
end;

library IEEE; use IEEE.STD_LOGIC_1164.all;

entity shift_reg is generic(width: integer);
port(clk: in STD_LOGIC;
     d: in STD_LOGIC;
	 q: out STD_LOGIC_VECTOR(width-1 downto 0));
end;
architecture behaviour of shift_reg is
	component ff
	port(clk, reset: in STD_LOGIC;
		d: in STD_LOGIC;
		q: out STD_LOGIC);
	end component;
	signal reset : STD_LOGIC;
begin
	register1: ff port map(clk => clk, reset => '0', d => d, q => q(0));

	generateRegisters : for i in 1 to (width-1) generate
		registerN: ff port map(clk => clk, reset => '0', d => q(i-1), q => q(i));
	end generate generateRegisters;
end;

library IEEE; use IEEE.STD_LOGIC_1164.all;

entity serial_adder is generic(width: integer);
port(clk, set: in STD_LOGIC;
	 a, b: in STD_LOGIC_VECTOR(width-1 downto 0);
	 cout: out STD_LOGIC;
	 sum: out STD_LOGIC_VECTOR(width-1 downto 0));
end;
architecture behaviour of serial_adder is
	component shift_reg generic(width: integer);
		port(clk: in STD_LOGIC;
		d: in STD_LOGIC;
		q: out STD_LOGIC_VECTOR(width-1 downto 0));
	end component;
	component setable_shift_reg generic(width: integer);
		port(clk, set: in STD_LOGIC;
		d: in STD_LOGIC_VECTOR(width-1 downto 0);
		q: out STD_LOGIC);
	end component;
	component FA
		port(a,b,cin:  in STD_LOGIC;
		cout,sum: out STD_LOGIC);
	end component;
	component ff
	port(clk, reset: in STD_LOGIC;
		d: in STD_LOGIC;
		q: out STD_LOGIC);
	end component;

	signal shiftAOuput : STD_LOGIC;
	signal shiftBOuput : STD_LOGIC;
	signal fullAdderSum : STD_LOGIC;
	signal carryIn : STD_LOGIC;
begin
	shiftA : setable_shift_reg generic map(width => width) port map(clk => clk, d => a, set => set, q => shiftAOuput);
	shiftB : setable_shift_reg generic map(width => width) port map(clk => clk, d => b, set => set, q => shiftBOuput);

	fullAdder : FA port map (a => shiftAOuput, b => shiftBOuput, cin => carryIn, cout => cout, sum => fullAdderSum);
	carryRegister : ff port map (clk => clk, reset => set, d => cout, q => carryIn);

	shiftSum : shift_reg generic map(width => width) port map(clk => clk, d => fullAdderSum, q => sum);
end;

library IEEE; use IEEE.STD_LOGIC_1164.all; use IEEE.numeric_std.all;
entity testbench is
end;

architecture test of testbench is
    component serial_adder generic(width: integer);
        port(clk, set: in STD_LOGIC;
			 a, b: in STD_LOGIC_VECTOR(7 downto 0);
			 cout: out STD_LOGIC;
			 sum: out STD_LOGIC_VECTOR(7 downto 0));
    end component;
    signal clk, reset: STD_LOGIC := '0';
	signal a, b:       STD_LOGIC_VECTOR(7 downto 0);
	signal sum:        STD_LOGIC_VECTOR(8 downto 0);
	signal run:        STD_LOGIC := '1';
begin
    -- initiate device to be tested
    dut: serial_adder generic map(width => 8) port map(clk, reset, a, b, sum(8), sum(7 downto 0));

    -- generate clock with 10 ns period
    process begin
		while run /= '0' loop
	        clk <= '1';
	        wait for 5 ps;
	        clk <= '0';
    	    wait for 5 ps;
		end loop;
		wait;
    end process;

    -- test several combinations
    process is
        variable aa, bb, tests, failed: Integer;
    begin
        aa := 0;
        tests := 0;
        failed := 0;
        while (aa <= 255) loop
            bb := 0;
	        while (bb <= 255) loop
				a <= STD_LOGIC_VECTOR(TO_UNSIGNED(aa, a'length));
   		  		b <= STD_LOGIC_VECTOR(TO_UNSIGNED(bb, b'length));
				reset <= '1';
				wait for 20 ps;
				reset <= '0';
				wait for 80 ps;
				if (aa + bb /= to_integer(unsigned(sum))) then
					report to_string(a) & " + " & to_string(b) & " = " & to_string(sum) & " | "  & integer'image(aa) & " + " & integer'image(bb) & " = " & integer'image(to_integer(unsigned(sum))) severity error;
                    failed := failed + 1;
				end if;
                bb := bb + 5;
                tests := tests + 1;
			end loop;
            aa := aa + 5;
		end loop;
		run <= '0';
        report integer'image(failed) & " out of " & integer'image(tests) & " tests failed.";
    	wait;
	end process;
end;