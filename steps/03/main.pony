use "collections"

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

actor Main
  new create(env: Env) =>
    let cr = ChatRoom

    cr.add_connection(env.out, "andy")
    cr.add_connection(env.out, "brian")
    cr.send_msg("andy", "hello chat room!")
