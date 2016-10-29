(*A Program to check if the given number is even or odd
 (* Incorrect identifier notation.*)
*)

class Main inherits IO {
  n#: Int; --INcorrect identifier declaration.
  main(): Object{{
    out_string("Enter the number: ");
    n# <- in_int();

    if((n# - (n#/2)*2) = 0) then
    {
      out_string("The given number is\
                  even\n");
    }
    else
    {
       out_string("The given number is\
                  odd\n");
    }fi;
  }};
};
