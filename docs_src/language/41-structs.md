## Structs

### Introduction

What are structs? In T a Struct is a user-defined type which associates several fields toghether however, unlike C, structs in T can have a set of functions associated with them as well.

The syntax for declaring a struct with name `<name>`, and some fields `<field1>`, `<field2>` with the types `<type1>`, `type2>` respectively is as follows:

```d
struct <name>
{
    <type1> <field1>;
    <type2> <field2>;
}
```

Note: Assignments to these variables within the struct's body is not allowed.

#### Example

Perhaps we want a simple struct that associates a name, age and gender together to represent a _Person_, then we can declare such a struct as follows:

```d
struct Person
{
    char* name;
    ubyte age;
    ubyte gender;
}
```

---

### Member functions

One can also define a struct to have certain functions associated with it that will operate on its data without having to refer to it directly in the source code. The syntac for a member function with return type `<returnType>`, name `<funcName>`, of a struct is (along with our previous struct) as follows:

```d
struct <name>
{
    <type1> <field1>;
    <type2> <field2>;

    <returnType> <funcName>()
    {
        return <instanceOfReturnType>;
    }
}
```

#### Example

TODO: Add some text here describing it

```d
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
```