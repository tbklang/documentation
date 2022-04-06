Statements
=========

## Introduction

This section will revise all statement-types and their contents.

## Structures

Starting from most general to most specific, here, we will explain all the class types in the `compiler/symbols/data.d` file.

---

### Statement [`class`]

This is the holy grail of everything the parser generates. This is the top-level general representation-base of all structures. This means that this class represents the attributes that all structures that are sub-types of it (as you will see) will have. All parser methods produce some sub-type of the `Statement` type and return it for addition into either another _kinf-of_ statement or for immediate addition to the `Program`'s `statements` array.

Being a general top-type there isn't much it has but it has a few things all _types of statements_ will require:

1. `weight`
    * These are simply integers which are for the topic of discussion of [weighting](../weigthing)
    * Some statements share the same weight, some don't
2. `context`
    * This is used at a stage other than parsing and is not for discussion here, see [context](../typechecking/context)
3. `container`
    * This is where the _structures of structures_ aspect comes in. This allows us to set the _container-like_ strcuture
    to of which we are a parent of
    * This is **returned** by `parentOf()` (type `Container`)
    * This is **set** by `parentTo(Container)`

---

### Entity [`class`]

An Entity is any statement that represents a structure in T that is a named structure. The following structures in T are named and therefore will be represented as sub-type of the `Entity` type in the parser:

1. Classes
2. Variables (declarations)
3. Function (declarations)
4. Structs



TODO: Add now Entity, etc, VarAsign, VArAsignSTdALone etc