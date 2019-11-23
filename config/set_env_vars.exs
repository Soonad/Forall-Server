set = &System.put_env(&1, System.get_env("SET_#{&1}", &2))

set.("PUBLIC_HOST", "localhost")
set.("PUBLIC_PATH", "/")
set.("PUBLIC_PORT", "4000")
set.("PUBLIC_SCHEME", "http")

set.("DATABASE_URL", "postgresql://postgres:postgres@localhost/forall_#{Mix.env()}")
set.("DATABASE_POOL_SIZE", "2")
set.("PORT", "4000")
set.("FILE_CHECKER_PATH", Path.expand(Path.join(__DIR__, "../file_checker")))

set.("BUCKET_ACCESS_KEY", "wLfYx0GqCl9jOA355XVzqQ")
set.("BUCKET_SECRET_KEY", "2Z4g1TrMzCYcQUvwzEHJEI3RKkbPSyE0nqGiWJmVZDM")
set.("BUCKET_HOST", "localhost")
set.("BUCKET_PORT", "9000")
set.("BUCKET_NAME", "forall-#{Mix.env()}")
set.("BUCKET_SCHEME", "http://")
