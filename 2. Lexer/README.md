# COOL Compiler #

# Lexical Analyser
The goal of the assignment was to write a lexical analyser for the Classroom Object Oriented Language (COOL) using Antlr, an automatic parser generator written in Java.

The code for the grammar is present in '\src\grammar\CoolLexer.g4'

The grammar is written to extract the following structures in COOL:
	1. Integer and Bool constants
	2. Other keywords and Identifiers
	3. Comments
	4. Whitespaces
	5 Strings

##Integer and Bool constants:
	These lexcial structures should be taken care of prior to the keywords and identifiers, to ensure that a keyword such as "True" or "Int" is not tokenized as an identifier.

## Comments:
	COOL has two forms of comments: Line and Block.
	Line comments are simple to handle, but care must be taken with the Block comments as they are nested. To handle Block comments one might use a recursive expression or a stack in Antlr to check the level of nesting.

## Strings:
	An unescaped newline in a string is assumed to be a fault of the programmer and we ignore it by moving onto the next line.
	We report an error if we encounter an EOF before the string closes.
	Other escape characters that need to be taken care of are handled in the processString function, after which a check is made on the strings length.

