# COOL Compiler #

ANTLR 4.5 was used to generate the parser for this assignment.

The main division of the parser is as follows:

program -> class_list:
			The class list constitutes of the seperate classes in the program. There are one or more classes in the program. 

				(c = class_entity {$value.add($c.value);}  SEMICOLON)+ 

			Each class in the class_list is embeddded with an action. i.e. The action is embedded within the parsing rule, so that the parent rule (program), maps to each class when generating the AST. If the action was defined outside the list, only a link to the last child (in this case the last class) would be maintained by the parser.


class_list -> feature_list
			A feature list is a list of the entities of a class which are separated by a colon. Each feture could either be a method (function), or an attribute such as an assignment.

			The method_entity has a list of parameters, in this case they are called formal. Each formal is an expression which is separated by a comma. The implementation of a formal list is as follows:
				(f = formal_entity {$value.add($f.value);}(COMMA f = formal_entity {$value.add($f.value);})*)?
			where is formal_entity is just a paramenter (object) with a type.

Both the features consist of building blocks known as expressions. The expression lies within the body of the rule.
		method -> object(formals):TYPE { expr_body}
		attr -> object:TYPE <- expression

The main crux of our program lies in the expressions. One of the main advantages of ANTLR 4 is that it handles left recursion and left factioning as long as the concerned elements do not span a range of rules. I.e the left recursion is limited to one rule. Precedence can be enforced as ANTLR guarantees to match the first rule in the grammar to expression. This means that if we have the grammar as follows:
	expr :
		expr * expr
	|
		expr + expr
	;
And we have the following expression: a + b * c
This will first map to expr * expr and then expr + expr, so that the semantics are maintained by the AST tree generated.

expr -> ..
			The expression rule uses the two features defined above heavily. In order to enforce the precedence as specified by the COOL manual in section 11, we define rules with greater precedence first. 

			The way we defined the expression rule is as follows:
				1. Dispacth 
				2. Static dispatch
				3. Arithmetic and logical operations (following precedence).
				4. Assignment operator
				5. Definition of types such as int, string, bool, and OBJECTID
				6. Block list
				7. Loops and conditions. If, While, Case, and Let

	1. DISPATCH AND STATIC DISPATCH:
		These are again method calling functionalities. The main difference between a Dispacth and a method is that dispatchs may have expressions as their parameters and since they are calling methods they do not have a body of thier own. The list of "parameters", in this case expressions, was defined in a similar fashion to formals for the method feature
			expr -> expr.OBJECT([[expr[,expr]*]])

	3. ARITHMETIC AND LOGICAL EXPRESSIONS:
		We discussed how the precendence was maintained. The rest was a straight forward mapping of rules. 

	4. ASSIGNMENT OPERATOR:
		The definition is similar to attr_entity. The only difference is that the assignment is not an optional construct.

	5. TYPE DEFINITIONS:
		For types such as bool and ints, the expressions were typecasted to ensure that the AST tree holds the correct format of the node when used in semantic analysis.
		The typecasting was done as follows:
			new AST.int_const(Integer.parseInt($i.getText())
		Where i is the token that had matched the int.

	6. BLOCK LIST:
		A block list is a list of expressions sepearated by semicolons enclosed in braces. The method used to maintain a list of classes, features, formals was implemented to define the block list.

	7. LOOP, IF, CASE, & LET
		The implementation of If and While is a simple mapping to the rules in the COOL manual. The grammar for case was a bit more intricate. Since case maps to several different branches, and each branch follows the same rule, a list had to be maintained to store all the branches. Where each entity was mapped onto a token that match the AST.branch.
		Let expression:
			 The complication with this mapping is that we have to map several attributes to one. Therefore we have to nest multiple let expressions in a loop. The let expression of every next let expression becomes the body of the previous one. The list of attributes is mapped by attrib_list.

---------------------------------------------------------------------------------------------
GENERAL:

	Each rule returned a value which was of the type AST.class. Where class is the nearest parent class of all the sub rules involved.

	For each rule that comprised of a valid bottom level expression (an expression that would generate leaves), a new object was created and returned to the parent rule. 
	The object that was created had a type which belonged to one of the sub_classes of ASTNode. It is these objects that create the various nodes of the AST parse tree. 

	Each new object (node) created was initialized with parameters as specificed by the subclass constructor. 

	The line numbers were obtained as follows:

		If the element whose line number was to be obtained belonged to the set of predefined tokens, i.e CASE, a value storing that TOKEN would be called to get the line no.
		eg: 
			c=CASE e=expression_entity OF ...

			LINE# = $c.getLine()

		If the element whose line number was to be obtained did not belong to the set of predefined tokens, the line number would be obtained as follows:

			e1=expression_entity LE e2=expression_entity

			LINE# = $e1.value.lineNo
