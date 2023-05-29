## Configuration

The T compiler can have various variables tweaked to control the bahviour of the compiler

### `types`

Anything regarding the type system (this includes the type checker and the meta processor).

1. `types:max_width`
    * This entry holds an integrak value
    * This sets the maximum bit-width of a machine (in bytes)
    * This can either be `1`, `2`, `4` or `8`
    * It affects how alises such as `size_t` and `ssize_t` behave in terms of what the resolve to

### `dgen`

These options configure the C code emitter.

1. `dgen:pretty_code`
    * This entry holds a boolean value
    * If `true` then the emitted code will be prettified, meaning it will be correctly indented. If `false` then no such prettifying will occur.
    * Default: `true`

### `emit`

This controls aspects of the `CodeEmitter` API, meaning irrespective of which emitter (such as `dgen`) is used.

1. `emit:mapper`
    * This entry holds a string value
    * This controls how symbol names within T are translated
    * The two available options are:
        1. `"hashmapper"` - the hash of the T symbol name is the result
        2. `"lebanese"` - all periods (`.`) within T symbols are replaced by underscores (`_`)
    * Default: `"hashmapper"`
