(* Unterminated string literal
 *)

--single line comments

class Main {
	a : Int;
	main():IO {
		a <- 3 
		new IO.out_string("Hello
 world!\n")
	};
};

