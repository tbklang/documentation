## Type remappings

Sometimes one wants to be able to give a certain type an _alternative name_, this is known as type _remapping_ and can be accomplished within T with a very simple syntax:

```d
module remap;

type Millisecond = uint64;

int main()
{
    Millisecond sleepTime = cast(Millisecond)2000;

    return 0;
}
```