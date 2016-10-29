In order to complete the Semantic Analyzer phase of our compiler we followed the following procedure:
	1. Installing basic classes
	2. Generating an inheritance graph
	3. Inserting value's into the scope table (DFS)
	4. Finding the least common ancestor
	5. Checking for cycles
	6. Checking the expression types

1. INSTALLING BASIC CLASSES:
	The main class in COOL is the Object class. Along with these there are 4 basic classes namely Bool, Int, IO, and String. Hashmaps were used to map parents to children. 
	The main methods were linked to their corresponding classes using maps and each method was paired with a list of formals apart from Int and Bool.

2. GENERATING THE GRAPH:
	InheritanceGraph: Here the inheritance graph of the Cool program is constructed. First, the
	basic classes Object and, Int, Bool, String and IO classes are added to the graph. The inheritance graph is made using two hash maps, namely the parent and children. Each class is given a unique id, for recognition purposes. Basic error handling is done as follows: 
		1. Checking that the name of the class is not "self"
		2. No two classes can have the same name
		3. Class cannot inherit SELF_TYPE or any of the basic classes
		4. Only one main class should exist.
	After checking for the basic errors, we check the Ineritance graph for methods and attributes as follows:
		1. Check if the method or attribute is inherited from its class
		2. If yes, then check the methods parameters, including:
			1. The number of parameters
			2. The types of the parameters
			3. The return type of the method
			4. Duplication of formals.
		If any of the above are not met, proper error messages are returned.

3. THE SCOPE TABLE AND DFS:
	We traverse the graph once again for type checking of expressions. The dfs function is called at the end of the inheritance graph and is only executed if no errors are encountered.
		1. We enter the scope table for each class and insert the corresponding attribute value in table. Both the attribute and its expression body are checked, ensuring that the return type of the expression matched the attribute. This is done by using ExprType function which returns the type based on expression instance.
		2. Methods are handled in a similar fashion, where for each method in a class we enter the scope and insert its corresponding formals. A similar expression type checking os done. Care needs to be taken with the formals such that the lowest common ancestor matches the return type of the method.

4. THE LEAST COMMON ANCESTOR:
	An iterative method is used to go up the graphs of both the input expressions, such that the closet common ancestor is returned, if there exists one, else a "no_type" is returned.

5. CHECKING FOR CYCLES:
	By the use of indicies in the graph, we check for cycles using recursion to all adjacent nodes. A boolean array known as visited is maintained and marked whenever a node visited. If a condition exists where a visited node is revisted, it means that there exists a cycle. This is an error because we don't want any cycles in our inheritance graph as this will cause confusion at later stages when we get further involved with inherited attributes.

6. CHECKING EXPRESSION TYPES:
	In this phase the type checking for the features of the classes takes place. This takes place in the dfs function as stated above and is implemented by the function exprType. The following the various rules for different expressions.

	1. Classes and No_expr (<type>):
		Here classes such as bool, int, and string are matched as well as "no expression" and the corresponding expression type is returned.

	2. Object class (<object>):
		The given object is searched for in the symbol table using the lookUpGlobal function. If no object is matched an error is raised and the string "Object" is returned.

	3.Assignment ( <id> = <expr> ):
		1. The id object must be a valid name in current scope or the scope of ancestors.
		2. The type of the expression of the right side must be an inherited type of the attribute on the left.
		3. The return type is the type of the expression on the right if it is valid otherwise 'Object'.

	4. Static Dispatch ( <expr>@<type_name>.<name>(<actual>) ):
		1. The class whose method is being called must be already be declared.
		2. The method being dispatched should be a valid method in the given class.
		3. The value of the formals of the method called must be exactly the same as the method being called in the original method.
		4. The type of the expr must be a valid child type of the class type_name.
		5. The return type of static dispatch is the type of the expression.

	5. Dispatch ( <type_name>.<name>(<actual>) ):
	The dispatch is checked within the static dispatch and it must conform to the above rules, given the that <expr> is replaced with the class that it is a member of.

	6. Condition ( if <predicate> then <then_expr> else <else_expr> ):
		1. The type of the predicate should be Bool
		2. The return type of the if condition is the lowest common ancestor of the then_expr and the else_expr.

	7.  Loop ( while <predicate> loop <body> pool ):
		1. The type of the predicate expression should be Bool.
		2. The return type of the loop is Object.

	8.  Case ( case [<id>:<type> [<- <expr>]]+ of [<id>:<type> => <expr>]+ esac ):	
		1. First the expr must be validated
		2. Each of the branch case must have a valid type.
		3. Two branch statements cannot have the same type.
		4. The return type of the expression type of the branch expression must be a valid child class of the declared type of the branch.
		5. The return type of the case statements is the LCA of all the types of the branches.

	9.  Block ( { <body> } ):
		1. Each of the statement in the body is evaluated.
		2. The return type of the block statement is the type of the last expression statement in block.
 
	10. Let ( { let <identifier>:<type_decl> in <body> } ):
		1. No identifier in the let can have name 'self'
		2. Initialization expression is evaluated. A new scope is entered.
		3. The type declaration and the assigned expression must be a valid sub class of the declared type.
		4. The type of the 'let' statement is the type of the body.

	11. Operators ( +,-,*,/,<,<=,~ ) :
		1. The left and right expressions must be of type Int.
		2. The return type in case of <, <= is Bool. Otherwise it is Int.
	
	12. Equality ( =,<,<=,not ):
		1. The left and right expression types must be equal.
		2.	The expression types can only be Int, Bool or String
		3. '<' and '<=' can only have Int in both expression types
		4. If there is no error the return type is bool, else "Object" is returned.

	13. Validating 'new' 
		1. The class must be a valid declared type in the inheritance graph.
		2. Return type is the type of the class.