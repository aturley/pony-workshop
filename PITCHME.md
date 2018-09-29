# Pony Workshop

## Learn some Pony!

---

## What is Pony?

> Pony is an open-source, object-oriented, actor-model, capabilities-secure, high-performance programming language.

---

## Why Pony?

* Fast
* Type-safe
* Message-oriented (actors)
* Concurrency without data races

---

## What Is Pony Good For?

Pony is a good language for writing fast stream-oriented and event-oriented servers.

---

## Concurrency without data races

All concurrency is handled through *actors*

The Pony compiler uses *reference capabilities* to guarantee that a program does not have data races

---

## Actors

* Messages that are sent to an actor are placed in a queue
* An actor processes one messages at a time
* Actors run concurrently
* When an actor is finished processing a message, it processes the next message in the queue or waits until a new message is available

---

## Messages

* A message is handled by a `behavior`
* Everything happens in the context of some behavior
* Messages can have parameters, which are aliases to objects

```
actor Speaker
  // behavior to print out a message
  be say(out: OutStream, message: String) =>
    out.print(message)

actor Main
  new create(env: Env) =>
    let speaker = Speaker
    // send `say` message to `speaker`
    speaker.say(env.out, "hello")
```

---

## Reference Capabilities

* All aliases have a reference capability
* Reference capabilities control read and write access
* If an object can be written to then no other actor can read from it or write to it
* If more than one actor can read from an object then no actor can write to it

---

## List of Ref Caps

* `iso` -- alias is R/W, no other alias can R or W
* `trn` -- alias is R/W, other aliases are R-only
* `ref` -- alias is R/W, other aliases can be R/W
* `val` -- alias is R-only, other aliases are R-only
* `box` -- alias is R-only, other aliases can be R-only or R/W
* `tag` -- alias cannot R or W, other aliases can be R-only or R/W

---

## How a Pony Program Works

1. Create an `Env` object
2. Create an instance of the `Main` actor
3. Send that instance a `create` message with `Env` object
4. The `Main` actor creates new actors
5. Actors receive and process messages from each other or the environment
6. When there are no more messages to process, terminate

---

## Things to Know (This Isn't Erlang/Scala/Haskell/F#)

* Message arguments are not copied
* Mutable data can be passed from one actor to another as long as the sender "gives up" its alias to the data
* Messages in the queue are always processed in order
* Doesn't really do type inference, does "type implication"
* No top-level functions/globals
