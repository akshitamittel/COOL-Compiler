(*A Program to check if the given number is prime*)

class Main inherits IO {
  n: Int;
  main(): Object {{
    out_string("Enter the number: ");
    n <- in_int();
    let i:Int <- 2 in
      while(i < n) loop
      {
         if(n = 1) then
         {
             out_string("Not a Prime!\n");
             "halt".abort();
         }
         else
         {
           if(n = 2) then
           {
              out_string("Prime!\n");
              "halt".abort();
           }
           else
           {
             if((n - (n/i)*i) = 0) then
             {
               out_string("Not a prime!\n");
               "halt".abort();
             }
             else {
               i <- i + 1;
             }fi;
           }fi;
         }fi;
    }pool;
    out_string("Prime!\n");
  }};
};
   
               
