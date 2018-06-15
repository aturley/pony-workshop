# Step 04

This program implements a very basic chat server. The user can connect via telnet (by default it listens on the local host at port 8989). The first text followed by a newline is treated as the user's nickname, subsequent text is sent to all other connected clients.

## Sum Types

The `ChatTCPConnectionNotify` class represents a client connection to the chat server. It holds a reference called `_nick` that either refers to the `None` object or to a `String`.

```pony
  var _nick: (None | String) = None
```

Sum types are useful because they let references refer to objects of distinct types that are not related through a subtyping hierarchy. A program can take different kinds of action depending on a reference's type using a `match` statement. In the case of our `ChatTCPConnectionNotify` class we want to send an `add_connection` message to `_chat_room` if the connection has not been given a nickname, and send a `send_msg` message otherwise.

```pony
    match _nick
    | None =>
      let nick: String val = String.from_iso_array(consume data).>strip()
      conn.write("hello, " + nick + "\n")
      _chat_room.add_connection(conn, nick)
      _nick = nick
    | let n: String =>
      let msg: String val = String.from_iso_array(consume data).>strip()
      _chat_room.send_msg(n, msg)
    end
```

In this case the `_nickname` variable not only stores the nickname, it also acts as a kind of state indicator where the type tells us whether the nickname has been set (the value is a `String`) or not (the value is `None`).

## Actors

There is a single instance of a `ChatRoom` actor that coordinates activity between client connections. When new clients connect to the server and receive a nickname they send an `add_connection` message with the to the `ChatRoom` actor. The `add_connection` behavior handles the message, adding the client's `TCPConnection` and nickname to the `_conn_to_name` map.

### The `tag` Reference Capability

The `ChatTCPListenNotify` object has a member that references the `ChatRoom` actor. By default actor types have the `tag` reference capability, so

```pony
  let _chat_room: ChatRoom
```

can be expanded to

```pony
  let _chat_room: ChatRoom tag
```

A reference with a `tag` reference capability cannot be used to directly read from or write to an object. However, if the reference refers to an actor then the reference can send messages to that actor.

### Protecting State

Actors are a mechanism for protecting state. The `_conn_to_name` map needs to be read and updated in response to actions in many actors, but remember that Pony won't let more than one actor hold a reference to an object if one of the references is mutable. Instead of giving all of the actors access to the map, the map is stored in the actor and other actors update it by sending messages. These messages are processed one at a time so there is no risk of a race condition and no need to use locks to control access to the map.
