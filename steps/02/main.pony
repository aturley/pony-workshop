use "net"

actor Main
  new create(env: Env) =>
    let host = try env.arg(1)? else "" end
    let port = try env.art(2)? else "8989" end
    try
      TCPListener(env.root as AmbientAuth,
        recover ChatTCPListenNotify end, host, port)
    end

// https://github.com/ponylang/ponyc/blob/0.21.3/packages/net/tcp_listen_notify.pony
class ChatTCPListenNotify is TCPListenNotify
  fun ref connected(listen: TCPListener ref): TCPConnectionNotify iso^ =>
    ChatTCPConnectionNotify

  fun ref not_listening(listen: TCPListener ref) =>
    None

class ChatTCPConnectionNotify is TCPConnectionNotify
  fun ref received(
    conn: TCPConnection ref,
    data: Array[U8] iso,
    times: USize)
    : Bool
  =>
    conn.write("hello, ")
    conn.write(consume data)
    conn.write("\n")
    true

  fun ref connect_failed(conn: TCPConnection ref) =>
    None
