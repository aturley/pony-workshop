# Step 03

This program listens for connections on a TCP port; when a connection is established it waits to receive some data and then sends out a response that incorporates the data. You can connect to it using a telnet client. By default it listens on port 8989 of localhost.

## Interfaces

After setting the host and port on which to listen for incoming connections, the program creates a `TCPListener` actor. This actor listens for incoming TCP connections. When it receives a connection request it calls methods in a `TCPListenNotify` object to figure out what to do. `TCPListenNotify` is an interface. In Pony, interfaces serve two purposes:

* Any class or actor that implements the methods defined by the interace is considered to be a subtype of that interface. This is called *structural subtyping* because the subtyping relationship is based on the structure of the class.
* An interface can provide default implementations for its methods. These methods are inherited by a class that explicitly declares itself a subtype of the interface using the `is` keyword.

## Using Interfaces to Control Actors

The methods in `TCPListenNotify` are called by `TCPListener` actors to do something at various points in the lifecycle of a TCP connection. For example, when a new connection is established the `TCPListener` actor calls the `connected` method. Default methods are provided for `listening` and `closed`, but subtypes must provide their own implementations of `not_listening` and `connected`.

This is a common pattern in the Pony standard library; rather than subtyping an actor the programmer subtypes an interface that controls what the actor does at different points and passes an instance of this class to the actor. It is similar to the "Strategy" pattern described by Gamma, Helm, Johnson, and Vlissides in their book "Design Patterns".

The `ChatTCPListenNotify` class is a subtype of `TCPListenNotify`. It stores the host and port to which the listener is bound. When it receives a new connection it returns a `ChatTCPConnectionNotify` object. This object is used by an actor that handles this new connection. `ChatTCPConnectionNotify` is a subtype of the `TCPConnectionNotify` inteface, which has methods that are called to determine how to respond to events on the connection. When it receives data from a connection it calls the `receive` method with that data. In this case the `receive` method writes out a "hello" message to the connection.

## More About Reference Capabilities

By default, a class constructor returns an object that can be assigned to a `ref` or a `tag` alias. In this example the `ChatTCPListenNotify` and `ChatTCPConnectionNotify` objects are created and then passed to actors; the reference types of the aliases in the actor constructor is `iso`, and you cannot assign a `ref` to an `iso`. So the constructors for `ChatTCPListenNotify` and `ChatTCPConnectionNotify` start with `new iso create(...` to indicate that the objects that are returned can be assigned to `iso` aliases.

The parameter aliases for messages must be either `tag`, `val`, or `iso` because they must be something that can be shared with the actor or sent to it. A user may want to have a `TCPListenNotify` or `TCPConnectionNotify` object that can be modified as it processes network events, so `iso` is used because `tag` and `val` aliases cannot be used to modify the objects they refer to.

## Ambient Authority

Pony is designed around the idea of using capabilities to control access to resources. Objects that access things like the file system and the network can only be created by passing along a token that indicates that the program has permission to access those resources. A "token" in this context is an object. A Pony program creates such a token when it starts up and stores it in `env.root`. The token is an `AmbientAuth` object, and it can only be created by the runtime. This gives the programmer a way to identify and control which parts of a program have access to external systems.

The first argument to the `TCPListener`'s constructor is the `AmbientAuth` object.

```pony
      TCPListener(env.root as AmbientAuth,
        ChatTCPListenNotify(host, port), host, port)
```

If you look at the code for `TCPListener` you'll see that the first parameter is not actually used by the constructor; the only purpose of the `AmbientAuth` argument is to communicate that the piece of the program that is creating the `TCPListener` is authorized to interact with the world outside of the program.

For more information about capabilties and ambient authority please see [the Pony API documentation for `AmbientAuthority`](https://stdlib.ponylang.org/builtin-AmbientAuth/), [the Pony Tutorial](https://tutorial.ponylang.org/capabilities/object-capabilities.html), and ["Capability Myths Demolished"](http://srl.cs.jhu.edu/pubs/SRL2003-02.pdf).
