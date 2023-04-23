## Types

## Primitive data types

Primitive data type are the building blocks of which other more complex types are derived from. Each primitive type has the following 3 attributes:

1. **Type:** Indicates the name for the type
2. **Width:** How many bits it takes up
3. **Intended interpretation:** How it should be interpreted

### Integral types

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


#### Conversion rules

1. TODO: Sign/zero extension
2. Promotion?
3. Precedence in interpretation when the first two don't apply

### Decimal

TODO: Add this

* float32, float64 etc

#### Conversion rules

TODO: Add this