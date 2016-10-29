(*A program to play a dumb version of tictactoe*)

class Main inherits IO {  
  tictactoe: String;
  coloumn: Int;
  row: Int;
  position: Int;
  turn: Int;
  player: String;
  before: String;
  after: String;

  main(): Object {{
  
  turn <- 0;
  player <- "X";
  
  tictactoe <- " | | \n- - -\n | | \n- - -\n | | \n";
  
  out_string("Let the game begin! \n").out_string(tictactoe).out_string("\n");

  
  while true loop
  {
    if((turn - (turn/2)*2) = 0) then { player <- "X"; } else { player <- "O"; }fi;
 
    out_string("Currently playing: Player ").out_string(player);
    out_string("\nEnter coloumn: ");
    coloumn <- in_int();
    out_string("Enter row: ");
    row <- in_int();
    position <- (2*coloumn) + (12*row);
    turn <- turn + 1;
    if( position <= 30) then
    {
       before <- tictactoe.substr(0, position);
       after <- tictactoe.substr(position + 1, tictactoe.length() - 1 - position);
       tictactoe <- "";
       tictactoe <- tictactoe.concat(before);
       tictactoe <- tictactoe.concat(player);
       tictactoe <- tictactoe.concat(after);
       out_string("The current board is: \n").out_string(tictactoe).out_string("\n");
    }
    else
    {
      out_string("Incorrect board co-ordinate, please choose another one: \n\n");
      turn <- turn - 1;
    }fi;
  }pool;
  
  out_string(tictactoe);
  }};
};
