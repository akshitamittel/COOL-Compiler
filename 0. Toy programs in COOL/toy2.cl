(*A Program to check if the given number is even or odd
 (* Inserted a non escaped new line.*)
*)

class Main inherits IO {
  n: Int;
  main(): Object{{
    out_string("Enter the number: ");
    n <- in_int();

    if((n - (n/2)*2) = 0) then
    {
      out_string("The given number is  --Creation of a non-escaped newline.
                  even\n");
    }
    else
    {
       out_string("The given number is\
                  odd\n");
    }fi;
  }};
};
