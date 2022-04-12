<img src="tbk.png" width=345 height=241.5 style="float:right">

# Tristan Programming Language

The Tristan programming language is a systems programming language for the modern day that aims to achieve the following goals:

1. To be efficient in the generated code
2. Cross-platform support
3. A _"C"_ with classes that isn't bloated like C++
4. Weakly typed (unsafe) type system
5. To put all the control in the hands of the user
	* Memory layout
	* Argument passing
	* _And more..._

Welcome to the official homepage for the Tristan programming language project.

---

Take a look at some example programs written in T!

=== "OOP program"

	```d
	module typeChecking2;

	A aInstance;
	B bInstance;

	int j = 1;
	int k = j+1;
	int p = k+j;

	C cInstance;

	class A
	{
	    static int pStatic;
	    static B bInstanceStatic;
	    static A aInstanceStaticMoi;

	    int poes;
	}

	class B
	{
	    static int jStatic;
	    static A aInstanceStatic;
	}

	class C
	{
	    static int j=1;
	    static int k = j;
	    int p;
	}
	```

=== "Function calls"

	```d
	module simple;
	int j = 1+func(3,test()+t2()+t2());
	j = 2+func(-69,test());

	int func(int x1, byte x2)
	{
	
	}

	byte t2()
	{

	}
	
	byte test()
	{
	
	}
	```

=== "Complicated programs"

	```d
	module myModule;


	int x;
	ubyte y;

	int a;
	int b = a;
	int c = myModule.x;
	int l;

	l=2;
	l=l;


	int o = myModule.l;


	int f = f.L(f(1+f.d.d.d()));
	int p = f2p.j2.p;

	int ll = f(1,1);

	public ubyte k = 1;
	private ubyte k2 = 1;
	protected ubyte k3 = -1;

	class kl
	{
	    
	}

	struct structTest
	{
	    int j;
	    int j;

	    void pdsjhfjdsf(int j)
	    {

	    }

	    void pdsjhfjdsf(int j)
	    {

	    }
	}

	struct structTest2
	{

	}

	class Shekshi 
	{
	    struct structTest
	    {
	        
	    }

	    public struct poesStruct
	    {
	        
	    }

	    class Shekshi1
	    {
	        
	    }

	    class kl
	    {

	    }

	    int Shekshi2;

	    class G
	    {
	        class F
	        {

	        }
	    }
	}

	class X : myModule.ooga
	{
	    class Y : ooga
	    {

	    }

	   

	    class K : myModule.ooga
	    {
	        
	    }

	    class D : X.Y
	    {
	        class Fok : myModule.ooga
	        {

	        }
	    }

	    class F : Shekshi.G.F {}

	    class Z : ooga
	    {

	    }

	    
	}

	class ooga : O
	{

	}

	class O : ooga
	{
	    class I
	    {
	        class L 
	        {

	        }
	        
	    }

	    
	   
	}

	class Me
	{
	    class You
	    {
	        class Me
	        {

	        }

	        class InnerMe : Me
	        {

	        }

	        class OuterMe 
	        {

	        }
	    }   
	}

	class Us
	{
	    class Container : Us
	    {

	    }

	    class Tom
	    {

	    }

	    class Poes
	    {
	        class Kak
	        {

	        }
	    }
	}

	class Them
	{
	    class Container
	    {   
	        class TestInner : Container
	        {

	        }

	        class TestOuter : Us.Container
	        {
	            
	        }

	        class Naai : Us.Poes.Kak
	        {
	            
	        }

	        class naai : testClass.test3.llllll.fokfok
	        {

	        }

	        class baai : myModule.testClass.test3.llllll.fokfok
	        {

	        }

	        
	    }
	}

	class testClass
	{
	    class test2 :testClass
	    {

	    }

	    class oops: myModule.testClass {}

	    class test3:test2
	    {
	        class llllll : testClass.test2
	        {
	            class fokfok : llllll
	            {

	            }

	            class gustav : fokfok
	            {

	            }

	            class testtest : llllll.fokfok
	            {

	            }

	            class testtest2 : test3.llllll.fokfok
	            {

	            }

	            class testtest3 : test3.llllll.fokfok
	            {

	            }

	            class testtest4 : testClass.test3.llllll.fokfok
	            {

	            }

	            class testtest5 : O
	            {

	            }

	            class testtest6 : O.I
	            {

	            }

	            class testtest7 : O.I.L
	            {

	            }

	            class testtest9 : L
	            {

	            }

	            class L {}

	            class tieg : troy
	            {
	                class troy
	                {
	                    
	                }
	            }
	            
	            class troy
	            {
	                
	            }

	            


	            class gabby
	            {
	                class troy
	                {
	                
	                }
	            }

	            class testtest8 : testtest7, clazz1.nofuck
	            {

	            }

	            

	            

	            

	            

	            

	            

	            
	        }
	    }

	    class test4 : bruh
	    {

	    }

	    

	    class yoyo
	    {
	        class kaka{}
	    }

	    class poop : poop.kaka
	    {
	        class kaka
	        {
	            class eish : poop
	            {

	            }

	            class eish2 : yoyo.kaka
	            {

	            }
	        }
	    }
	 
	    class j : poop.kaka
	    {

	    }

	    class hi : hi.ho.hee
	    {
	        class ho
	        {
	            class hee
	            {

	            }
	        }
	    }
	}

	public class clazz1
	{
	    int k;
	    print("Hello world");
	    class nofuck
	    {

	    }

	    public class clazz3
	    {
	        class clazz1
	        {

	        }   
	    }

	    class bruh
	    {

	    }

	}



	class bruh
	{
	    class bruh1
	    {
	        class bruh2
	        {

	        }
	    }
	}

	class clazz2 : bruh
	{
	    class clazzU
	    {
	        
	    }

	    class clazz12
	    {
	        int j;
	        private class clazz_2_2_1 : bruh, clazzU
	        {

	        }
	    }

	    protected class clazz_2_3
	    {
	        class clazz_2_3_1
	        {
	            if(1)
	            {
	                print("Hello");
	            }
	            else if(1)
	            {
	                print("Bruh");
	            }
	            else
	            {
	                print("Bhjkfd");
	            }

	            if(1)
	            {
	                print("Hello");
	            }
	            else if(1)
	            {
	                print("Bruh");
	            }
	            else
	            {
	                print("Bhjkfd");
	            }

	            if(1)
	            {
	                print("Hello");
	            }
	            else if(1)
	            {
	                print("Bruh");
	            }
	            else if(1)
	            {
	                print("Bruh");
	            }
	            else if(1)
	            {
	                print("Bruh");
	            }
	            else if(1)
	            {
	                print("Bruh");
	            }
	            else
	            {
	                print("Bhjkfd");
	            }

	            if (1) {} else if(1) {} else {}




	            
	        }
	        
	        print("Hello");
	    }
	}

	void pdsjhfjdsf(int j)
	{

	}

	void ko(int j, int k)
	{

	    l.l("");
	    l.l(l.l());

	    ubyte thing = "Hello";
	    print("Hello world");
	    print(1+1);
	    print(1+1);

	    ubyte eish = 1+1;

	    ubyte poes = ((1+1));

	    if(1+1)
	    {
	        if(1)
	        {
	            if((1))
	            {
	                print("Hello");    
	            }
	            print("Hello");
	        }
	    }

	    if(((2)))
	    {
	        print(1+1);   
	    }

	    if(2+222222/2)
	    {
	        while(1)
	        {
	            while(2+2+2)
	            {

	            }
	        }   
	    }
	}

	void brduh()
	    {
	        
	    }



	public void main(int hello, byte d)
	{

	    void bruh()
	    {

	    }

	    ubyte kak;
	    ubyte kak2 = -1;
	    ubyte thing = "Hello";
	    print("Hello world");
	    print(1+1);
	    print(1+1);

	    ubyte eish = 1+1;

	    ubyte poes = ((1+1));

	    if(1+1)
	    {
	        if(1)
	        {
	            if((1))
	            {
	                print("Hello");    
	            }
	            print("Hello");
	        }
	    }

	    if(((2)))
	    {
	        print(1+1);   
	    }

	    if(2+222222/2)
	    {
	        while(1)
	        {
	            while(2+2+2)
	            {

	            }
	        }   
	    }
	}
	```