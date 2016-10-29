(*A program to calculate the nth factorial*)

class Main inherits IO {
  main(): Object {{
    out_string("Enter n (>0): ");

    let n: Int <- in_int() in
      let fact: Int <- factorial(n) in
        out_string("The factorial is: ").out_int(fact);
        out_string("\n");
  }};

  factorial(num: Int): Int {
    if num = 0 then 1 else num * factorial(num - 1) fi
  };
};
