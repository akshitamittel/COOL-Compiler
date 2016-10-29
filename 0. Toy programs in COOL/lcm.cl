(*A program to find the LCM and GCD of two numbers*)

class Main inherits IO {
  m: Int;
  n: Int;
  gcd: Int;
  lcm: Int;
  x: Int;
  a: Int;
  b: Int;
  temp: Int;
  main(): Object {{
    out_string("Enter the two numbers: \n");
    
    a <- in_int();
    b <- in_int();
    m <- a;
    n <- b; 
    while(not(n = 0)) loop
    {
      temp <- n;
      n <- m - (m/n)*n;  
      m <- temp;
    }
    pool;
    gcd <- temp;
    lcm <- a * b/gcd;
    
    out_string("The GCD is: ").out_int(gcd).out_string("\n");
    out_string("The LCM is: ").out_int(lcm).out_string("\n"); 
          
    }};
};
