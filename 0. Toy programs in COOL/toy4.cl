(*A Program to check if the given number is even or odd
 (* Key words are case sensitive.*)
*)

class Main inherits IO {
  n: Int;
  main(): Object{{
    out_string("Enter the number: ");
    n <- in_int();

    if((n - (n/2)*2) = 0) THEN --Key words are case- sensitive.
    {
      out_string("The given number is\
                  even\n");
    }
    else
    {
       out_string("The given number is\
                  odd\n");
    } --removed neccesary keyword 'fi'. 
  }};
};
