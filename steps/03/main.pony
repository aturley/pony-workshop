use "net"

actor Main
  new create(env: Env) =>
    let host = try env.args(1)? else "" end
    let port = try env.args(2)? else "8989" end
    try
      TCPListener(env.root as AmbientAuth,
        ChatTCPListenNotify(host, port), host, port)
    end

class ChatTCPListenNotify is TCPListenNotify
  let _host: String
  let _port: String

  new iso create(host: String, port: String) =>
    _host = host
    _port = port

  fun ref connected(listen: TCPListener ref): TCPConnectionNotify iso^ =>
    ChatTCPConnectionNotify(_host, _port)

  fun ref not_listening(listen: TCPListener ref) =>
    None

class ChatTCPConnectionNotify is TCPConnectionNotify
  let _host: String
  let _port: String

  new iso create(host: String, port: String) =>
    _host = host
    _port = port

  fun ref received(
    conn: TCPConnection ref,
    data: Array[U8] iso,
    times: USize)
    : Bool
  =>
    conn.write("hello from [")
    conn.write(_host)
    conn.write(":")
    conn.write(_port)
    conn.write("], ")
    conn.write(consume data)
    conn.write("\n")
    true

  fun ref connect_failed(conn: TCPConnection ref) =>
    None
