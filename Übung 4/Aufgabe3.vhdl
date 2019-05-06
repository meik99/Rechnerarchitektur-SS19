library IEEE; use IEEE.STD_LOGIC_1164.all;

entity Muxer2to1 is
  port(a, b: in STD_LOGIC_VECTOR(31 downto 0);
      sig: in STD_LOGIC;
      result: out STD_LOGIC_VECTOR(31 downto 0));
end;

architecture arch of Muxer2to1 is
begin
  -- result <= a when (sig = '0') else b;
  result <= (a and not (31 downto 0 => sig)) or (b and (31 downto 0 => sig)); 
end arch ; -- arch


library IEEE; use IEEE.STD_LOGIC_1164.all;
entity NOTifier is
  port (
    b: in STD_LOGIC_VECTOR(31 downto 0);
    f: in STD_LOGIC_VECTOR(2 downto 0);
    result: out STD_LOGIC_VECTOR(31 downto 0)
  );
end NOTifier;

architecture arch of NOTifier is
  component Muxer2to1
    port(a, b: in STD_LOGIC_VECTOR(31 downto 0);
        sig: in STD_LOGIC;
        result: out STD_LOGIC_VECTOR(31 downto 0));
  end component;

  signal not_b: STD_LOGIC_VECTOR(31 downto 0);
begin
-- not of b
  not_b <= not b;

  mux0: Muxer2to1 port map(b, not_b, f(2), result);
end arch ; -- arch


library IEEE; use IEEE.STD_LOGIC_1164.all; use IEEE.STD_LOGIC_UNSIGNED.all; use IEEE.NUMERIC_STD.all;

entity not_b_testbench is
end;
architecture arch of not_b_testbench is
  component NOTifier is
    port (
      b: in STD_LOGIC_VECTOR(31 downto 0);
      f: in STD_LOGIC_VECTOR(2 downto 0);
      result: out STD_LOGIC_VECTOR(31 downto 0)
    );
  end component;
  signal a, b, y:  STD_LOGIC_VECTOR(31 downto 0) := X"00000000";
  signal f: STD_LOGIC_VECTOR(2 downto 0) := "000";
begin
  notifier0: NOTifier port map(b, f, y);

  not_b_test : process
  begin
      a <= STD_LOGIC_VECTOR(TO_SIGNED(17, a'length));
      b <= STD_LOGIC_VECTOR(TO_SIGNED(26, b'length));
      f <= "000";
      
      wait for 40 ns;
      report "A = " & integer'image(to_integer(signed(a))) & ", B = " & integer'image(to_integer(signed(b)));
      report "B = " & integer'image(to_integer(signed(y)));

      f <= "100";
      
      wait for 40 ns;
      report "A = " & integer'image(to_integer(signed(a))) & ", B = " & integer'image(to_integer(signed(b)));
      report "NOT B = " & integer'image(to_integer(signed(y)));

      wait;
  end process ; -- not_b_test
end arch ; -- arch


library IEEE; use IEEE.STD_LOGIC_1164.all;
entity FA is
  port(
    a, b, cin: in STD_LOGIC;
    cout, y: out STD_LOGIC
  );
end FA;

architecture arch of FA is
begin 
  cout <= (a AND b) OR (a AND cin) OR (b AND cin);
  y <= a XOR b XOR cin;
end arch ; -- arch



library IEEE; use IEEE.STD_LOGIC_1164.all;
entity ADDER is
  port(
    a, b: in STD_LOGIC_VECTOR(31 downto 0);
    sub: in STD_LOGIC;
    y: out STD_LOGIC_VECTOR(31 downto 0)
  );
end ADDER;

architecture arch of ADDER is
  component FA
    port(
      a, b, cin: in STD_LOGIC;
      cout, y: out STD_LOGIC
    );
  end component;
  signal c: STD_LOGIC_VECTOR(31 downto 0);
  signal s_buf: STD_LOGIC_VECTOR(31 downto 0);
begin
  fa0: FA port map(a(0), b(0), sub, c(0), s_buf(0));
  fa1: FA port map(a(1), b(1), c(0), c(1), s_buf(1));
  fa2: FA port map(a(2), b(2), c(1), c(2), s_buf(2));
  fa3: FA port map(a(3), b(3), c(2), c(3), s_buf(3));
  fa4: FA port map(a(4), b(4), c(3), c(4), s_buf(4));
  fa5: FA port map(a(5), b(5), c(4), c(5), s_buf(5));
  fa6: FA port map(a(6), b(6), c(5), c(6), s_buf(6));
  fa7: FA port map(a(7), b(7), c(6), c(7), s_buf(7));
  fa8: FA port map(a(8), b(8), c(7), c(8), s_buf(8));
  fa9: FA port map(a(9), b(9), c(8), c(9), s_buf(9));
  fa10: FA port map(a(10), b(10), c(9), c(10), s_buf(10));
  fa11: FA port map(a(11), b(11), c(10), c(11), s_buf(11));
  fa12: FA port map(a(12), b(12), c(11), c(12), s_buf(12));
  fa13: FA port map(a(13), b(13), c(12), c(13), s_buf(13));
  fa14: FA port map(a(14), b(14), c(13), c(14), s_buf(14));
  fa15: FA port map(a(15), b(15), c(14), c(15), s_buf(15));
  fa16: FA port map(a(16), b(16), c(15), c(16), s_buf(16));
  fa17: FA port map(a(17), b(17), c(16), c(17), s_buf(17));
  fa18: FA port map(a(18), b(18), c(17), c(18), s_buf(18));
  fa19: FA port map(a(19), b(19), c(18), c(19), s_buf(19));
  fa20: FA port map(a(20), b(20), c(19), c(20), s_buf(20));
  fa21: FA port map(a(21), b(21), c(20), c(21), s_buf(21));
  fa22: FA port map(a(22), b(22), c(21), c(22), s_buf(22));
  fa23: FA port map(a(23), b(23), c(22), c(23), s_buf(23));
  fa24: FA port map(a(24), b(24), c(23), c(24), s_buf(24));
  fa25: FA port map(a(25), b(25), c(24), c(25), s_buf(25));
  fa26: FA port map(a(26), b(26), c(25), c(26), s_buf(26));
  fa27: FA port map(a(27), b(27), c(26), c(27), s_buf(27));
  fa28: FA port map(a(28), b(28), c(27), c(28), s_buf(28));
  fa29: FA port map(a(29), b(29), c(28), c(29), s_buf(29));
  fa30: FA port map(a(30), b(30), c(29), c(30), s_buf(30));
  fa31: FA port map(a(31), b(31), c(30), c(31), s_buf(31));

  y <= s_buf;
end arch; -- arch


-- TODO: Implement architecture of the ALU and all further required entities/architecture 
library IEEE; use IEEE.STD_LOGIC_1164.all;

entity ALU is
    port(a, b:          in STD_LOGIC_VECTOR(31 downto 0);
         f:             in STD_LOGIC_VECTOR(2 downto 0);
         result:        out STD_LOGIC_VECTOR(31 downto 0));
end;


architecture arch of ALU is  
  component Muxer2to1
    port(a, b: in STD_LOGIC_VECTOR(31 downto 0);
        sig: in STD_LOGIC;
        result: out STD_LOGIC_VECTOR(31 downto 0));
  end component;
  component ADDER
    port(
      a, b: in STD_LOGIC_VECTOR(31 downto 0);
      sub: in STD_LOGIC;
      y: out STD_LOGIC_VECTOR(31 downto 0)
    );
  end component;

  signal not_b: STD_LOGIC_VECTOR(31 downto 0);
  signal work_b: STD_LOGIC_VECTOR(31 downto 0);
  signal a_and_b, a_or_b, a_plus_b, a_minus_b, a_less_than_b: STD_LOGIC_VECTOR(31 downto 0);
  signal f1_vector, f0_vector: STD_LOGIC_VECTOR(31 downto 0);
begin
  not_b <= not b;
  f1_vector <= (31 downto 0 => f(1));
  f0_vector <= (31 downto 0 => f(0));

  mux_not_b: Muxer2to1 port map(b, not_b, f(2), work_b);
  add: ADDER port map(a, work_b, f(2), a_plus_b);

  a_and_b <= a and work_b;
  a_or_b <= a or work_b;
  a_less_than_b <= (31 downto 1 => '0', 0 => a_plus_b(31));

  result <= ( a_and_b and not f1_vector and not f0_vector ) or
            ( a_or_b and not f1_vector and f0_vector ) or 
            ( a_plus_b and f1_vector and not f0_vector ) or
            ( a_less_than_b and f1_vector and f0_vector );
end arch ; -- arch




-- Testbench

library IEEE; use IEEE.STD_LOGIC_1164.all; use IEEE.STD_LOGIC_UNSIGNED.all; use IEEE.NUMERIC_STD.all;

entity testbench is
end;

architecture test of testbench is
  component ALU
    port(a, b:  in STD_LOGIC_VECTOR(31 downto 0);
         f:    in STD_LOGIC_VECTOR(2 downto 0);
         result:        out STD_LOGIC_VECTOR(31 downto 0));
  end component;
  signal a, b, y:  STD_LOGIC_VECTOR(31 downto 0) := X"00000000";
  signal f: STD_LOGIC_VECTOR(2 downto 0) := "000";
begin
      my_alu: ALU port map(a, b, f, y);

    process begin
      a <= STD_LOGIC_VECTOR(TO_SIGNED(17, a'length));
      b <= STD_LOGIC_VECTOR(TO_SIGNED(26, b'length));
      f <= "000";
      wait for 40 ns;
      report "A = " & integer'image(to_integer(signed(a))) & ", B = " & integer'image(to_integer(signed(b)));
      report "A AND B = " & integer'image(to_integer(signed(y)));

      f <= "001";
      wait for 40 ns;
      report "A OR B = " & integer'image(to_integer(signed(y)));

      f <= "010";
      wait for 40 ns;
      report "A + B = " & integer'image(to_integer(signed(y)));

      f <= "100";
      wait for 40 ns;
      report "A AND (NOT B) = " & integer'image(to_integer(signed(y)));

      f <= "101";
      wait for 40 ns;
      report "A OR (NOT B) = " & integer'image(to_integer(signed(y)));

      f <= "110";
      wait for 40 ns;
      report "A - B = " & integer'image(to_integer(signed(y)));

      f <= "111";
      wait for 40 ns;
      report "SLT = " & integer'image(to_integer(signed(y)));

      wait;
    end process;
end;
