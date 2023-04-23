## Types

### Primitive data types

Primitive data type are the building blocks of which other more complex
types are derived from. Each primitive type has the following 3
attributes:

1.  **Type:** Indicates the name for the type
2.  **Width:** How many bits it takes up
3.  **Intended interpretation:** How it should be interpreted

#### Integral types

| Type     | Width | Intended interpretation         |
|----------|-------|---------------------------------|
| `byte`   | `8`   | signed byte (two’s complement)  |
| `ubyte`  | `8`   | unsigned byte                   |
| `short`  | `16`  | signed short (two’s complement) |
| `ushort` | `16`  | unsigned short                  |
| `int`    | `32`  | signed int (two’s complement)   |
| `uint`   | `32`  | unsigned int                    |
| `long`   | `64`  | signed long (two’s complement)  |
| `ulong`  | `64`  | unsigned long                   |

#### Decimal

TODO: Add this

-   float32, float64 etc

------------------------------------------------------------------------

### Rules

There are a few rules that the type system abides by and which one
should know about when dealing with types in T.

#### No explicit conversion

There is no automatic conversion in TLang, therefore one must explicitly
cast. An example of this is that if one has a function of type `uint`
and returns an expression of type `ubyte` (say now `return myByte` where
`myByte` is a `ubyte`-typed variable) then it will *still* not
automatically convert it for you, you would be required to do a
`cast(uint)` as such:

``` d
ubyte myByte = 255;

uint function()
{
    return cast(uint)myByte;
}
```

This is seen as a benefit as one always knows what they are doing at any
time with the type-system by having to conciosuly cast data in such a
manner.

#### Literals

TODO: Add information about how literals are ranged checked and then
coercion applies (this is the **ONLY** case were coercion applies)

To-type \| Provided-type \|

1.  TODO: Sign/zero extension
2.  Promotion?
3.  Precedence in interpretation when the first two don’t apply
