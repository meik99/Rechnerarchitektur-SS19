-- Full adder
library IEEE; use IEEE.STD_LOGIC_1164.all;
entity FA is
  port(a,b,cin: in STD_LOGIC;
       cout,s: out STD_LOGIC);
end;

architecture behav of FA is
begin
  cout <= (a AND b) OR (a AND cin) OR (b AND cin);
  s <= a XOR b XOR cin;
end;

-- 32 bit carry-ripple adder
library IEEE; use IEEE.STD_LOGIC_1164.all;
entity adder is
    port(a, b: in STD_LOGIC_VECTOR(31 downto 0);
         cin: in STD_LOGIC;
         y:    buffer STD_LOGIC_VECTOR(31 downto 0));
end;

architecture behav of adder is
  component FA 
    port(a,b,cin: in STD_LOGIC;
         cout, s: out STD_LOGIC);
  end component;
  signal c: STD_LOGIC_VECTOR(31 downto 0) := X"00000000";
begin
  fa0: FA port map(a(0), b(0), cin, c(0), y(0));
  FA_GEN:
  for I in 1 to 31 generate
    FA_I : FA port map(a(I), b(I), c(I-1), c(I), y(I));
  end generate FA_GEN;
end;

-- Arithmetic Logic Unit (ALU)
library IEEE; use IEEE.STD_LOGIC_1164.all; use IEEE.NUMERIC_STD.all;
entity alu is
    port(a, b:          in STD_LOGIC_VECTOR(31 downto 0);
         alucontrol:    in STD_LOGIC_VECTOR(2 downto 0);
         result:        buffer STD_LOGIC_VECTOR(31 downto 0);
         zero:          out STD_LOGIC);
end;

architecture behave of alu is
    component mux2 generic(width: integer);
        port(d0, d1:    in STD_LOGIC_VECTOR(31 downto 0);
             s:         in STD_LOGIC;
             y:         out STD_LOGIC_VECTOR(31 downto 0));
    end component;
    component mux4 generic(width: integer);
        port(d0, d1, d2, d3:    in STD_LOGIC_VECTOR(31 downto 0);
             s:                 in STD_LOGIC_VECTOR(1 downto 0);
             y:                 out STD_LOGIC_VECTOR(31 downto 0));
    end component;
    component adder
        port(a,b:   in STD_LOGIC_VECTOR(31 downto 0);
             cin:   in STD_LOGIC;
             y:     out STD_LOGIC_VECTOR(31 downto 0));
    end component;
	component shift_right
		port(a: in STD_LOGIC_VECTOR(31 downto 0);
			 b: in STD_LOGIC_VECTOR(4 downto 0);
			 y: out STD_LOGIC_VECTOR(31 downto 0));
	end component;
    signal a_and_b, a_or_b, not_b, sum, slt, res_mux1, tmp1, tmp2, slt_mux: STD_LOGIC_VECTOR(31 downto 0) := X"00000000";
begin
	
    not_b_mux: mux2 generic map(32) port map(b, not_b, alucontrol(2), res_mux1);
    alu_adder: adder port map(a, res_mux1, alucontrol(2),sum);

    result_mux1: mux2 generic map(32) port map(a_and_b, a_or_b, alucontrol(0), tmp1);
    result_mux2: mux2 generic map(32) port map(sum, slt, alucontrol(0), tmp2);
    result_mux: mux2 generic map(32) port map(tmp1, tmp2, alucontrol(1), result);

    not_b <= not b;
    a_and_b <= a and res_mux1;
    a_or_b <= a or res_mux1;
    slt <= X"0000000" & "000" & sum(31);
    zero <= not (OR result);
end;


