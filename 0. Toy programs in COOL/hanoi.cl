
class Main inherits IO { 

  n: Int;
  a: String;
  b: String;
  c: String;

  main(): Object {{

  out_string("Enter the number of disks: ");
  n <- in_int();
  a <- "A";
  b <- "B";
  c <- "C";
  hanoi(n, a, b, c);

  }};

  hanoi(n: Int, a: String, c: String, b: String) : Object
  {
    if(n = 1) then
    {
      out_string("Move disk 1 from ").out_string(a).out_string(" to ").out_string(b).out_string("\n");
    }
    else
    {
      hanoi(n - 1, a , b, c);
      out_string("Move disk ").out_int(n).out_string(" from ").out_string(a).out_string(" to ").out_string(b).out_string("\n");
      hanoi(n - 1, c, b, a);
    }fi
  };
};

