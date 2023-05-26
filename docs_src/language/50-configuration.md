## Configuration

The T compiler can have various variables tweaked to control the bahviour of the compiler

### `dgen`

These options configure the C code emitter.

1. `dgen:pretty_code`
    * This entry holds a boolean value
    * If `true` then the emitted code will be prettified, meaning it will be correctly indented. If `false` then no such prettifying will occur.

### `emit`

This controls aspects of the `CodeEmitter` API, meaning irrespective of which emitter (such as `dgen`) is used.

1. `emit:mapper`
    * This controls how symbol names within T are translated
    * The two available options are:
        1. `hashmapper` - the hash of the T symbol name is the result
        2. `lebanses` - all periods (`.`) within T symbols are replaced by underscores (`_`)