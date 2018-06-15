actor Main
  new create(env: Env val) =>
    let name: String val = try
      env.args.apply(1)?
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
