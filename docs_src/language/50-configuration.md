## Configuration

The T compiler can have various variables tweaked to control the behavior of the compiler

### `types`

Anything regarding the type system (this includes the type checker and the meta processor).

1. `types:max_width`
    * This entry holds an integral value
    * This sets the maximum bit-width of a machine (in bytes)
    * This can either be `1`, `2`, `4` or `8`
    * It affects how aliases such as `size_t` and `ssize_t` behave in terms of what the resolve to

### `dgen`

These options configure the C code emitter.

1. `dgen:pretty_code`
    * This entry holds a boolean value
    * If `true` then the emitted code will be prettified, meaning it will be correctly indented. If `false` then no such prettifying will occur.
    * Default: `true`
2. `dgen:mapper`
    * This entry holds a string value
    * This controls how symbol names within T are translated
    * The two available options are:
        1. `"hashmapper"` - the hash of the T symbol name is the result
        2. `"lebanese"` - all periods (`.`) within T symbols are replaced by underscores (`_`)
    * Default: `"hashmapper"`
3. `dgen:emit_entrypoint_test`
    * This entry holds a boolean value
    * If `true` then instrumentation code will be added to the final output source code prior to compilation
    * Default: `true`
4. `dgen:preinline_args`
    * This entry holds a boolean value
    * If `true` then the arguments (expressions) given to a function call will be placed in adhoc variables declared in order of appearance
    * These _variables_ will be passed to the function call then
    * Default: `false` (TODO: change)
5. `dgen:compiler`
    * This entry holds a string value
    * This is the path to the compiler executable that should be used to compile the generated C code
    * Default: `clang`

### `emit`

This controls aspects of the `CodeEmitter` API, meaning irrespective of which emitter (such as `dgen`) is used.

TODO: Move `dgen_emit_entrypoint_test` and `dgen:pretty_code` here.
    
### `typecheck`

This controls the aspects of the `TypeChecker`.

1. `typecheck:warnUnusedVars`
    * If this is set to `true` then at the end of the typechecking process a scan for all variables will be done and any variable that is unused will be printed out
    * Default: `true`

### `tir`

This controls the aspects of the _TIR_ or **T**Lang **I**ntermediate **R**epresentation.

1. `tir:flatten_enum_refs`
    * If this is set to `true` then the values of enumeration-type members will be used directly. This is opposed to when this option is set to `false` which will then make use of a new `EnumMemberReference` instruction it is place rather.
    * The `false` case is useful for emitters who want to know something is specifically an enum member, which may be handy. As to the makeup, the original `Value`-based instruction is simply nested within the `EnumMemberReference` instruction when this option is set to `false`.
    * Default: `true`

### `modman`

This controls various aspects of the module management system:

1. `modman:strict_headers`
    * If this is set to `true` then it will enforce that every modules' declared name matches that of its filename _sans_ the file extension
    * Default: `false`
2. `modman:paths`
    * This contains additional search paths that the _module manager_ should use
    * It is the form of a _textual array_
    * Default: `[]`