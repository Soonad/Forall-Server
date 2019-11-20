set = &System.put_env(&1, System.get_env(&1, &2))

set.("DATABASE_URL", "postgresql://postgres:postgres@localhost/forall_#{Mix.env()}")
set.("PORT", "4000")
set.("FILE_CHECKER_PATH", Path.expand(Path.join(__DIR__, "../file_checker")))

set.("BUCKET_ACCESS_KEY", "wLfYx0GqCl9jOA355XVzqQ")
set.("BUCKET_SECRET_KEY", "2Z4g1TrMzCYcQUvwzEHJEI3RKkbPSyE0nqGiWJmVZDM")
set.("BUCKET_HOST", "localhost")
set.("BUCKET_PORT", "9000")
set.("BUCKET_NAME", "forall_#{Mix.env()}")
set.("BUCKET_SCHEME", "http://")
