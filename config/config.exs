import Config

# Import configs that are the same between environments
import_config "shared.exs"

# Import environment-specific configurations
import_config "#{Mix.env()}.exs"

# This is an easy way to setup default variables for development
# Basically it runs an script to set env variables and then import the releases config file.
# We don't import the releases.exs in production because this happens on compile-time
# Elixir releases will load that file on boot, so we are sure things are configured correctly.
unless Mix.env() == :prod do
  Code.eval_file("config/set_env_vars.exs")
  Code.compile_file("lib/forall_env.ex")
  import_config("releases.exs")
end
