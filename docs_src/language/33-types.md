## Types

### Primitive data types

Primitive data type are the building blocks of which other more complex types are derived from. Each primitive type has the following 3 attributes:

1. **Type:** Indicates the name for the type
2. **Width:** How many bits it takes up
3. **Intended interpretation:** How it should be interpreted

#### Integral types

|   Type    | Width |     Intended interpretation     |
|-----------|-------|---------------------------------|
| `byte`    | `8`   | signed byte (two's complement)  |
| `ubyte`   | `8`   | unsigned byte                   |
| `short`   | `16`  | signed short (two's complement) |
| `ushort`  | `16`  | unsigned short                  |
| `int`     | `32`  | signed int (two's complement)   |
| `uint`    | `32`  | unsigned int                    |
| `long`    | `64`  | signed long (two's complement)  |
| `ulong`   | `64`  | unsigned long                   |


#### Decimal

TODO: Add this

* float32, float64 etc

---

### Rules

There are a few rules that the type system abides by and which one should know about when dealing with types in T.

#### Promotion

T has the concept of type promotion meaning that certain types when used in expressions with other _different_ types will have some kind of automatic conversion take place.

Promotion takes place for integral types, below we have an example where a smaller type (`byte`) is automatically coerced to the bigger type (the `long`) when assigned to the variable of the type `long`:

```d
module simple_coerce_literal_good_stdalone_ass;

void function()
{
    byte i = 1UL;
    long i1;

    i1 = i;
}
```

No explicit cast was required for the statement `il = 1`

This [example](TODO: add link) is available as part of the test suite.

#### Literals

There is one case whereby automatic conversion (known as _"coercion"_) is applied and that is with the usage of numeric literals. Firstly, however, we must discuss the default encoding scheme.

Below we have a table of ranges of values (literal values) and the types they can be coerced to. By this we mean that if you had a statement where you were, for example, assigning one of these literals to a variable of type `T` that you _would infact_ be able to assign such a value to said type `T`. That "type `T`" is what we have in the _Coercible-to_ column:

| Range                                   | Coercible-to                                                       |
|-----------------------------------------|--------------------------------------------------------------------|
| `0` ... `255`                           | `ubyte`, `ushort`, `uint`, `ulong`                                 |
| `0` ... `65_535`                        | `ushort`, `uint`, `ulong`                                          |
| `0` ... `4_294_967_295`                 | `uint`, `ulong`                                                    |
| `0` ... `18_446_744_073_709_551_615`    | `ulong`                                                            |
| `0` ... `127`                           | `byte`, `ubyte`, `short`, `ushort`, `int`, `uint`, `long`, `ulong` |
| `0` ... `32_7676`                       | `short`, `ushort`, `int`, `uint`, `long`, `ulong`                  |
| `0` ... `2_147_483_647`                 | `int`, `uint`, `long`, `ulong`                                     |
| `0` ... `9_223_372_036_854_775_807`     | `long`, `ulong`                                                    |


**TODO:** Add the negative ranges (i.e. when a -<value> (UnaryOpExp) is present and the range checking applied then
and what types are coercible to)

TODO: Add information about how literals are ranged checked and then coercion applies (this is the **ONLY** case were coercion applies)

| To-type | Provided-type |

1. TODO: Sign/zero extension
2. Promotion?
3. Precedence in interpretation when the first two don't apply