(*A program to calculate the nth fibonnaci*)

class Main inherits IO {
  main(): Object {{
    out_string("Enter n (>0): ");

    let n: Int <- in_int() in
      let fib: Int <- fibonacci(n) in
        out_string("The nth term of the fibonacci is: ").out_int(fib);
        out_string("\n");
  }};

  fibonacci(num: Int): Int {
    if num = 0 then 0 
    else 
      if num = 1 then 1 else fibonacci(num - 1) + fibonacci(num - 2) fi 
    fi
  };
};
