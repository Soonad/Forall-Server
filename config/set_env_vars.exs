set = &System.put_env(&1, System.get_env(&1, &2))

set.("DATABASE_URL", "postgresql://postgres:postgres@localhost/forall_#{Mix.env()}")
set.("PORT", "4000")
set.("FILE_CHECKER_PATH", Path.expand(Path.join(__DIR__, "../file_checker")))
