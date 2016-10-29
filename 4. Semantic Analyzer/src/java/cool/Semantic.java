package cool;
import java.util.*;

public class Semantic{
	private boolean errorFlag = false;
	private boolean foundMain = false;
	private Map<String, String> parent = new HashMap<String, String>();
	private Map<String, ArrayList<String>> children = new HashMap<String, ArrayList<String>>(); 
	private HashMap<Integer, ArrayList<Integer>> graph = new HashMap<Integer, ArrayList<Integer>>();
	private HashMap<String, Integer> ids = new HashMap<String, Integer>();
	private ArrayList<String> str=new ArrayList<String>();
	private ArrayList<Integer> inter=new ArrayList<Integer>();
	private ScopeTable<AST.attr> table = new ScopeTable<AST.attr>();
	private Map<String, Map<String, List<AST.formal>>> basic_classes= new HashMap<String, Map<String, List<AST.formal>>>() ;
	private Map<String,Map<String,AST.method>> class_methods = new HashMap<String,Map<String,AST.method>>() ;
	private Map<String,Map<String,AST.attr>> class_attrs = new HashMap<String,Map<String,AST.attr>>();
	private	HashMap<String, AST.method> main_methods=new HashMap<String, AST.method>();
	private int a = 1;

	public void reportError(String filename, int lineNo, String error){
		errorFlag = true;
		System.err.println(filename+":"+lineNo+": "+error);
	}
	public boolean getErrorFlag(){
		return errorFlag;
	}

/*
	Don't change code above this line
*/
	public Semantic(AST.program program){
		
		//Write Semantic analyzer code here
		//(Akshita): Removed public accessor

		boolean ig = InheritanceGraph(program);

	
		
	}

	public void install_basic_classes()
	{

		AST.no_expr noex=new AST.no_expr(1);

		//BASIC METHODS OF OBJECT
		basic_classes.put("Object", new HashMap<String,List<AST.formal>>());
		basic_classes.get("Object").put("abort", new LinkedList<AST.formal>());
		basic_classes.get("Object").put("type_name", new LinkedList<AST.formal>());
		basic_classes.get("Object").put("copy", new LinkedList<AST.formal>());

		
		
		//BASIC METHODS OF IO
		basic_classes.put("IO", new HashMap<String,List<AST.formal>>());
		basic_classes.get("IO").put("out_string", new LinkedList<AST.formal>());
		basic_classes.get("IO").get("out_string").add(new AST.formal("a","String",1));
		basic_classes.get("IO").put("out_int", new LinkedList<AST.formal>());
		basic_classes.get("IO").get("out_int").add(new AST.formal("a","Int",1));
		basic_classes.get("IO").put("in_int", new LinkedList<AST.formal>());
		basic_classes.get("IO").put("in_string", new LinkedList<AST.formal>());

		//BASIC METHODS OF STRING
		basic_classes.put("String", new HashMap<String,List<AST.formal>>());
		basic_classes.get("String").put("length", new LinkedList<AST.formal>());
		basic_classes.get("String").put("concat",new LinkedList<AST.formal>());
		basic_classes.get("String").get("concat").add(new AST.formal("a","String",1));
		basic_classes.get("String").put("substr",new LinkedList<AST.formal>());
		basic_classes.get("String").get("substr").add(new AST.formal("a","Int",1));
		basic_classes.get("String").get("substr").add(new AST.formal("b","Int",1));

		//BASIC METHODS OF INT, BOOL: NONE
		basic_classes.put("Int", new HashMap<String,List<AST.formal>>());
		basic_classes.put("Bool", new HashMap<String,List<AST.formal>>());

		
		class_methods.put("Object",new HashMap<String,AST.method>());
		class_methods.get("Object").put("abort",new AST.method("abort",basic_classes.get("Object").get("abort"),"Object", noex,1));
		class_methods.get("Object").put("type_name", new AST.method("type_name",basic_classes.get("Object").get("type_name"),"String", noex,1));
		class_methods.get("Object").put("copy",new AST.method("copy",basic_classes.get("Object").get("copy"),"Object", noex,1));

		class_methods.put("IO",new HashMap<String,AST.method>());
		class_methods.get("IO").put("out_string", new AST.method("out_string",basic_classes.get("IO").get("out_string"),"IO",new AST.no_expr(1),1));
		class_methods.get("IO").put("out_int", new AST.method("out_int",basic_classes.get("IO").get("out_int"),"IO",new AST.no_expr(1),1));
		class_methods.get("IO").put("in_int", new AST.method("in_int",basic_classes.get("IO").get("in_int"),"Int",new AST.no_expr(1),1));
		class_methods.get("IO").put("in_string", new AST.method("in_string",basic_classes.get("IO").get("in_string"),"String",new AST.no_expr(1),1));

		class_methods.put("String",new HashMap<String,AST.method>());
		class_methods.get("String").put("length", new AST.method("length",new LinkedList<AST.formal>(),"Int",new AST.no_expr(1),1));
		class_methods.get("String").put("concat", new AST.method("concat",basic_classes.get("String").get("concat"),"String",new AST.no_expr(1),1));
		class_methods.get("String").put("substr",new AST.method("substr",basic_classes.get("String").get("substr"),"String",new AST.no_expr(1),1));

		class_methods.put("Int",new HashMap<String,AST.method>());
		class_methods.put("Bool",new HashMap<String,AST.method>());
		
	}

	public boolean InheritanceGraph(AST.program p)
	{
		HashMap<String,Map<String,AST.method>> temp_methods=new HashMap<String,Map<String,AST.method>>();
		HashMap<String,Map<String,AST.attr>> temp_attrs=new HashMap<String,Map<String,AST.attr>>();
		parent.put("Object",null);
		ids.put("Object",0);
		children.put("Object", new ArrayList<String>());
		graph.put(0,new ArrayList<Integer>());
		class_attrs.put("Object",new HashMap<String,AST.attr>());
		class_methods.put("Object",new HashMap<String,AST.method>());
		temp_methods.put("Object",new HashMap<String,AST.method>());
		temp_attrs.put("Object",new HashMap<String,AST.attr>());
		class_attrs.put("Int",new HashMap<String,AST.attr>());
		temp_attrs.put("Int",new HashMap<String,AST.attr>());
		parent.put("Int","Object");
		ids.put("Int",1);
		temp_methods.put("Int",new HashMap<String,AST.method>());
		class_methods.put("Int",new HashMap<String,AST.method>());
		ids.put("Str",2);
		ids.put("Bool",3);
		class_methods.put("Bool",new HashMap<String,AST.method>());
		temp_methods.put("Bool",new HashMap<String,AST.method>());
		temp_attrs.put("Bool",new HashMap<String,AST.attr>());
		ids.put("IO",4);
		temp_attrs.put("IO",new HashMap<String,AST.attr>());
		temp_methods.put("IO",new HashMap<String,AST.method>());
		children.get("Object").add("Int");
		class_methods.put("IO",new HashMap<String,AST.method>());
		temp_attrs.put("String",new HashMap<String,AST.attr>());

		graph.get(0).add(1);
		graph.get(0).add(2);
		graph.get(0).add(3);
		graph.get(0).add(4);
		class_attrs.put("IO",new HashMap<String,AST.attr>());
		parent.put("String","Object");
		class_attrs.put("String",new HashMap<String,AST.attr>());
		children.get("Object").add("String");
		class_methods.put("String",new HashMap<String,AST.method>());
		parent.put("Bool","Object");
		class_attrs.put("Bool",new HashMap<String,AST.attr>());
		children.get("Object").add("Bool");
		parent.put("IO","Object");
		children.get("Object").add("IO");
		//ast.put("Object",null);
		//ast.put("Object", list of features of Bool, IO, Int, Str) one by one
		int counter = 5;
		install_basic_classes();
		Set<String> class_set = new HashSet<String>();
		for(AST.class_ c : p.classes)
		{
			if(parent.get(c.name)!=null) reportError(c.filename,c.lineNo,"Class "+c.name+" was previously defined");
			else{
				parent.put(c.name, c.parent);
				//ast.put(c.name, c.features);
				if(ids.get(c.name)==null){ids.put(c.name,counter);counter++;}
				if(ids.get(c.parent)==null){ids.put(c.name,counter);counter++;}
				class_attrs.put(c.name,new HashMap<String,AST.attr>());
				class_methods.put(c.name,new HashMap<String,AST.method>());
				if(children.get(c.parent)==null) 
					children.put(c.parent, new ArrayList<String>());
				children.get(c.parent).add(c.name);
				temp_attrs.put(c.name,new HashMap<String,AST.attr>());
				temp_methods.put(c.name,new HashMap<String,AST.method>());
				if(graph.get(c.parent)==null) graph.put(ids.get(c.parent), new ArrayList<Integer>());
				graph.get(ids.get(c.parent)).add(ids.get(c.name));

				
				
				
			
				String class_name = c.name;
				String parent_name = c.parent;
				if(class_name==parent_name){
					reportError(c.filename ,c.lineNo , "Class "+class_name+"or an acestor is involved in an inheritance cycle\n");
					
				}
				else if(class_name.equals("SELF_TYPE")){
					reportError(c.filename , c.lineNo, "Redefinition of basic class SELF_TYPE\n");
					
				}
				else if(parent_name.equals("Int") || parent_name.equals("Bool") || parent_name.equals("Str") || parent_name.equals("SELF_TYPE")){
					reportError(c.filename, c.lineNo, "Class "+class_name+"cannot inherit from "+parent_name+"\n");
					
				}
				else if(class_set.contains(class_name)){
					reportError(c.filename, c.lineNo, "Class was previously defined\n");
					
				}
				class_set.add(class_name);
				if(class_name.equals("Main"))
					foundMain = true;
			}
				
			
		}
		if(!foundMain){
			reportError("filename", 1,"Class Main is not defined");
			return false;
			
		}
		else
		{
			for(AST.class_ c: p.classes)
			{
				if(ids.get(c.parent)==null) reportError(c.filename, c.lineNo,"Class "+c.name+ " inherits from an undefined class "+c.parent);
				else
				{
					if(c.name.equals("Main"))
					{
						for(AST.feature f: c.features)
						{
							if(f instanceof AST.method) main_methods.put(((AST.method)f).name,(AST.method)f);

						}
						if(main_methods.get("main")==null) reportError(filename, a, "No main method in class Main");
						else 
							if(((main_methods.get("main")).formals).size()!=0) reportError(filename, 1,"'main' method in class Main should have no arguments");
					}
					for(AST.feature feat: c.features)
					{
						if(feat instanceof AST.attr)
						{
			
							if(ids.get(((AST.attr)feat).typeid)==null)
								reportError(filename,((AST.attr)feat).lineNo,"Class "+((AST.attr)feat).typeid+" of attribute " +((AST.attr)feat).name+ " is undefined.");
							else
							{
								String iter= c.name; int check =0; 
								while(!iter.equals("Object"))
								{
									if(class_attrs.get(iter).get((AST.attr)feat)!=null)
									{
										if(iter.equals(c.name)) reportError(filename, ((AST.attr)feat).lineNo,"Attribute "+(AST.attr)feat+" is multiply defined in class.");
										else reportError(filename, ((AST.attr)feat).lineNo, "Attribute "+(AST.attr)feat+" is an attribute of an inherited class.");
										check = 1;
									}
									iter=parent.get(iter);
								}
								if(check==0)
									class_attrs.get(c.name).put(((AST.attr)feat).name,(AST.attr)feat);
							}
						}
						else
						{

							if(ids.get(((AST.method)feat).typeid)==null) reportError(filename,((AST.method)feat).lineNo,"Undefined return type "+((AST.method)feat).typeid+ " in method "+((AST.method)feat).name+".");
								
							else
							{
								int check = 0;
								//checkMethod(m.name,cl.name,m);
								
			
								if((class_methods.get(c.name).get(((AST.method)feat).name))!=null) reportError(filename, ((AST.method)feat).lineNo,"Method "+((AST.method)feat).name+" is multiply defined.");
								else
								{
									String iter = c.name;
									iter=parent.get(iter);
									while(!iter.equals("Object"))
									{
										if((class_methods.get(iter).get(((AST.method)feat).name))!=null)
										{
											List<AST.formal> f=(class_methods.get(c.name).get(((AST.method)feat).name)).formals;
											String method_rettype=(class_methods.get(c.name).get(((AST.method)feat).name)).typeid;
											if(!method_rettype.equals(((AST.method)feat).typeid))
											{
												check=1;
												reportError(filename, ((AST.method)feat).lineNo,"In redefined method "+((AST.method)feat).name+", return type "+((AST.method)feat).typeid+" is different from original return type "+method_rettype+".");
												break;
											}
											else
											{
												if(f.size()!=((AST.method)feat).formals.size())
												{
													check = 1;
													//reportError(filename, m.lineNo,"In redefined method ret, parameter type "+(m.formals.get(i)).typeid+" is different from original type "+(f.get(i)).typeid+".");
													break;
												}
											}
										}
										iter=parent.get(iter);
									}
									for(int i=0;i<((AST.method)feat).formals.size();i++)
									{
										for(int j=i+1;j<((AST.method)feat).formals.size();j++)
										{
											if(i!=j)
											{
												if(((AST.method)feat).formals.get(i).name.equals(((AST.method)feat).formals.get(j).name))
												{
													check=1;
													reportError(filename, ((AST.method)feat).lineNo,"Formal parameter "+((AST.method)feat).formals.get(i).name+" is multiply defined.");
												}
											}
										}
									}
								}

								if(check==0)
									class_methods.get(c.name).put(((AST.method)feat).name,(AST.method)feat);
							}
						}
					}
				}
			}
		}
		for(String x: parent.keySet())System.out.println(x+" ");System.out.println("\n");
		for(String x: children.keySet()) {System.out.println("c "+ x+" ") ; for(String y: children.get(x)) System.out.println(y+" ");System.out.println("\n");}
		for(String x: ids.keySet()){System.out.println(x+" ");}
		int size = ids.size();
		int flag = 0;
		boolean[] visited = new boolean[size];
		boolean[] recStack = new boolean[size];
		for(int i=0;i<size;i++){visited[i]=false; recStack[i]=false;}
		for(String temp: ids.keySet())
		{
			if(check_cycles(temp, visited, recStack)) reportError(filename, 1, "Error: Contains inheritance cycle");
		}
		if(flag==1) return false;
		dfs(0);

		return true;
							
	}

	public void dfs(int v)
	{
		String class_name = "";
		for(Map.Entry<String,Integer> e:ids.entrySet())
			{
				if(v==(e.getValue()))
				{
					class_name = e.getKey();
				}
			}
		Map<String,AST.attr> a = class_attrs.get(class_name);
		if(v>4)
		{
			table.enterScope();

			
			for(Map.Entry<String,AST.attr> entry : a.entrySet())
			{
				table.insert(entry.getKey(),entry.getValue());
				String ret_type = exprType(entry.getValue().value);
				String attr_type = entry.getValue().typeid;
				if(!ret_type.equals("No_Type"))
				{
					if(!lca(ret_type,attr_type).equals(attr_type))
						reportError(filename, 1, "Inferred type "+ret_type+" of intialisation of attribute "+entry.getValue().name+ " does not conform to declared type "+ attr_type);

				}

			}
		
			Map<String,AST.method> m = class_methods.get(class_name);
			for(Map.Entry<String,AST.method> entry : m.entrySet())
			{
				List<AST.formal> f=(entry.getValue()).formals;
				table.enterScope();
				for(int i=0;i<f.size();i++)
				{
					//AST.attr x = new AST.attr(f.get(i));
					table.insert((f.get(i)).name, new AST.attr(f.get(i).name, (f.get(i)).typeid, new AST.no_expr(1), 1));
				}
				String actual_rettype=exprType((entry.getValue()).body);
				String method_rettype=(entry.getValue()).typeid;
				if(!(lca(actual_rettype,method_rettype).equals(method_rettype)))
				{
					reportError(filename, 1,"Inferred return type "+actual_rettype+" of method main does not conform to declared return type "+method_rettype+".");
				}
				table.exitScope();
			}
		}
		if(graph.get(v)!=null) for(int i=0;i<(graph.get(v)).size();i++) dfs((graph.get(v)).get(i));
		if(v>4)
			table.exitScope();
		
	}

	public String lca(String s1, String s2)
	{
		String s1_copy = s1; String s2_copy = s2;
		while(s1_copy!=null)
		{
			while(s2_copy!=null)
			{
				if(s1_copy.equals(s2_copy)) return s1_copy;
				s2_copy = parent.get(s2_copy); 

			}
			s2_copy=s2;
			s1_copy = parent.get(s1_copy);
		}
		return null;
	}
	public boolean check_cycles(String temp, boolean visited[], boolean recStack[])
	{
		int v = ids.get(temp);
		if(visited[v]==false)
		{
			visited[v] = true;
			recStack[v] = true;
			if(ids.get(temp)!=null && children.get(temp)!=null)
			{
				//System.out.println(children.get(temp));
				for(String tmp: children.get(temp))
				{
					if(ids.get(tmp)==null) break;
					//System.out.println(ids.get(tmp));
					if(!visited[ids.get(tmp)] && check_cycles(tmp, visited, recStack))
						return true;
					else if (recStack[ids.get(tmp)])
						return true;

				}
			}
		}
		recStack[v] = false;
		return false;
	} 
	
	public String exprType(AST.expression expr)
	{
		if(expr instanceof AST.no_expr) return "No_Type";

		else if(expr instanceof AST.bool_const) return "Bool";

		else if(expr instanceof AST.string_const) return "String";

		else if(expr instanceof AST.int_const) return "Int";

		else if(expr instanceof AST.object)
		{
			AST.attr ret_attr=table.lookUpGlobal(((AST.object)expr).name);
			if(ret_attr==null) 
			{
				reportError(filename,((AST.object)expr).lineNo,"Undeclared identifier "+((AST.object)expr).name);
				return "Object";
			}
			else return ret_attr.typeid;

		}
		else if(expr instanceof AST.comp)
		{
			
			if(exprType(((AST.comp)expr).e1).equals(new String("Bool"))) return "Bool";
			else
			{
				reportError(filename, expr.lineNo,"Argument of 'not' has type " + exprType(((AST.comp)expr).e1) + " instead of Bool");
				return "Bool";
			}
		}
		else if(expr instanceof AST.eq)
		{
			if(exprType(((AST.eq)expr).e1).equals("Int") || exprType(((AST.eq)expr).e1).equals("String") || exprType(((AST.eq)expr).e1).equals("Bool") && exprType(((AST.eq)expr).e1).equals(exprType(((AST.eq)expr).e2))) return "Bool";
			else if(exprType(((AST.eq)expr).e1).equals("Int") || exprType(((AST.eq)expr).e1).equals("String") || exprType(((AST.eq)expr).e1).equals("Bool") || exprType(((AST.eq)expr).e2).equals("Int") || exprType(((AST.eq)expr).e2).equals("String") || exprType(((AST.eq)expr).e2).equals("Bool"))
			{
				reportError(filename,expr.lineNo,"Illegal comparison");
				return "Bool";
			}
			
			
		}
		else if(expr instanceof AST.lt)
		{
			if(exprType(((AST.lt)expr).e1).equals("Int") && exprType(((AST.lt)expr).e2).equals("Int")) return "Bool";
			else
			{
				reportError(filename,expr.lineNo,"non-Int arguments: "+exprType(((AST.lt)expr).e1)+" < "+exprType(((AST.lt)expr).e2));
				return "Bool";
			}
			
			
		}
		else if(expr instanceof AST.leq)
		{
			if(exprType(((AST.leq)expr).e1).equals("Int") && exprType(((AST.leq)expr).e2).equals("Int")) return "Bool";
			else
			{
				reportError(filename,expr.lineNo,"non-Int arguments: "+exprType(((AST.leq)expr).e1)+" < "+exprType(((AST.leq)expr).e2));
				return "Bool";
			}
		}
		else if(expr instanceof AST.plus)
		{
			if(exprType(((AST.plus)expr).e1).equals("Int") && exprType(((AST.plus)expr).e2).equals("Int")) return "Int";
			else
			{
				reportError(filename,expr.lineNo,"non-Int arguments: "+exprType(((AST.plus)expr).e1)+" + "+exprType(((AST.plus)expr).e2));
				return "Int";
			}
		}
		else if(expr instanceof AST.sub)
		{
			if(exprType(((AST.sub)expr).e1).equals("Int") && exprType(((AST.sub)expr).e2).equals("Int")) return "Int";
			else
			{
				reportError(filename,expr.lineNo,"non-Int arguments: "+exprType(((AST.sub)expr).e1)+" - "+exprType(((AST.sub)expr).e2));
				return "Int";
			}
		}
		else if(expr instanceof AST.mul)
		{
			if(exprType(((AST.mul)expr).e1).equals("Int") && exprType(((AST.mul)expr).e2).equals("Int")) return "Int";
			else
			{
				reportError(filename,expr.lineNo,"non-Int arguments: "+exprType(((AST.mul)expr).e1)+" * "+exprType(((AST.mul)expr).e2));
				return "Int";
			}
		}
		else if(expr instanceof AST.divide)
		{
			if(exprType(((AST.divide)expr).e1).equals("Int") && exprType(((AST.divide)expr).e2).equals("Int")) return "Int";
			else
			{
				reportError(filename,expr.lineNo,"non-Int arguments: "+ exprType(((AST.divide)expr).e1) +" / "+ exprType(((AST.divide)expr).e2));
				return "Int";
			}
		}
		else if(expr instanceof AST.neg)
		{
			if(exprType(((AST.neg)expr).e1).equals("Int"))return "Int";
			else
			{
				reportError(filename,expr.lineNo,"Argument of '~' has type " + exprType(((AST.neg)expr).e1) + " instead of Int.");
				return "Int";
			}
		}	
		else if(expr instanceof AST.assign)
		{
			AST.attr ret_attr=table.lookUpGlobal(((AST.assign)expr).name);
			if(ret_attr==null)
				reportError(filename,1,"Assignment to undeclared variable "+((AST.assign)expr).name+".");
			else
			{
				if(!((ret_attr.typeid).equals(lca(ret_attr.typeid, exprType(((AST.assign)expr).e1)))))
					reportError(filename,1,"Type "+ exprType(((AST.assign)expr).e1) +" of assigned expression does not conform to declared type "+ret_attr.typeid+" of identifier "+ret_attr.name+".");
				expr.type = exprType(((AST.assign)expr).e1);
				return expr.type;
			}
		}
		else if(expr instanceof AST.isvoid) return "Bool";

		else if(expr instanceof AST.cond)
		{
			//String data_type=exprType(((AST.cond)expr).predicate);
			if(!exprType(((AST.cond)expr).predicate).equals("Bool"))
			{
				reportError(filename,expr.lineNo,"Predicate of 'if' does not have type Bool.");
			}

			return lca(exprType(((AST.cond)expr).ifbody), exprType(((AST.cond)expr).elsebody));
		}

		else if(expr instanceof AST.loop)
		{
			//String data_type=exprType(((AST.loop)expr).predicate);
			if(!exprType(((AST.loop)expr).predicate).equals("Bool"))
			{
				reportError(filename, expr.lineNo,"Predicate of 'while' does not have type Bool.");
			}
			//data_type=exprType(((AST.loop)expr).body);
			//expr.type="Object";
			return "Object";
		}
		else if(expr instanceof AST.block)
		{
			List<AST.expression> exp=((AST.block)expr).l1;
			for(int i=0;i<exp.size()-1;i++) exprType(exp.get(i));
			return exprType(exp.get(exp.size()-1));
			// String data_type=exprType(e.get(e.size()-1));
			// expr.type=data_type;
			// return data_type;
			
		}
		else if(expr instanceof AST.new_)
		{
			if(ids.get(((AST.new_)expr).typeid)==null) reportError(filename,expr.lineNo,"'new' used with undefined class "+((AST.new_)expr).typeid+".");

			else return ((AST.new_)expr).typeid;

		}
		else if(expr instanceof AST.typcase)
		{
			
			
			String data=exprType(((AST.typcase)expr).predicate);
			if(data.equals("Bool"))
			{
				/* Check that all the branches have distinct types. */
				for(int i=0;i<((AST.typcase)expr).branches.size();i++)
				{
					for(int j=i+1;j<((AST.typcase)expr).branches.size();j++)
					{
						if((((AST.typcase)expr).branches.get(j)).type.equals((((AST.typcase)expr).branches.get(i)).type)) reportError(filename,1,"Duplicate branch "+(((AST.typcase)expr).branches.get(i)).type+"in case statement.");
							
					}
				}

				int i=0;
				for(AST.branch tmpbranch : ((AST.typcase)expr).branches ) {
					table.enterScope();
					i++;

					if(ids.get(tmpbranch.type)==null)
						reportError(filename,1,"Class "+(((AST.typcase)expr).branches.get(i)).type+"of case branch is undefined.");
					table.insert((((AST.typcase)expr).branches.get(i)).name,new AST.attr((((AST.typcase)expr).branches.get(i)).name,(((AST.typcase)expr).branches.get(i)).type,new AST.no_expr(1),1));
					exprType((((AST.typcase)expr).branches.get(i)).value);
					table.exitScope();
									
				}

				data=((AST.typcase)expr).branches.get(0).type;
				
				for(i=1;i<((AST.typcase)expr).branches.size();i++)
				{
					data=lca(data,exprType(((AST.typcase)expr).branches.get(i).value));
				}
				

			}
			else
				reportError(filename,expr.lineNo,"Predicate of 'case' does not have type Bool.");
			return data;
			

		}
		else if(expr instanceof AST.let)
		{
			table.enterScope();
			if(ids.get(((AST.let)expr).typeid)==null)
				reportError(filename,1,"Class "+((AST.let)expr).typeid+" of let-bound identifier "+((AST.let)expr).name+" is undefined.");
			table.insert(((AST.let)expr).name,new AST.attr(((AST.let)expr).name,((AST.let)expr).typeid,new AST.no_expr(1),1));
	
			if(!(exprType(((AST.let)expr).value).equals("No_Type")))
			{
				if(!lca(exprType(((AST.let)expr).value),((AST.let)expr).typeid).equals(((AST.let)expr).typeid))
					reportError(filename,1,"Inferred type "+exprType(((AST.let)expr).value)+" of initialization of "+((AST.let)expr).name+" does not conform to identifier's declared type "+((AST.let)expr).typeid+".");
			}

			table.exitScope();
			return exprType(((AST.let)expr).body);
		}
		else if(expr instanceof AST.dispatch)
		{
			List<AST.expression> actual_param;
			List<AST.formal> formal_param;
			// AST.method m;
			AST.expression caller=((AST.dispatch)expr).caller;
			String c_type=exprType(((AST.dispatch)expr).caller);
			// method_name=((AST.dispatch)expr).name;
			while(c_type!=null)
			{

				//AST.method (class_methods.get(c_type)).get(((AST.dispatch)expr).name)=(class_methods.get(c_type)).get(((AST.dispatch)expr).name);
				if((class_methods.get(c_type)).get(((AST.dispatch)expr).name)!=null)
				{
					actual_param=((AST.dispatch)expr).actuals;
					formal_param=(class_methods.get(c_type)).get(((AST.dispatch)expr).name).formals;
					if(actual_param.size()!=formal_param.size())
					{
						reportError(filename,1,"Method "+((AST.dispatch)expr).name+" called with wrong number of arguments.");
						break;
					}
					for(int i=0;i<actual_param.size();i++)
					{
						String actual_type=exprType(actual_param.get(i));
						if(!actual_type.equals((formal_param.get(i)).typeid))
							reportError(filename,1,"In call of method "+((AST.dispatch)expr).name+", type "+actual_type+" of parameter "+(formal_param.get(i)).name+" does not conform to declared type "+(formal_param.get(i)).typeid+".");
					}
					return (class_methods.get(c_type)).get(((AST.dispatch)expr).name).typeid;
				}
				c_type=parent.get(c_type);
			}
			return "Object";
		}
		else if(expr instanceof AST.static_dispatch)
		{
			//String ((AST.static_dispatch)expr).typeid="";
			//String caller_type="";
			//String ((AST.static_dispatch)expr).name="";
			//String actual_type="";
			List<AST.expression> actual_param;
			List<AST.formal> formal_param;
			//((AST.static_dispatch)expr).typeid=((AST.static_dispatch)expr).typeid;
			if(ids.get(((AST.static_dispatch)expr).typeid)==null)
				reportError(filename,1,"Static dispatch to undefined class "+((AST.static_dispatch)expr).typeid+".");
			AST.method m;
			AST.expression caller=((AST.static_dispatch)expr).caller;
			String c_type=exprType(caller);
			if(!(exprType(caller).equals("No_type")||(((AST.static_dispatch)expr).typeid).equals("No_type")))
			{
				if(!lca(exprType(caller),((AST.static_dispatch)expr).typeid).equals(((AST.static_dispatch)expr).typeid))
					reportError(filename,1,"Expression type "+exprType(caller)+" does not conform to declared static dispatch type "+((AST.static_dispatch)expr).typeid+".");
			}
			//((AST.static_dispatch)expr).name=((AST.static_dispatch)expr).name;
			String sd_type =((AST.static_dispatch)expr).typeid;
			while(sd_type!=null)
			{
				m=(class_methods.get(sd_type)).get(((AST.static_dispatch)expr).name);
				if((class_methods.get(c_type)).get(((AST.dispatch)expr).name)!=null)
				{
					actual_param=((AST.static_dispatch)expr).actuals;
					formal_param=(class_methods.get(c_type)).get(((AST.dispatch)expr).name).formals;
					if(actual_param.size()!=formal_param.size())
					{
						reportError(filename,1,"Method "+((AST.static_dispatch)expr).name+" called with wrong number of arguments.");
						break;
					}
					for(int i=0;i<actual_param.size();i++)
					{
						//actual_type=exprType(actual_param.get(i));
						if(!exprType(actual_param.get(i)).equals((formal_param.get(i)).typeid))			
							reportError(filename,1,"In call of method "+((AST.static_dispatch)expr).name+", type "+actual_param+" of parameter "+(formal_param.get(i)).name+" does not conform to declared type "+(formal_param.get(i)).typeid+".");
					}
					return (class_methods.get(c_type)).get(((AST.dispatch)expr).name).typeid;		
				}
				sd_type=parent.get(sd_type);
			}
			
			return "Object";
		}

		return "yomama";
	}
}
