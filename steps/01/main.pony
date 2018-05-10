actor Main
  new create(env: Env) =>
    let msg = "hello world"
    env.out.print(msg)
