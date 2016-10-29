parser grammar CoolParser;

options {
	tokenVocab = CoolLexer;
}

@header{
	import cool.AST;
	import java.util.List;
}

@members{
	String filename;
	public void setFilename(String f){
		filename = f;
	}

/*
	DO NOT EDIT THE FILE ABOVE THIS LINE
	Add member functions, variables below.
*/

}

/*
	Add Grammar rules and appropriate actions for building AST below.
*/

program returns [AST.program value]	: 
						cl=class_list EOF 
							{
								$value = new AST.program($cl.value, $cl.value.get(0).lineNo);
							}
					;

/* The class_list returns a list of class_entity's.
 * Each component of the rule has a nested action to account for all the classes in the parse tree.
 * Without nesting only the last instance of the class will be parsed.
 * class_entity creates a new AST node of the form class_
 * There are two types of declarations for class.
 */
class_list returns [List<AST.class_> value]
	@init
	{
		$value = new ArrayList<AST.class_>();
	}
	:
		(c = class_entity {$value.add($c.value);}  SEMICOLON)+ 
	;


//class TYPE [inherits TYPE] { [[feature;]]+ };
class_entity returns [AST.class_ value] :
		class_key=CLASS name=TYPEID LBRACE fl=feature_list RBRACE
			{
				$value = new AST.class_($name.getText(),filename,"Object",$fl.value,$class_key.getLine());
			}
	|
		class_key=CLASS name=TYPEID INHERITS flash=TYPEID LBRACE fl=feature_list RBRACE
			{
				$value = new AST.class_($name.getText(),filename,$flash.getText(),$fl.value,$class_key.getLine());
			}
	;

/* feature_list -> [[feature;]]+
 * The feature list returns a list of features followed by  a semicolon.
 * The features are either method or attributes, which are accounted by method_entity and attr_entity.
 */
feature_list returns [List<AST.feature> value] 
	@init
	{
		$value = new ArrayList<AST.feature>();
	}
	:
		(f = feature_entity  SEMICOLON)* {$value.add($f.value);}
	;

feature_entity returns [AST.feature value] :
		me = method_entitiy
			{
				$value = $me.value;
			}
	|
		ae = attr_entity
			{
				$value = $ae.value;
			}
	;

/* 
	attr_entity -> object:TYPE [<- expr]
 */
attr_entity returns [AST.attr value] :
		object_key=OBJECTID COLON name=TYPEID ASSIGN ex=expression_entity
			{
				$value = new AST.attr($object_key.getText(), $name.getText(),$ex.value, $object_key.getLine());
			}
	|
		object_key=OBJECTID COLON name=TYPEID 
			{
				$value = new AST.attr($object_key.getText(), $name.getText(), new AST.no_expr($object_key.getLine()), $object_key.getLine());
			}
	;

/* method_entity -> object(formal [[,formal]]*):TYPE { expr }
 * The formal list is a list of parameters.
 * Each parameter is known as a formal.
 */
method_entitiy returns [AST.method value] :
		object_key=OBJECTID LPAREN fl=formal_list RPAREN COLON name=TYPEID LBRACE ex=expression_entity RBRACE
			{
				$value = new AST.method($object_key.getText(), $fl.value, $name.getText(),$ex.value, $object_key.getLine());
			}
	;

formal_list returns [List<AST.formal> value] 
	@init
	{
		$value = new ArrayList<AST.formal>();
	}
	:
		(f = formal_entity {$value.add($f.value);}(COMMA f = formal_entity {$value.add($f.value);})*)?
	;

formal_entity returns [AST.formal value] :
		object_key=OBJECTID COLON name=TYPEID
			{
				$value = new AST.formal($object_key.getText(), $name.getText(), $object_key.getLine());
			}
	;

// not_expr -> not expr
not_expr returns [AST.neg value] :
	NOT e=expression_entity { $value = new AST.neg($e.value, $e.value.lineNo); }; 

/* e_list is a list of expressions.
 * These are used in dispatch.
 */
e_list returns [List<AST.expression> value] 
	@init
	{
		$value = new ArrayList<AST.expression>();
	}
	:
		(e=expression_entity{$value.add($e.value);}(COMMA e = expression_entity {$value.add($e.value);})*)?

	;

expression_entity returns [AST.expression value] :
	/* DISPATCH EXPRESSION
	 * expr -> expr.OBJECT([[expr[,expr]*]])
	 * expr -> OBJECT([[expr[,expr]*]])
	 */
		e_caller=expression_entity DOT object_key=OBJECTID LPAREN e=e_list RPAREN
			{
				$value = new AST.dispatch($e_caller.value, $object_key.getText(), $e.value, $object_key.getLine());
			}
	|
		object_key=OBJECTID LPAREN e=e_list RPAREN
			{
				$value = new AST.dispatch(new AST.no_expr($object_key.getLine()), $object_key.getText(), $e.value, $object_key.getLine());
			}
	/* STATIC DISPATCH EXPRESSION
	 * expr -> expr@TYPE.OBJECT([[expr[,expr]*]])
	 */
	
	|	e_caller=expression_entity ATSYM name=TYPEID DOT object_key=OBJECTID LPAREN e=e_list RPAREN
			{
				$value = new AST.static_dispatch($e_caller.value, $name.getText(), $object_key.getText(), $e.value, $e_caller.value.lineNo);
			}	
	/*
	 	The arithmetic and logical rules start from here.
	 	They follow the precedence order specified in the COOL manual.
	 */
	|	//expr -> ~expr
		ce = comp_expr
		{
			$value = $ce.value;
		}
	|	//expr -> isvoid expr
		ie = isvoid_expr
		{
			$value = $ie.value;
		}

	|	//expr -> expr * expr
		e1=expression_entity STAR e2=expression_entity
		{
			$value = new AST.mul($e1.value, $e2.value, $e1.value.lineNo);
		}

	|	//expr -> expr / expr
		e1=expression_entity SLASH e2=expression_entity
		{
			$value = new AST.divide($e1.value, $e2.value, $e1.value.lineNo);
		}
	
	|	//expr -> expr + expr
		e1=expression_entity PLUS e2=expression_entity
		{
			$value = new AST.plus($e1.value, $e2.value, $e1.value.lineNo);
		}
	
	|	//expr -> expr - expr
		e1=expression_entity MINUS e2=expression_entity
		{
			$value = new AST.sub($e1.value, $e2.value, $e1.value.lineNo);
		}
	
	|	//expr -> expr <= expr
		e1=expression_entity LE e2=expression_entity
		{
			$value = new AST.leq($e1.value, $e2.value, $e1.value.lineNo);
		}

	|	//expr -> expr < expr
		e1=expression_entity LT e2=expression_entity
		{
			$value = new AST.lt($e1.value, $e2.value, $e1.value.lineNo);
		}
	
	|	//expr -> expr = expr
		e1=expression_entity EQUALS e2=expression_entity
		{
			$value = new AST.eq($e1.value, $e2.value, $e1.value.lineNo);
		}

	|	//expr -> not expr
		ne = not_expr
			{
				$value = $ne.value;
			}
	| 	//OBJECT <- expr
		ae = assign_expr
			{
				$value = $ae.value;
			}
	|	//expr -> (expr)
		nse = nest_expr
			{
				$value = $nse.value;
			}
	|	//expr -> TYPE
		idd = id_def
			{
				$value = $idd.value;
			}

	|	//expr -> int
		intd = int_def
			{
				$value = $intd.value;
			}
	|	//expr -> string
		strd = string_def
			{
				$value = $strd.value;
			}
	|	//expr -> bool
		bod = bool_def
			{
				$value = $bod.value;
			}
	|	//expr -> if expr then expr else expr fi
		fex = for_expr
			{
				$value = $fex.value;
			}
	|	//expr -> while expr loop expr pool
		wex = while_expr
			{
				$value = $wex.value;
			}
	|	//{ [expr]* }
		lb=LBRACE bl=block_list RBRACE
		{
			$value = new AST.block($bl.value,$lb.getLine());
		}
	|	//expr -> let [OBJECT:TYPE [<- expr]}]+ in expr
		lete = let_expr
		{
			$value = $lete.value;
		}
	
	|	//case expr
		cex = case_expr
			{
				$value = $cex.value;
			}
	|	//expr -> new expr
		nex = new_expr
			{
				$value = $nex.value;
			}
	;

assign_expr returns [AST.assign value] :
	object_key=OBJECTID ASSIGN e=expression_entity
		{
			$value = new AST.assign($object_key.getText(), $e.value, $object_key.getLine());
		}
	;

for_expr returns [AST.cond value]:
	IF p=expression_entity THEN i=expression_entity ELSE e=expression_entity FI
		{
			$value = new AST.cond($p.value, $i.value, $e.value, $p.value.lineNo);
		}
	;

while_expr returns [AST.loop value] :
	WHILE e1=expression_entity LOOP e2=expression_entity POOL 
		{
			$value = new AST.loop($e1.value, $e2.value, $e1.value.lineNo);
		}
	;
//block_list -> [expr;]+
block_list returns [List<AST.expression> value]
	@init
	{
		$value = new ArrayList<AST.expression>();
	}
	:
		(e = expression_entity {$value.add($e.value);} SEMICOLON)+
	;

case_expr returns [AST.typcase value] :
	CASE e1=expression_entity OF bl=branch_list ESAC
		{
			$value = new AST.typcase($e1.value, $bl.value, $e1.value.lineNo);
		}
	;
/* branch_list holds all the cases for the case 
 * branch_entity corresponds to a single branch.
 * branch_entity -> expr:TYPE => expr ;
 */
branch_list returns [List<AST.branch> value]
	@init
	{
		$value = new ArrayList<AST.branch>();
	}
	:
		(b = branch_entity {$value.add($b.value);})+
	;


branch_entity returns [AST.branch value] :
	object_key=OBJECTID COLON name=TYPEID DARROW ex=expression_entity SEMICOLON
		{
			$value = new AST.branch($object_key.getText(), $name.getText(),$ex.value, $object_key.getLine());
		}
	;

new_expr returns [AST.new_ value] :
	NEW object_key=TYPEID
		{
			$value = new AST.new_($object_key.getText(), $object_key.getLine());
		}
	;

isvoid_expr returns [AST.isvoid value] :
	ISVOID e=expression_entity
		{
			$value = new AST.isvoid($e.value, $e.value.lineNo);
		}
	;

nest_expr returns [AST.expression value] :
	LPAREN e=expression_entity RPAREN
		{
			$value = new AST.expression();
		}
	;

id_def returns [AST.object value] :
	object_key=OBJECTID
		{
			$value = new AST.object($object_key.getText(), $object_key.getLine());
		}
	;

type_def returns [AST.object value] :
	object_key=TYPEID
		{
			$value = new AST.object($object_key.getText(), $object_key.getLine());
		}
	;

int_def returns [AST.int_const value] :
	i=INT_CONST { $value = new AST.int_const(Integer.parseInt($i.getText()), $i.getLine());}
	;

string_def returns [AST.string_const value] :
	s=STR_CONST { $value = new AST.string_const($s.getText(), $s.getLine());}
	;

bool_def returns [AST.bool_const value] :
	b=BOOL_CONST { $value = new AST.bool_const(Boolean.parseBoolean($b.getText()), $b.getLine());}
	;

comp_expr returns [AST.comp value] :
	TILDE e=expression_entity { $value = new AST.comp($e.value, $e.value.lineNo); };

/* expr -> let object:TYPE [<- expr] [, object:TYPE [<- expr]]* in expr.
 * The complication with this mapping is that we have to map several attributes to one.
 * Therefore we have to nest multiple let expressions in a loop.
 * The let expression of every next let expression becomes the body of the previous one.
 * The list of attributes is mapped by attrib_list.
 */
let_expr returns [AST.let value] :
	LET a_list=attrib_list IN e=expression_entity
        {  
            AST.attr current;
            int i = $a_list.value.size()-1;
            current=$a_list.value.get(i);
            $value = new AST.let(current.name, current.typeid, current.value, $e.value, $a_list.value.get(0).lineNo);
            i = $a_list.value.size()-2;
            while(i >= 0 )
            {
                current=$a_list.value.get(i);
                $value = new AST.let(current.name, current.typeid, current.value, $value, $a_list.value.get(0).lineNo);
                i--;
            }
        }
    ;

attrib_list returns [List <AST.attr> value] 
	@init
	{
		$value = new ArrayList<AST.attr>();
	}
	:
		a = attr_entity {$value.add($a.value);}(COMMA a = attr_entity {$value.add($a.value);})*
	;