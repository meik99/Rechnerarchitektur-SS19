

-- Start Full Adder
library IEEE; use IEEE.STD_LOGIC_1164.all;
entity FA is
  port(
    a, b, cin: in std_logic;    
    s, cout: out std_logic
  );
end FA;

architecture behaviour of FA is
  
begin
  s <= (a xor b xor cin) or (a and b and cin);
  cout <= (a and b) or ((a or b) and cin);
end behaviour ; -- behaviour
-- End Full Adder

-- Start Simple Carry Lookahead Adder
library IEEE; use IEEE.STD_LOGIC_1164.all; use IEEE.STD_LOGIC_UNSIGNED.all; use IEEE.NUMERIC_STD.all;
entity sadder is
  port(a,b:  in STD_LOGIC_VECTOR(7 downto 0);
 	   cout: out STD_LOGIC;
       sum:  out STD_LOGIC_VECTOR(7 downto 0));
end;

architecture behaviour of sadder is
  component FA
    port(
      a, b, cin: in std_logic;    
      s, cout: out std_logic
    );
  end component;

  signal c, g, p: std_logic_vector(7 downto 0);
  signal c0: std_logic;
begin
  g <= a and b;
  p <= a or b;

  c(0) <= g(0) or (p(0) and '0');
  c(1) <= g(1) or (p(1) and (g(0) or (p(0) and '0')));
  c(2) <= g(2) or (p(2) and (g(1) or (p(1) and (g(0) or (p(0) and '0')))));
  c(3) <= g(3) or (p(3) and (g(2) or (p(2) and (g(1) or (p(1) and (g(0) or (p(0) and '0')))))));
  c(4) <= g(4) or (p(4) and (g(3) or (p(3) and (g(2) or (p(2) and (g(1) or (p(1) and (g(0) or (p(0) and '0')))))))));
  c(5) <= g(5) or (p(5) and (g(4) or (p(4) and (g(3) or (p(3) and (g(2) or (p(2) and (g(1) or (p(1) and (g(0) or (p(0) and '0')))))))))));
  c(6) <= g(6) or (p(6) and (g(5) or (p(5) and (g(4) or (p(4) and (g(3) or (p(3) and (g(2) or (p(2) and (g(1) or (p(1) and (g(0) or (p(0) and '0')))))))))))));
  cout <= g(7) or (p(7) and (g(6) or (p(6) and (g(5) or (p(5) and (g(4) or (p(4) and (g(3) or (p(3) and (g(2) or (p(2) and (g(1) or (p(1) and (g(0) or (p(0) and '0')))))))))))))));

  FA0: FA
  port map(a => a(0), b => b(0), cin => '0', s => sum(0), cout => open);

  FA1: FA
  port map(a => a(1), b => b(1), cin => c(0), s => sum(1), cout => open);

  FA2: FA
  port map(a => a(2), b => b(2), cin => c(1), s => sum(2), cout => open);

  FA3: FA
  port map(a => a(3), b => b(3), cin => c(2), s => sum(3), cout => open);

  FA4: FA
  port map(a => a(4), b => b(4), cin => c(3), s => sum(4), cout => open);

  FA5: FA
  port map(a => a(5), b => b(5), cin => c(4), s => sum(5), cout => open);

  FA6: FA
  port map(a => a(6), b => b(6), cin => c(5), s => sum(6), cout => open);

  FA7: FA
  port map(a => a(7), b => b(7), cin => c(6), s => sum(7), cout => open);

end behaviour ; -- behaviour

-- End Simple Carry Lookahead Adder

-- Start Complex Carry Lookahead Adder

library IEEE; use IEEE.STD_LOGIC_1164.all; use IEEE.STD_LOGIC_UNSIGNED.all; use IEEE.NUMERIC_STD.all;
entity adder is
  port(a,b:  in STD_LOGIC_VECTOR(7 downto 0);
    sub: in std_logic;
    cout: out STD_LOGIC;
    sum:  out STD_LOGIC_VECTOR(7 downto 0));
end;

architecture behaviour of adder is
  component FA
    port(
      a, b, cin: in std_logic;    
      s, cout: out std_logic
    );
  end component;
  component sadder
    port(a,b:  in STD_LOGIC_VECTOR(7 downto 0);
      cout: out STD_LOGIC;
        sum:  out STD_LOGIC_VECTOR(7 downto 0));
  end component;

  signal c, g, p: std_logic_vector(7 downto 0);
  signal c0: std_logic;
  signal b_work: std_logic_vector(7 downto 0);
  signal b_vector: std_logic_vector(7 downto 0);
  signal sub_vector: std_logic_vector(7 downto 0);
begin
  b_work <= b xor sub;
  g <= a and b_work;
  p <= a or b_work;

  c(0) <= g(0) or (p(0) and sub);
  c(1) <= g(1) or (p(1) and (g(0) or (p(0) and sub)));
  c(2) <= g(2) or (p(2) and (g(1) or (p(1) and (g(0) or (p(0) and sub)))));
  c(3) <= g(3) or (p(3) and (g(2) or (p(2) and (g(1) or (p(1) and (g(0) or (p(0) and sub)))))));
  c(4) <= g(4) or (p(4) and (g(3) or (p(3) and (g(2) or (p(2) and (g(1) or (p(1) and (g(0) or (p(0) and sub)))))))));
  c(5) <= g(5) or (p(5) and (g(4) or (p(4) and (g(3) or (p(3) and (g(2) or (p(2) and (g(1) or (p(1) and (g(0) or (p(0) and sub)))))))))));
  c(6) <= g(6) or (p(6) and (g(5) or (p(5) and (g(4) or (p(4) and (g(3) or (p(3) and (g(2) or (p(2) and (g(1) or (p(1) and (g(0) or (p(0) and sub)))))))))))));
  cout <= g(7) or (p(7) and (g(6) or (p(6) and (g(5) or (p(5) and (g(4) or (p(4) and (g(3) or (p(3) and (g(2) or (p(2) and (g(1) or (p(1) and (g(0) or (p(0) and sub)))))))))))))));  

  FA0: FA
  port map(a => a(0), b => b_work(0), cin => sub, s => sum(0), cout => open);

  FA1: FA
  port map(a => a(1), b => b_work(1), cin => c(0), s => sum(1), cout => open);

  FA2: FA
  port map(a => a(2), b => b_work(2), cin => c(1), s => sum(2), cout => open);

  FA3: FA
  port map(a => a(3), b => b_work(3), cin => c(2), s => sum(3), cout => open);

  FA4: FA
  port map(a => a(4), b => b_work(4), cin => c(3), s => sum(4), cout => open);

  FA5: FA
  port map(a => a(5), b => b_work(5), cin => c(4), s => sum(5), cout => open);

  FA6: FA
  port map(a => a(6), b => b_work(6), cin => c(5), s => sum(6), cout => open);

  FA7: FA
  port map(a => a(7), b => b_work(7), cin => c(6), s => sum(7), cout => open);
end behaviour ; -- behaviour
-- End Complex Carry Lookahead Adder

-- Testbench

library IEEE; use IEEE.STD_LOGIC_1164.all; use IEEE.STD_LOGIC_UNSIGNED.all; use IEEE.NUMERIC_STD.all;

entity testbench is
end;

architecture test of testbench is
  component adder
    port(a, b: in STD_LOGIC_VECTOR(7 downto 0);
		 cout: out STD_LOGIC;
         sum:  out STD_LOGIC_VECTOR(7 downto 0);
         sub: in std_logic
         );
  end component;
  signal a, b:  STD_LOGIC_VECTOR(7 downto 0);
  signal y:     STD_LOGIC_VECTOR(8 downto 0);

  signal z, x:  STD_LOGIC_VECTOR(7 downto 0);
  signal c:     STD_LOGIC_VECTOR(8 downto 0);
begin
    my_add: adder port map(a => a, b => b, cout => y(8), sum => y(7 downto 0), sub => '0');
    my_sub: adder port map(a => z, b => x, cout => open, sum => c(7 downto 0), sub => '1');

    process begin
      a <= STD_LOGIC_VECTOR(TO_UNSIGNED(15, a'length));
      b <= STD_LOGIC_VECTOR(TO_UNSIGNED(10, b'length));
      wait for 40 ns;
      report "15 + 10 = " & integer'image(to_integer(unsigned(y)));

      a <= STD_LOGIC_VECTOR(TO_UNSIGNED(11, a'length));
      b <= STD_LOGIC_VECTOR(TO_UNSIGNED(2, b'length));
      wait for 40 ns;
      report "11 + 2 = " & integer'image(to_integer(unsigned(y)));
      
      a <= STD_LOGIC_VECTOR(TO_UNSIGNED(1, a'length));
      b <= STD_LOGIC_VECTOR(TO_UNSIGNED(63, b'length));
      wait for 40 ns;
      report "1 + 63 = " & integer'image(to_integer(unsigned(y)));

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
    wait for 40 ns;

    z <= STD_LOGIC_VECTOR(TO_UNSIGNED(15, z'length));
    x <= STD_LOGIC_VECTOR(TO_UNSIGNED(10, x'length));
    wait for 40 ns;
    report "15 - 10 = " & integer'image(to_integer(signed(c)));

    z <= STD_LOGIC_VECTOR(TO_UNSIGNED(11, z'length));
    x <= STD_LOGIC_VECTOR(TO_UNSIGNED(2, x'length));
    wait for 40 ns;
    report "11 - 2 = " & integer'image(to_integer(signed(c)));
    
    z <= STD_LOGIC_VECTOR(TO_UNSIGNED(1, z'length));
    x <= STD_LOGIC_VECTOR(TO_UNSIGNED(63, x'length));
    wait for 40 ns;
    report "1 - 63 = " & to_string(c);

    a <= STD_LOGIC_VECTOR(TO_UNSIGNED(19, z'length));
    x <= STD_LOGIC_VECTOR(TO_UNSIGNED(46, x'length));
    wait for 40 ns;
    report "19 - 46 = " & integer'image(to_integer(signed(c)));

	  for aa in 0 to 255 loop
		for bb in 0 to 255 loop
			z <= STD_LOGIC_VECTOR(TO_UNSIGNED(aa, z'length));
     		x <= STD_LOGIC_VECTOR(TO_UNSIGNED(bb, x'length));			
			wait for 5 ns;
			if (aa - bb /= to_integer(signed(c))) then
				report integer'image(aa) & " - " & integer'image(bb) & " = " & integer'image(to_integer(signed(c))) severity error; 
			    wait;
			end if;
		end loop;
	  end loop;
      wait;
    end process;
end;
