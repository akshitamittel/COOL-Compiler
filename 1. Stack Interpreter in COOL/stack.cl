(* The Stack is implemented in a similar fashion to the predefined LIST in COOL 
 * The classes Pop and Push are sub-classes of the class Stack
 *)

class Stack {
   -- The stack is initisalized with "$" to avoid unnecessary aborts.
   top()  : String { { "$"; } };
   body()  : Stack { {self; } };

   push(i : String) : Stack {
      (new Push).insert(i, self)
   };
   
   pop() : Stack {
      (new Pop).rem(self.top(), self.body())
   };     
};

class Push inherits Stack {
   element : String;	
   program : Stack;	
   top()  : String { element };
   body()  : Stack { program };

   insert(i : String, rest : Stack) : Stack {
      {
	 element <- i;
	 program <- rest;
	 self;
      }
   };
};


class Pop inherits Stack {
   element : String;	
   program : Stack;	
   top()  : String { element };
   body()  : Stack { program };

   rem(i : String, rest : Stack) : Stack {
      {
	 element <- rest.top();
	 program <- rest.body();
	 self;
      }
   };
};

(*The main starts from here *)

class Main inherits IO {

   mylist : Stack;
   input : String;
   next : String;
   a : String;
   b : String;
   c : Int;
   aInt : Int;
   bInt : Int;
   cString : String;

   -- Printing the stack in the correct format. 
   printStack(s : Stack) : Object {
     if s.top() = "$" then out_string("")
       else {
	 out_string(s.top());
	 out_string("\n");
	 printStack(s.body());
       }
     fi
   }; 

   -- To check if we should execute or not. 
   check(next: String) : Bool {
    if( next = "+") then true else
      if(next = "s") then true else false fi
    fi
   };

   main() : Object {
      {
	 mylist <- new Stack.push("$");
         out_string(">");
         input <- in_string();

         while(not(input = "x")) loop
         {
           
           if(input = "d") then 
           {
             printStack(mylist);
           } 
           else
           {
             if(input = "e") then
             {
               next <- mylist.top();
               if(check(next)) then
               {
                 mylist <- mylist.pop();
                 a <- mylist.top();
                 mylist <- mylist.pop();
                 b <- mylist.top();
                 mylist <- mylist.pop();
                 if(next = "s") then
                 {
                    mylist <- mylist.push(a);
                    mylist <- mylist.push(b);
                 }
                 else
                 {
                    aInt <- (new A2I).a2i(a);
                    bInt <- (new A2I).a2i(b);
                    c <- aInt + bInt;
                    cString <- (new A2I).i2a(c);
                    mylist <- mylist.push(cString);
                 }fi;
               }
               else
               {
                 next <- mylist.top();
               }fi;
             }
             else
             {
               mylist <- mylist.push(input);
             }fi;
           }fi;
           out_string(">");
           input <- in_string();
         }pool;
      }   
   };
};
