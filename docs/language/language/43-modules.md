## Modules

A module is the top-level container for all T programs, it is the parent of all other syntactical components.

### Declaration

A module is defined using the `module` keyword followed by the name of the module:

```d
module myModule;

// Code goes here
```

You would then save this into a file named `myModule.t`.

> Note, that if your module's declared name does not match the filename there will not be an immediate error. **However**, this is because the default value for the configuration option `"modman:strict_headers"` is set to `false` - this will change in the future

### Naming

Because the module is the root of all other containers such as classes and structs, one can always use the module name to refer from the top-down. An example:

```d
module myModule;

class A
{
    static int b;
}

// This is the same
int value1 = A.b;

// As this
int value2 = myModule.A.b;
```

### Usage

#### Project structure

We will setup a project structure as follows:

```bash
source/tlang/testing/modules/
|-- a.t
|-- b.t
|-- niks
|   |-- c.t
```

We now show the internals of each of these modules to show you how they fit together and then also how to compile it all.

**Module `a.t`**:

```d
module a;

import niks.c;
import b;

int ident(int i)
{
	return i;
}

int main()
{
	int value = b.doThing();
	return value;
}
```

> Notice here that we import modules in the same directory just with their name. It's basically $module_{path} = module_{name}+".t"$. Directory structure is also taken into account, hence in order to reference the module `c` we must import it as `niks.c` as that will resolve to `niks/c.t` as the file path.

**Module `b.t`**:

```d
module b;

import a;

int doThing()
{
    int local = 0;

    for(int i = 0; i < 10; i=i+1)
    {
        local = local + a.ident(i);
    }

    return local;
}
```

**Module `niks/c.t`**:

```d
module c;

import a;

void k()
{
    
}
```

#### Compiling

You could then go ahead and compile such a program by specifying the entrypoint module:

```bash
# Compile module a
./tlang compile source/tlang/testing/modules/a.t
```

Then running it, our code should return with an exit code of `45` due to what we implemented in the `b` module and how we used it in `a` which had our `main()` method:

```bash
# Run the output executable
./tlang.out

# Print the exit code
echo $?
```

> Note, the module you specify on the command-line will have its directory used as the base search path for the rest of the modules. Therefore specifying `a.t` or `b.t` is fine as they reside in the same directory whereby `niks/` can be found ut this is not true if you compiles `niks/c.t` as that would only see the search directory from `niks/` downwards - upwards searching does **not** occur