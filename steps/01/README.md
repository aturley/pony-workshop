# Step 01

This program simply print's "hello world". It may seem very basic, but it introduces a few important concepts in Pony.

```pony
actor Main
  new create(env: Env) =>
    let msg = "hello world"
    env.out.print(msg)
```

## Compiling and Running the Program

To compile this program, run the Pony compiler without any arguments in the directory that contains the `main.pony` file.

```
ponyc
```

The Pony compiler looks for Pony code in the directory from which it is run and builds it. It will produce an executable with the same name as the directory from which it is run. In this case, the executable will be called `01`. Once the compiler has finished the executable can be run.

```
./01
```

When you run the program you should see `hello world` printed to the screen.

## Anatomy of a Pony Program

### Actors

Programs in Pony start with actors. In fact, anything that happens in a Pony program happens because of an actor. Actors are the unit of concurrency in Pony. The runtime can run many different actors at the same time, but each actor only processes one message at a time.

#### The `Main` Actor

The `Main` actor is the parent of all other actors. When the program starts, the runtime creates an instance of the `Main` actor and sends it a `create` message. Messages can have arguments, and in this case the argument is an object called `env` of type `Env`. The `env` object contains information that comes into the program, such as the environment variables (accessed via the method `env.var()`), the command line arguments (`env.args`), and actors that represent the standard input (`env.input`), standard output (`env.out`), and standard error (`env.err`) streams.

### Messages

Actors do things in response to messages.

When an actor sends a message, the runtime places the message on the recipient's message queue. Actors process the messages on their queues one at a time in first-in-first-out order. Once a message has been processed the actor will perform any necessary garbage collection steps and then wait until another message is avaible for processing. It is important to understand that messages are sent asynchronously. The sender does not wait for a response, it continues executing its code.

In this program, the `Main` actor sends a message to the `env.out` actor to print a message. This message takes a string argument and prints it to the standard output. The `.` operator is used to send a message to an actor, as in `env.out.print(msg)`. Messages are handled by methods that are called behaviors. A behavior has the same name as the message that is sent to it.

### Aliases

The line `let msg = "hello world"` creates a `String` object whose value is `"hello world"` and assigns that object to an alias called `msg`. Aliases are names that are associated with an object. Using `let` means that the alias cannot be reassigned to refer to a new object; `var` can be used if the alias needs to be able to refer to new objects. In this program, the alias `msg` is used to include the `String` object as part of the `print` message that gets sent to the `env.out` actor.

`env` is also an alias. Any time you have a name that refers to an object you have an alias. Parameters to methods are aliases, so if you call a method then aliases will be created that refer to the objects that you pass as arguments.
