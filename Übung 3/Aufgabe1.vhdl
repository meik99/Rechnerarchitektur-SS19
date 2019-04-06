-- Conditional Sum Adder for 8 BITS

library IEEE; use IEEE.STD_LOGIC_1164.all;
entity adder is
  port(a,b:  in STD_LOGIC_VECTOR(7 downto 0);
       cin:  in STD_LOGIC;
 	   cout: out STD_LOGIC;
       sum:  out STD_LOGIC_VECTOR(7 downto 0));
end;
architecture behaviour of adder is
     component CSA4 is
         port(a,b:  in STD_LOGIC_VECTOR(3 downto 0);
               cin:  in STD_LOGIC;
               cout: out STD_LOGIC;
               sum:  out STD_LOGIC_VECTOR(3 downto 0));
     end component CSA4;
     component MUX105 is
            port(sel : in STD_LOGIC;
                 X, Y : in STD_LOGIC_VECTOR(4 downto 0);
                 m: out STD_LOGIC_VECTOR(4 downto 0));
     end component MUX105;

     signal coutCsa1 : STD_LOGIC;
     signal resultCsa2 : STD_LOGIC_VECTOR(4 downto 0);
     signal resultCsa3 : STD_LOGIC_VECTOR(4 downto 0);
     signal rssum : STD_LOGIC_VECTOR(4 downto 0);
begin
    ca1 : CSA4 port map(a(3 downto 0),b(3 downto 0), cin, coutCsa1, sum(3 downto 0));
    ca2 : CSA4 port map(a(7 downto 4),b(7 downto 4), '0', resultCsa2(4), resultCsa2(3 downto 0));
    ca3 : CSA4 port map(a(7 downto 4),b(7 downto 4), '1', resultCsa3(4), resultCsa3(3 downto 0));
    mux : MUX105 port map(coutCsa1, resultCsa2, resultCsa3,rssum);
    cout <= rssum(4);
    sum(7 downto 4) <= rssum(3 downto 0);
end architecture behaviour;

-- Conditional Sum Adder for 4 BITS

library IEEE; use IEEE.STD_LOGIC_1164.all;
entity CSA4 is
  port(a,b:  in STD_LOGIC_VECTOR(3 downto 0);
       cin:  in STD_LOGIC;
 	   cout: out STD_LOGIC;
       sum:  out STD_LOGIC_VECTOR(3 downto 0));
end;
architecture behaviour of CSA4 is
   component CSA2 is
          port(a,b:  in STD_LOGIC_VECTOR(1 downto 0);
               cin:  in STD_LOGIC;
               cout: out STD_LOGIC;
               sum:  out STD_LOGIC_VECTOR(1 downto 0));
   end component CSA2;
   component MUX63 is
          port(sel : in STD_LOGIC;
                 X, Y : in STD_LOGIC_VECTOR(2 downto 0);
                 m: out STD_LOGIC_VECTOR(2 downto 0));
   end component MUX63;

   signal coutCsa1 : STD_LOGIC;
   signal resultCsa2 : STD_LOGIC_VECTOR(2 downto 0);
   signal resultCsa3 : STD_LOGIC_VECTOR(2 downto 0);
   signal tmpSum : STD_LOGIC_VECTOR(2 downto 0);
begin
    ca1 : CSA2 port map(a(1 downto 0),b(1 downto 0), cin, coutCsa1, sum(1 downto 0));
    ca2 : CSA2 port map(a(3 downto 2),b(3 downto 2), '0', resultCsa2(2), resultCsa2(1 downto 0));
    ca3 : CSA2 port map(a(3 downto 2),b(3 downto 2), '1', resultCsa3(2), resultCsa3(1 downto 0));
    mux : MUX63 port map(coutCsa1, resultCsa2, resultCsa3,tmpSum);
    cout <= tmpSum(2);
    sum(3 downto 2) <= tmpSum(1 downto 0);
end architecture behaviour;

-- Conditional Sum Adder for 2 BITS

library IEEE; use IEEE.STD_LOGIC_1164.all;
entity CSA2 is
  port(a,b:  in STD_LOGIC_VECTOR(1 downto 0);
       cin:  in STD_LOGIC;
 	   cout: out STD_LOGIC;
       sum:  out STD_LOGIC_VECTOR(1 downto 0));
end;
architecture behaviour of CSA2 is
    component FA is
            port(a,b,cin: in STD_LOGIC;
               cout, s: out STD_LOGIC);
    end component FA;
    component MUX42 is
            port(sel, X0, X1, Y0, Y1 : in STD_LOGIC;
                      m0, m1: out STD_LOGIC);
    end component MUX42;

    signal coutfa1 : STD_LOGIC;
    signal sumfa2, coutfa2 : STD_LOGIC;
    signal sumfa3, coutfa3 : STD_LOGIC;
begin
    fa1 : FA port map(a(0), b(0), cin, coutfa1,sum(0));
    fa2 : FA port map(a(1), b(1), '0', coutfa2,sumfa2);
    fa3 : FA port map(a(1), b(1), '1', coutfa3,sumfa3);

    mux : MUX42 port map(coutfa1,sumfa2,coutfa2,sumfa3,coutfa3,sum(1),cout);
end architecture behaviour;

-- 10 to 5 Multiplexer

library IEEE; use IEEE.STD_LOGIC_1164.all;
entity MUX105 is
    port(sel : in STD_LOGIC;
         X, Y : in STD_LOGIC_VECTOR(4 downto 0);
         m: out STD_LOGIC_VECTOR(4 downto 0));
end;
architecture behaviour of MUX105 is
    component MUX63 is
        port(sel : in STD_LOGIC;
             X, Y : in STD_LOGIC_VECTOR(2 downto 0);
             m: out STD_LOGIC_VECTOR(2 downto 0));
    end component;
    component MUX42 is
        port(sel, X0, X1, Y0, Y1 : in STD_LOGIC;
                m0, m1: out STD_LOGIC);
    end component;
begin
     mu63 : MUX63 port map(sel, X(2 downto 0), Y(2 downto 0), m(2 downto 0));
     mu42 : MUX42 port map(sel, X(3), X(4), Y(3), Y(4), m(3), m(4));
end;

-- 6 to 3 Multiplexer

library IEEE; use IEEE.STD_LOGIC_1164.all;
entity MUX63 is
    port(sel : in STD_LOGIC;
         X, Y : in STD_LOGIC_VECTOR(2 downto 0);
         m: out STD_LOGIC_VECTOR(2 downto 0));
end;
architecture behaviour of MUX63 is
    component MUX42 is
        port(sel, X0, X1, Y0, Y1 : in STD_LOGIC;
                m0, m1: out STD_LOGIC);
    end component;
begin
     mux : MUX42 port map(sel, X(0), X(1), Y(0), Y(1), m(0), m(1));
     m(2) <= (X(2) and sel) or (Y(2) and not sel);
end;

-- 4 to 2 Multiplexer

library IEEE; use IEEE.STD_LOGIC_1164.all;
entity MUX42 is
    port(sel, X0, X1, Y0, Y1 : in STD_LOGIC;
           m0, m1: out STD_LOGIC);
end;
architecture behaviour of MUX42 is
begin
   m0 <= (X0 and sel) or (Y0 and not sel);
   m1 <= (X1 and sel) or (Y1 and not sel);
end;


-- Full Adder

library IEEE; use IEEE.STD_LOGIC_1164.all;
entity FA is
  port(a,b,cin: in STD_LOGIC;
       cout, s: out STD_LOGIC);
end;
-- Architecture for FA
library IEEE; use IEEE.STD_LOGIC_1164.all;
architecture behav of FA is
begin
  cout <= (a AND b) OR (a AND cin) OR (b AND cin);
  s <= a XOR b XOR cin;
end;

-- Testbench

library IEEE; use IEEE.STD_LOGIC_1164.all; use IEEE.STD_LOGIC_UNSIGNED.all; use IEEE.NUMERIC_STD.all;

entity testbench is
end;

architecture test of testbench is
  component adder
    port(a, b: in STD_LOGIC_VECTOR(7 downto 0);
         cin:  in STD_LOGIC;
		 cout: out STD_LOGIC;
         sum:  out STD_LOGIC_VECTOR(7 downto 0));
  end component;
  signal a, b:  STD_LOGIC_VECTOR(7 downto 0);
  signal y:     STD_LOGIC_VECTOR(8 downto 0);
begin
      my_add: adder port map(a, b, '0', y(8), y(7 downto 0));

    process begin
      a <= STD_LOGIC_VECTOR(TO_UNSIGNED(15, a'length));
      b <= STD_LOGIC_VECTOR(TO_UNSIGNED(10, b'length));
      wait for 40 ns;
      report "15 + 10 = " & integer'image(to_integer(unsigned(y)));

      a <= STD_LOGIC_VECTOR(TO_UNSIGNED(11, a'length));
      b <= STD_LOGIC_VECTOR(TO_UNSIGNED(2, b'length));
      wait for 40 ns;
      report "11 + 2 = " & integer'image(to_integer(unsigned(y)));

      a <= STD_LOGIC_VECTOR(TO_UNSIGNED(19, a'length));
      b <= STD_LOGIC_VECTOR(TO_UNSIGNED(46, b'length));
      wait for 40 ns;
      report "19 + 46 = " & integer'image(to_integer(unsigned(y)));

	  for aa in 0 to 255 loop
		for bb in 0 to 255 loop
			a <= STD_LOGIC_VECTOR(TO_UNSIGNED(aa, a'length));
     		b <= STD_LOGIC_VECTOR(TO_UNSIGNED(bb, b'length));
			wait for 5 ns;
			if (aa + bb /= to_integer(unsigned(y))) then
				report integer'image(aa) & " + " & integer'image(bb) & " = " & integer'image(to_integer(unsigned(y))) severity error;
			    wait;
			end if;
		end loop;
	  end loop;
      wait;
    end process;
end;
