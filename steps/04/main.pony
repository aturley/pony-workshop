use "collections"
use "net"

actor Main
  new create(env: Env) =>
    try
      TCPListener(env.root as AmbientAuth,
        recover ChatTCPListenNotify(ChatRoom) end, "", "8989")
    end

class ChatTCPConnectionNotify is TCPConnectionNotify
  let _chat_room: ChatRoom
  var _nick: (None | String) = None

  new iso create(chat_room: ChatRoom) =>
    _chat_room = chat_room

  fun ref received(
    conn: TCPConnection ref,
    data: Array[U8] iso,
    times: USize)
    : Bool
  =>
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
    true

  fun ref connect_failed(conn: TCPConnection ref) =>
    None

class ChatTCPListenNotify is TCPListenNotify
  let _chat_room: ChatRoom

  new create(chat_room: ChatRoom) =>
    _chat_room = chat_room

  fun ref connected(listen: TCPListener ref): TCPConnectionNotify iso^ =>
    ChatTCPConnectionNotify(_chat_room)

  fun ref not_listening(listen: TCPListener ref) =>
    None

interface tag HasWrite
  be write(data: ByteSeq)

actor ChatRoom
  let conn_to_name: MapIs[HasWrite, String] = conn_to_name.create()

  be add_connection(conn: HasWrite, nick: String) =>
    conn_to_name(conn) = nick

  be send_msg(nick: String, msg: String) =>
    for (c, n) in conn_to_name.pairs() do
      if nick != n then
        c.write(nick + ": " + msg + "\n")
      end
    end
