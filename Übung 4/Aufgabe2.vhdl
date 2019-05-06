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

library IEEE; use IEEE.STD_LOGIC_1164.all;

entity ADDER is
  port(a,b: in STD_LOGIC_VECTOR(31 downto 0);
       s: out STD_LOGIC_VECTOR(31 downto 0));
end;

architecture behav of ADDER is
  component FA 
    port(a,b,cin: in STD_LOGIC;
         cout, s: out STD_LOGIC);
  end component;
  signal c: STD_LOGIC_VECTOR(31 downto 0);
  signal s_buf: STD_LOGIC_VECTOR(31 downto 0);
begin
  fa0: FA port map(a(0), b(0), '0', c(0), s_buf(0));
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

  s <= s_buf;
end;


library IEEE; use IEEE.STD_LOGIC_1164.all;

entity CSavA is
  port(a, b, c: in STD_LOGIC_VECTOR(31 downto 0);
       cout, s: out STD_LOGIC_VECTOR(31 downto 0));
end;
architecture arch of CSavA is
	component ADDER
		  port(a,b: in STD_LOGIC_VECTOR(31 downto 0);
	       		s: out STD_LOGIC_VECTOR(31 downto 0));
	end component;
	component FA 
	    port(a,b,cin: in STD_LOGIC;
        	 cout, s: out STD_LOGIC);
	end component;
begin
	fa0: FA port map(a(0), b(0), c(0), cout(0), s(0));
	fa1: FA port map(a(1), b(1), c(1), cout(1), s(1));
	fa2: FA port map(a(2), b(2), c(2), cout(2), s(2));
	fa3: FA port map(a(3), b(3), c(3), cout(3), s(3));
	fa4: FA port map(a(4), b(4), c(4), cout(4), s(4));
	fa5: FA port map(a(5), b(5), c(5), cout(5), s(5));
	fa6: FA port map(a(6), b(6), c(6), cout(6), s(6));
	fa7: FA port map(a(7), b(7), c(7), cout(7), s(7));
	fa8: FA port map(a(8), b(8), c(8), cout(8), s(8));
	fa9: FA port map(a(9), b(9), c(9), cout(9), s(9));
	fa10: FA port map(a(10), b(10), c(10), cout(10), s(10));
	fa11: FA port map(a(11), b(11), c(11), cout(11), s(11));
	fa12: FA port map(a(12), b(12), c(12), cout(12), s(12));
	fa13: FA port map(a(13), b(13), c(13), cout(13), s(13));
	fa14: FA port map(a(14), b(14), c(14), cout(14), s(14));
	fa15: FA port map(a(15), b(15), c(15), cout(15), s(15));
	fa16: FA port map(a(16), b(16), c(16), cout(16), s(16));
	fa17: FA port map(a(17), b(17), c(17), cout(17), s(17));
	fa18: FA port map(a(18), b(18), c(18), cout(18), s(18));
	fa19: FA port map(a(19), b(19), c(19), cout(19), s(19));
	fa20: FA port map(a(20), b(20), c(20), cout(20), s(20));
	fa21: FA port map(a(21), b(21), c(21), cout(21), s(21));
	fa22: FA port map(a(22), b(22), c(22), cout(22), s(22));
	fa23: FA port map(a(23), b(23), c(23), cout(23), s(23));
	fa24: FA port map(a(24), b(24), c(24), cout(24), s(24));
	fa25: FA port map(a(25), b(25), c(25), cout(25), s(25));
	fa26: FA port map(a(26), b(26), c(26), cout(26), s(26));
	fa27: FA port map(a(27), b(27), c(27), cout(27), s(27));
	fa28: FA port map(a(28), b(28), c(28), cout(28), s(28));
	fa29: FA port map(a(29), b(29), c(29), cout(29), s(29));
	fa30: FA port map(a(30), b(30), c(30), cout(30), s(30));
	fa31: FA port map(a(31), b(31), c(31), cout(31), s(31));
end;
-- TODO: Implement Carry Save Adder



library IEEE; use IEEE.STD_LOGIC_1164.all;

entity m4to2 is
  port(a,b,c,d: in STD_LOGIC_VECTOR(31 downto 0);
       x, y:    out STD_LOGIC_VECTOR(31 downto 0));
end;
architecture arch of m4to2 is
	component CSavA
		port(a, b, c: in STD_LOGIC_VECTOR(31 downto 0);
		     cout, s: out STD_LOGIC_VECTOR(31 downto 0));
	end component;
	signal c_buf: STD_LOGIC_VECTOR(31 downto 0);
	signal s_buf: STD_LOGIC_VECTOR(31 downto 0);
begin
	csava0: CSavA port map(a, b, c, c_buf, s_buf);
	csava1: CSavA port map(c_buf, s_buf, d, x, y);
end;
-- TODO: Implement 4 to 2 reduction of summands



library IEEE; use IEEE.STD_LOGIC_1164.all;

entity mult is 
  port(a:   in STD_LOGIC_VECTOR(15 downto 0);
       b:   in STD_LOGIC_VECTOR(15 downto 0);
       y:   out STD_LOGIC_VECTOR(31 downto 0));
end;
architecture arch of mult is
	component m4to2
		port(a,b,c,d: in STD_LOGIC_VECTOR(31 downto 0);
		     x, y: out STD_LOGIC_VECTOR(31 downto 0));
	end component;
	component ADDER
		port(a,b: in STD_LOGIC_VECTOR(31 downto 0);
			s: out STD_LOGIC_VECTOR(31 downto 0));
	end component;

	signal tmp_a, tmp_x0, tmp_x1, tmp_x2, tmp_x3: STD_LOGIC_VECTOR(31 downto 0);
	signal tmp_b, tmp_y0, tmp_y1, tmp_y2, tmp_y3: STD_LOGIC_VECTOR(31 downto 0);
	signal tmp_z0, tmp_z1, tmp_z2, tmp_z3: STD_LOGIC_VECTOR(31 downto 0);
	signal s, c: STD_LOGIC_VECTOR(31 downto 0);
	signal pp0, pp1, pp2, pp3, pp4,
		pp5, pp6, pp7, pp8, pp9,
		pp10, pp11, pp12, pp13, pp14, pp15: STD_LOGIC_VECTOR(31 downto 0);
begin
	tmp_a <= (31 downto 16 => '0') & a;
	tmp_b <= (31 downto 16 => '0') & b;

	pp0 <= tmp_a AND (31 downto 0 => tmp_b(0));
	pp1 <= tmp_a AND (31 downto 0 => tmp_b(1));
	pp2 <= tmp_a AND (31 downto 0 => tmp_b(2));
	pp3 <= tmp_a AND (31 downto 0 => tmp_b(3));

	pp4 <= tmp_a AND (31 downto 0 => tmp_b(4));
	pp5 <= tmp_a AND (31 downto 0 => tmp_b(5));
	pp6 <= tmp_a AND (31 downto 0 => tmp_b(6));
	pp7 <= tmp_a AND (31 downto 0 => tmp_b(7));

	pp8 <= tmp_a AND (31 downto 0 => tmp_b(8));
	pp9 <= tmp_a AND (31 downto 0 => tmp_b(9));
	pp10 <= tmp_a AND (31 downto 0 => tmp_b(10));
	pp11 <= tmp_a AND (31 downto 0 => tmp_b(11));

	pp12 <= tmp_a AND (31 downto 0 => tmp_b(12));
	pp13 <= tmp_a AND (31 downto 0 => tmp_b(13));
	pp14 <= tmp_a AND (31 downto 0 => tmp_b(14));
	pp15 <= tmp_a AND (31 downto 0 => tmp_b(15));

	m0: m4to2 port map (pp0, pp1, pp2, pp3, tmp_x0, tmp_y0);
	m1: m4to2 port map (pp4, pp5, pp6, pp7, tmp_x1, tmp_y1);
	m2: m4to2 port map (pp8, pp9, pp10, pp11, tmp_x2, tmp_y2);
	m3: m4to2 port map (pp12, pp13, pp14, pp15, tmp_x3, tmp_y3);

	m4: m4to2 port map(tmp_x0, tmp_y0, tmp_x1, tmp_y1, tmp_z0, tmp_z1);
	m5: m4to2 port map(tmp_x2, tmp_y2, tmp_x3, tmp_x3, tmp_z2, tmp_z3);
	
	m6: m4to2 port map(tmp_z0, tmp_z1, tmp_z2, tmp_z3, s, c);
	
	add0: ADDER port map(s, c, y);
end;
-- TODO: Implement multiplier

  


-- Testbench

library IEEE; use IEEE.STD_LOGIC_1164.all; use IEEE.STD_LOGIC_UNSIGNED.all; use IEEE.NUMERIC_STD.all;

entity testbench is
end;

architecture test of testbench is
  component mult
    port(a, b:  in STD_LOGIC_VECTOR(15 downto 0);
         y:     out STD_LOGIC_VECTOR(31 downto 0));
  end component;
  signal a, b:  STD_LOGIC_VECTOR(15 downto 0);
  signal y:     STD_LOGIC_VECTOR(31 downto 0);
begin

	my_mult: mult port map(a, b, y);

    process is
      variable aa, bb, tests, failed: Integer;
    begin
      a <= STD_LOGIC_VECTOR(TO_UNSIGNED(15, a'length));
      b <= STD_LOGIC_VECTOR(TO_UNSIGNED(10, b'length));
      wait for 40 ns;
      report "15 * 10 = " & integer'image(to_integer(unsigned(y)));

      a <= STD_LOGIC_VECTOR(TO_UNSIGNED(131, a'length));
      b <= STD_LOGIC_VECTOR(TO_UNSIGNED(3, b'length));
      wait for 40 ns;
      report "131 * 3 = " & integer'image(to_integer(unsigned(y)));

      a <= STD_LOGIC_VECTOR(TO_UNSIGNED(19, a'length));
      b <= STD_LOGIC_VECTOR(TO_UNSIGNED(46, b'length));
      wait for 40 ns;
      report "19 * 46 = " & integer'image(to_integer(unsigned(y)));

      a <= STD_LOGIC_VECTOR(TO_UNSIGNED(11, a'length));
      b <= STD_LOGIC_VECTOR(TO_UNSIGNED(200, b'length));
      wait for 40 ns;
      report "11 * 200 = " & integer'image(to_integer(unsigned(y)));

      a <= STD_LOGIC_VECTOR(TO_UNSIGNED(100, a'length));
      b <= STD_LOGIC_VECTOR(TO_UNSIGNED(100, b'length));
      wait for 40 ns;
      report "100 * 100 = " & integer'image(to_integer(unsigned(y)));

      aa := 0;
      tests := 0;
      failed := 0;
        
	  while(aa < 30000) loop
        bb := 0;
        while(bb < 30000) loop
		  a <= STD_LOGIC_VECTOR(TO_UNSIGNED(aa, a'length));
     	  b <= STD_LOGIC_VECTOR(TO_UNSIGNED(bb, b'length));
          tests := tests + 1;
		  wait for 5 ns;
		  if (aa * bb /= to_integer(unsigned(y))) then
            report integer'image(aa) & " + " & integer'image(bb) & " = " & integer'image(to_integer(unsigned(y))) severity error; 
            failed := failed + 1;
          end if;
          bb := bb + 143;
		end loop;
        aa := aa + 1550;
	  end loop;
      report integer'image(failed) & " out of " & integer'image(tests) & " tests failed.";
      wait;
    end process;
end;
