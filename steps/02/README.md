# Step 02

This program prints out a "hello" message, where "hello" is followed by either the first argument to the program or "[unknown]" if there is no argument given to the program.

```pony
actor Main
  new create(env: Env val) =>
    let name: String val = try
      env.args(1)?
    else
      "[unknown]"
    end

    let msg: String val = recover val
      let m: String ref = String
      m.append("hello ")
      m.append(name)
      m
    end

    env.out.print(msg)
```

The program can be compiled by running the Pony compiler with no arguments in this directory. The program can be run with either no arguments or at least one argument. All arguments after the first argument will be ignored.

```
$ ./02
hello [unknown]
$ ./02 andrew
hello andrew
```

## Types and Reference Capabilities

The Pony compiler knows the type of every object in a program. The type of an object must be compatible with the type of the alias to which it is assigned. In the first program we talked about `Main`, `String`, and `Env`. These are types. There were other types in the program that we didn't explicitly talk about, such as the type of `env.out`.

In Pony, a full type includes a reference capability. Reference capabilities are used to limit how an object can be accessed using an alias.

| Reference Capability | Full Name | Meaning |
| -------------------- | --------- | ------- |
| iso | isolated | only this alias can be used to read or write to the object |
| trn | transitional | only this alias can be used to read or write to the object, other aliases may be used to read from the object |
| val | value | this alias can be used to read from the object, other aliases may also be able to read from the object, no alias can write to the object |
| ref | reference | this alias can be used to read and write to the object, other aliases may be able to read and/or write to the object |
| box | box | this alias can be used to read from the object, other aliases may be able to read and/or write to the object |
| tag | tag | this alias cannot read or write to the object |

If an alias references an actor then it can be used to send a message to the actor regardless of the reference capability.

In some places the Pony compiler can infer the type of an alias based on the type of object it is aliasing, but in other cases the program must specify the type. Every type has a default reference capability which is used by the compiler when the program does not specify one. For example, the default reference capability for a `String` alias is `val`, so if you use `String` as a type without specifying a reference capability then the compiler interprets it as `String val`.

In the program in this step we have been explicit about the reference capabilities and types of the aliases: `env`'s type is `Env val`, `name`'s type is `String val`, `msg`'s type is `String val` and `m`'s type is `String ref`. This is done in this example to make the type of each alias clear.

### Why Does Pony Have Reference Capabilities?

The Pony compiler uses reference capabilities to ensure that data safety is never compromised so that it can guarantee that programs are free of data races. At their heart, reference capabilities ensure that the following two properties are always true:

1. Read Rule -- If more than one actor can read from an object then no actor can write to the object.
2. Write Rule -- If an actor can write to an object then no other actor can read from the object.

For example, an `iso` alias can read and write to an object, so no other alias can read or write to that object. If we want to send this object from actor A to actor B, then actor A's alias must "give up" it's reference to the object. Aliases can give up their references to object by either using the `consume` keyword on the alias, or by doing a destructive read on the alias.

* `consume` -- When the `consume` keyword is applied to an alias, that alias no longer refers to the object and the alias can no longer be used in the program.
* destructive read -- A destructive read occurs when a `var` alias is assigned to a new object; the object to which it was assigned is no longer associated with that alias.

A `val` alias can only read from an object, and no other alias can be used to write to the object. This means that more than one actor could have a `val` alias that references the same object, because there is guaranteed to be no alias that can write to the object anywhere in the system. If an actor has a `val` alias, it can send the referenced object to another actor without "giving up" its alias; both actors can simultaneously have read access to the object.

A `tag` alias can also be safely passed between actors because `tag` aliases cannot be used to read or write to an object. While they cannot be used for reading or writing, `tag` aliases are still useful because they can be used to send messages to an actor.

`iso`, `val`, and `tag` aliases are said to be sendable because they can be sent from one actor to another. `trn`, `ref`, and `box` references are not sendable because even if they are consumed they cannot ensure the safety guarantees of the Read Rule and the Write Rule discussed earlier. The wrinkle is that a `trn` alias can be "given up" and sent to another actor as a `val` because the compiler knows that the `trn` alias was the only one that could write to the object, so all other aliases must be read-only and therefore it is safe to share the object among different actors.

It is important to understand that reference capabilities are only concerned with guaranteeing data race freedom. Functional programmers may be used to systems where all values are immutable. Immutability may be useful for reasoning about certain kinds of problems, and `val` will enforce immutability, but the only reason the Pony compiler cares about immutability is because it allows it to enforce the Read Rule and the Write Rule.

## Partial Functions

Partial functions are functions that return valid results for some of their inputs and raise errors for others. A call to a partial function is denoted with a `?` after the function call. If the function cannot return a valid result for a given input then it raises an error. A function must deal with all of the partial functions that are used inside of it, or it too must be a partial function and the errors generated in it will propogate out of it. The `try` block is used to handle errors and provide an alternative path of execution if an error is raised.

In this program we want to get the first command line argument that is passed to the program. Command line arguments are stored in an array called `args` in the `env` parameter. Accessing an item in the array is accomplished by calling a partial function called `apply` whose argument is the index of the array that you want to get. If the index is out of bounds then the function raises an error.

In this program we use a `try` block to attempt to get the argument at the index `1`; if this fails then we instead use a string literal `"[unknown]"`. A `try` block is an expression, so the result can be assigned to an alias. In this case the alias `name` will either have the value of the first command line argument or `"[unknown]"`.

```pony
    let name: String val = try
      env.args.apply(1)?
    else
      "[unknown]"
    end
```

### Errors and Behaviors

Functions can be partial, but behaviors must be total; all errors must be caught and handled before leaving a behavior. This means that errors cannot be used to signal to one actor that there was a problem in another actor. In Pony you should use promises or callbacks to communicate this kind of thing. In this example `create` is a behavior, so the potential error around accessing the argument array must be handled.

## Recovering Reference Capabilities

Sometimes it is useful to create an alias to an object with a flexible set of reference capabilities, manipulate that object in some way, and then get a version of the object that can be assigned to an alias with a more restrictive set of reference capabilities. This often occurs when one wants to create a `ref` alias, manipulate the object, and then turn it into a `val` or an `iso` so that it can be sent to another actor. In a situation like this we can use a `recover` block. Without the recover block we would have no way to convert from a `ref` to a `val`, because "giving up" a `ref` alias would not guarantee that there are no more aliases that can write to the object.

`recover` blocks have special rules about what can be done inside of them. For example, inside the `recover` block you cannot use a non-sendable alias that was created outside of the `recover` block. This guarantees that a non-sendable object cannot escape from the `recover` block.

In the program we create a mutable `String` called `m`.

```pony
      let m: String ref = String
```

The second occurence of `String` in the code above is a constructor for the string class. Constructors that do not take arguments are called without using parentheses.

The `String` class can be confusing to people who are new to Pony because using `String` as a type means `String val`, but the `String` constructor returns a `ref` object, so the following code will not compile:

```pony
let m: String = String
```

However, a string literal creates a `val` object, so this will compile:

```pony
let m: String = "hello"
```

In the case of our program, we use the `append` method to add `"hello "` and then value of `name` to the string in `m`. Then we return `m` from the `recover` block. As with the `try` block earlier, the `recover` block is an expression, so the last value is the result of the expression and can be assigned to an alias. The reference capability `val` appears after the `recover` keyword to indicate that the object should now have a reference capability of `val`.

```pony
    let msg: String val = recover val
      let m: String ref = String
      m.append("hello ")
      m.append(name)
      m
    end

    env.out.print(msg)
```

The `msg` alias is `val` so it can be used to send the string to `env.out` using the `print` message.

## Things to Try

1. Leave off the `?` at the end of `env.args.apply(1)?`.
2. Get rid of the `try ... else ... end` block and simply say `let name: String val = env.args.apply(1)?`.
3. The `recover` block in the example "lifts" a `String ref` to a `String val`. `val` and `box` aliases are both read-only, so what happens if you change the line `let msg: String val = recover val` to `let msg: String box = recover box`? Why?
4. What types of aliases will the compiler allow you to create to the object aliased by `msg`? For example, `let msg_box: String box = msg` is allowed. What other reference capablities besides `box` could you use for a new alias? Why?
5. Call `msg.append(" foo")` right before you print out `msg`.
