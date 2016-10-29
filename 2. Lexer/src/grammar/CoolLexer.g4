lexer grammar CoolLexer;

tokens{
	ERROR,
	TYPEID,
	OBJECTID,
	BOOL_CONST,
	INT_CONST,
	STR_CONST,
	LPAREN,
	RPAREN,
	COLON,
	ATSYM,
	SEMICOLON,
	COMMA,
	PLUS,
	MINUS,
	STAR,
	SLASH,
	TILDE,
	LT,
	EQUALS,
	LBRACE,
	RBRACE,
	DOT,
	DARROW,
	LE,
	ASSIGN,
	CLASS,
	ELSE,
	FI,
	IF,
	IN,
	INHERITS,
	LET,
	LOOP,
	POOL,
	THEN,
	WHILE,
	CASE,
	ESAC,
	OF,
	NEW,
	ISVOID,
	NOT
}

/*
  DO NOT EDIT CODE ABOVE THIS LINE
*/

@members{

	/*
		YOU CAN ADD YOUR MEMBER VARIABLES AND METHODS HERE
	*/

	/**
	* Function to report errors.
	* Use this function whenever your lexer encounters any erroneous input
	* DO NOT EDIT THIS FUNCTION
	*/
	public void reportError(String errorString){
		setText(errorString);
		setType(ERROR);
	}

	public void unmatched(){
		Token t = _factory.create(_tokenFactorySourcePair, _type, _text, _channel, _tokenStartCharIndex, getCharIndex()-1, _tokenStartLine, _tokenStartCharPositionInLine);
		String text = t.getText();
		reportError(text);
	}

        public void comment() {
		Token t = _factory.create(_tokenFactorySourcePair, _type, _text, _channel, _tokenStartCharIndex, getCharIndex()-1, _tokenStartLine, _tokenStartCharPositionInLine);
		String text = t.getText();
		
		text = text.substring(2, text.length() - 2);		

		int itr = 0, i = 0;
                while( itr < text.length())
		{
			if(text.charAt(itr) == '(' && text.charAt(itr + 1) == '*') { i++; itr += 2;}
                        else if(text.charAt(itr) == '*' && text.charAt(itr + 1) == ')') { i--; itr += 2;}
			else { itr++;} 
		}
                if( i == 1) reportError("EOF in comment");
	}		

	public void processString() {
		Token t = _factory.create(_tokenFactorySourcePair, _type, _text, _channel, _tokenStartCharIndex, getCharIndex()-1, _tokenStartLine, _tokenStartCharPositionInLine);
		String text = t.getText();

		//write your code to test strings here
                text = text.substring(1, text.length() -1);
                String newString  = "";
		if(text.length() > 1024) 
                {
                	reportError("String constant too long");
		}
		else
		{
			int itr = 0;
			while(itr < text.length())
			{
				if(text.charAt(itr) == '\n') 
                                {
					reportError("Unterminated string constant");
				}
				else if(text.charAt(itr) == '\0')
				{
					 reportError("String contains null character");
				}
				else if(text.charAt(itr) == '\\')
				{
                                        char next = text.charAt(itr + 1);
                                        switch(next) {
					case 'n':
						newString = newString.concat("\n");
						break;
					case '\n':
						newString = newString.concat("\n");
						break;
					case '0':
						newString = newString.concat("0");
						break;
					case 'b':
						newString = newString.concat("\b");
						break;
					case 'f':
						newString = newString.concat("\f");
						break;
					case 't':
						newString = newString.concat("\t");
						break;
					default :
						newString = newString.concat(String.valueOf(text.charAt(itr +1)));
						break;
 					}
					itr += 2;
					continue;
				}
				else
				{
					 newString = newString.concat(String.valueOf(text.charAt(itr)));
				}
				itr += 1;
			}
			setText(newString);
		}
	}
}

/*
	WRITE ALL LEXER RULES BELOW
*/

SEMICOLON   : ';';
DARROW      : '=>';
LPAREN	    : '(';
RPAREN	    : ')';
COMMA	    : ',';
PLUS	    : '+';
MINUS	    : '-';
STAR	    : '*';
SLASH	    : '/';
TILDE	    : '~';
LT	    : '<';
LE	    : '<=';
EQUALS	    : '=';
LBRACE	    : '{';
RBRACE	    : '}';
DOT	    : '.';
ASSIGN	    : '<-';
ATSYM	    : '@';
COLON	    : ':';

//Keywords

CASE		: ('c'|'C')('a'|'A')('s'|'S')('e'|'E');
ESAC		: ('e'|'E')('s'|'S')('a'|'A')('c'|'C');
IF		: ('i'|'I')('f'|'F');
FI		: ('f'|'F')('i'|'I');
WHILE		: ('w'|'W')('h'|'H')('i'|'I')('l'|'L')('e'|'E');
THEN		: ('t'|'T')('h'|'H')('e'|'E')('n'|'N');
ELSE		: ('e'|'E')('l'|'L')('s'|'S')('e'|'E');
LOOP		: ('l'|'L')('o'|'O')('o'|'O')('p'|'P');
POOL		: ('p'|'P')('o'|'O')('o'|'O')('l'|'L');
CLASS		: ('c'|'C')('l'|'L')('a'|'A')('s'|'S')('s'|'S');
IN		: ('i'|'I')('n'|'N');
INHERITS	: ('i'|'I')('h'|'H')('e'|'E')('r'|'R')('i'|'I')('t'|'T')('s'|'S');
OF		: ('o'|'O')('f'|'F');
LET		: ('l'|'L')('e'|'E')('t'|'T');
NEW		: ('n'|'N')('e'|'E')('w'|'W');
ISVOID		: ('i'|'I')('s'|'S')('v'|'V')('o'|'O')('i'|'I')('d'|'D');
NOT		: ('n'|'N')('o'|'O')('t'|'T');

//ID's
fragment DIGIT	: '0'..'9';
fragment LLETTER: 'a'..'z';
fragment ULETTER: 'A'..'Z';
fragment LETTER	: ('a'..'z'|'A'..'Z');
fragment TRUE	: 't'('r'|'R')('u'|'U')('e'|'E');
fragment FALSE	: 'f'('a'|'A')('l'|'L')('s'|'S')('e'|'E');
BOOL_CONST	: (TRUE|FALSE);
INT_CONST	: DIGIT+;
TYPEID		: ULETTER('_'|LETTER|DIGIT)*;
OBJECTID	: LLETTER('_'|LETTER|DIGIT)*;

//Strings and whitesapce
WHITESPACE 	: [ \r\t\n\f]+ -> skip ;
EOF_STRING	: ('"' ( '\\' | WHITESPACE | ~('\\'|'"') )* )(EOF){reportError("EOF found in string");};
SINGLE_BACKSLASH: ('"')('\\')('"') {reportError("single Backslash found in string");};
STR_CONST 	: '"' ( '\\' | ~('"'| '\n') | WHITESPACE )* '"' {processString();};

//Comments
fragment OPEN	: ~["(*"];
fragment CLOSE	: ~["*)"];
SL_COMMENT	: '--'(.)*? ('\n'|'\r') -> skip;
ML_COMMENT 	: '(*' (ML_COMMENT |.)*? '*)'->skip;
//EOF_COMMENT	: '(*' .* (EOF) {reportError("EOF In Comment.");};
E_COMMENT	: '*)' {reportError("UnMatched comment identifier.");};

OTHER		: . {unmatched();}; 
