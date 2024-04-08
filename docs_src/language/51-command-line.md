## Command-line 

This documents the full set of available command-line flags one can use.

### `--unusedVars <boolean>`

* **What**: Allows one to toggle whether or not warnings about unused variables should be printed out or not.
* **Where**: Can be used with the `typecheck`, `emit` and `compile` commands.
* **How**: This toggles the compiler configuration entry `typecheck:warnUnusedVars`

### `--paths <path>`

* **What**: Allows one to add additional paths to the search paths searched for modules
* **Where**: Can be used with `syntaxcheck`, `typecheck` and `compile`
* **How**: This just updates internal state of the _module manager_

An example of this would be to add the following search paths:

* `"$(pwd)"`
* `source/tlang/testing/`
* `/usr/lib`

Therefore we could perform a compilation with these additional search paths as such:

```bash
./tlang compile source/tlang/testing/modules/a.t \
    --paths "$(pwd)" \
    --paths source/tlang/testing/ \
    --paths /usr/lib \
```