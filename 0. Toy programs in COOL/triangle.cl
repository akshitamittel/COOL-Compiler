(*A program to print a number traingle of length n*)

class Main inherits IO {
  main(): Object {{
    out_string("Enter n (>0): ");
   
    let i: Int <- in_int() in
      while(0 < i) loop
      {
          let j : Int <- i in 
          while (0 < j) loop
          {
            out_int(j).out_string(" ");
            j <- j - 1;
          }
          pool;
          out_string("\n");
          i <- i - 1;
      }
      pool;
  }};
};
      
