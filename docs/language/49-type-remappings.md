## Type remappings

Sometimes one wants to be able to give a certain type an *alternative
name*, this is known as type *remapping* and can be accomplished within
T with a very simple syntax:

``` d
module remap;

type Millisecond = uint64;

int main()
{
    Millisecond sleepTime = cast(Millisecond)2000;

    return 0;
}
```
