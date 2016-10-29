(* Predefined List functionality *)

class List {
   -- Define operations on empty lists.

   isNil() : Bool { true };

   head()  : String { { abort(); ""; } };

   tail()  : List { { abort(); self; } };

   cons(i : String) : List {
      (new Cons).init(i, self)
   };

};

class Cons inherits List {

   car : String;	-- The element in this list cell

   cdr : List;	-- The rest of the list

   isNil() : Bool { false };

   head()  : String { car };

   tail()  : List { cdr };

   init(i : String, rest : List) : List {
      {
	 car <- i;
	 cdr <- rest;
	 self;
      }
   };

};


(*The main starts from here *)
(*A program to play HANGMAN!!!*)

class Main inherits IO {

   mylist : List;
   word : String;
   sub : String;
   before: String;
   after: String;
   letter: String;
   index : Int;
   hangman: String;
   check: List;
   i : Int;
   lives : Int;
   correct : Int;
   turn : Int;

   print_list(l : List) : Object {
      if l.isNil() then out_string("\n")
                   else {
			   out_string(l.head());
			   out_string(" ");
			   print_list(l.tail());
		        }
      fi
   }; 

  find_word(l: List, n: Int) : String {
    if n = 0 then l.head() else find_word(l.tail(), n - 1) fi
  };
  
  
  find_letter(l : List, x: String) : Bool{
    if l.isNil() then false else
     if l.head() = x then true else find_letter(l.tail(), x) fi
    fi
  };   

   main() : Object {
      {
	 mylist <- new List.cons("compilers").cons("networks").cons("system").cons("programming").cons("database");
         check <- new List.cons(" ");
	 out_string("Enter a random number: ");
         index <- in_int();
         index <- index - (index/5)*5;
	 word <- find_word(mylist, index);
         out_string("\n");
         out_string("**********\nLet the game begin!\n***********\n");
         i <- 0;
         hangman <- "";
         while( not(i = word.length())) loop
         {
            hangman <- hangman.concat("-");
            i <- i + 1;
         } pool;
         out_string(hangman).out_string("\n");
         lives <- 7;
         correct <- 0;
         while true loop
         {
          out_string("Lives left: ").out_int(lives).out_string("\n");
          out_string("Number of correct entries: ").out_int(correct).out_string("\n");
          out_string(hangman).out_string("\n");
          out_string("Enter a letter: ");
          letter <- in_string();
          if(find_letter(check, letter)) then
          {
            out_string("This letter has already been used.\nProceed to next turn...\n\n");
          }
          else
          {
            check <- check.cons(letter);
            i <- 0;
            turn <- 0;
            while i < word.length() loop
            {
              sub <- word.substr(i, 1);
              if(sub = letter) then
              {
                turn <- turn + 1;
                before <- hangman.substr(0, i);
                after <- hangman.substr(i + 1, hangman.length() - 1 - i);
                hangman <- "";
                hangman <- hangman.concat(before);
                hangman <- hangman.concat(letter);
                hangman <- hangman.concat(after);
                i <- i + 1;
              }
              else
              {
                i <- i + 1;
              }fi;
            }pool;
            if(turn = 0) then
            {
              lives <- lives - 1;
              if( lives = 0) then 
	      {
                out_string("**********\nYOU LOST!\nThe correct answer was: ").out_string(word).out_string("\n**********\n");
                "halt".abort();
              }
              else { out_string("\n"); }fi;
            }
            else
            {
              correct <- correct + turn;
              if(correct = word.length()) then 
	      {
                out_string("**********\nYOU WON!\n**********\n");
                "halt".abort();
              }
              else { out_string("\n"); }fi;
            }fi;
          }fi;
         }pool;
      
      }
   };

};



