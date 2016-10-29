class Hello {

   Foo:Int;
   bar:Int;
   
};


class Test {
  foo:Test;
  bar():Int { case foo.bar() of y:Int => 3;
                                z:String => 4;
                                x:Test => 5; esac };
};

class Hello {

   foo:Int <- 89;
   bar:Int;
   
   foo(a:Int, b:Int, c:String): Int  {
      case of
        b: Int => expr1;
        d: Object  => { expr3; expr4; };
      esac
   };
   
   bar() :Int {
      6
   };
   
   
};


class Maga{

   foo:Int;
   bar: String;
   
};