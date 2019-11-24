[
  ## all available options with default values (see `mix check` docs for description)
  # parallel: true,
  # skipped: true,

  ## list of tools (see `mix check` docs for defaults)
  tools: [
    {:sobelow, false},
    {:credo, "mix credo --strict --format oneline"},
    {:dialyzer, "mix dialyzer"},
    {:ex_unit,
     command:
       if(System.get_env("CIRRUS_CI") == "true",
         do: "mix coveralls.cirrus",
         else: "mix coveralls.html"
       )}

    ## ...or reordered (e.g. to see output from ex_unit before others)
    # {:ex_unit, order: -1},

    ## custom new tools may be added (mix tasks or arbitrary commands)
    # {:my_mix_task, command: "mix release", env: %{"MIX_ENV" => "prod"}},
    # {:my_arbitrary_tool, command: "npm test", cd: "assets"},
    # {:my_arbitrary_script, command: ["my_script", "argument with spaces"], cd: "scripts"}
  ]
]
