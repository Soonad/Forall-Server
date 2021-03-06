defmodule Forall.Files.CheckFileTest do
  use Forall.DataCase, async: false

  alias Forall.Files.CheckFile
  alias Forall.Files.File
  alias Forall.Files.Import
  alias Forall.Files.UploadFile
  alias Forall.Files.Version
  alias Forall.Repo

  import Mock

  setup do
    name = file_name()
    code = valid_term()
    version = Version.version_hash(code)
    direct = build(:file_checker_import, direct: true)
    indirect = build(:file_checker_import, direct: false)

    %{
      name: name,
      code: code,
      version: version,
      direct: direct,
      indirect: indirect
    }
  end

  test "should insert file metadata and schedule an upload job", ctx do
    %{name: name, version: version, direct: direct, indirect: indirect} = ctx

    imports = Enum.shuffle([ctx.direct, ctx.indirect])

    with_mock(Forall.FileChecker, check: fn _code -> {:ok, imports} end) do
      CheckFile.perform(%{"name" => name, "code" => ctx.code}, nil)

      assert %File{
               name: ^name,
               version: ^version,
               deep_imports: deep_imports
             } = file = Repo.one(File)

      assert length(deep_imports) == 2

      assert direct.reference in deep_imports
      assert indirect.reference in deep_imports

      imported_name = direct.reference.name
      imported_version = direct.reference.version

      assert [
               %Import{
                 imported_name: ^imported_name,
                 imported_version: ^imported_version,
                 importer_name: ^name,
                 importer_version: ^version
               }
             ] =
               file
               |> File.reference()
               |> Import.by_importer()
               |> Repo.all()

      assert_called(Forall.FileChecker.check(ctx.code))

      assert_enqueued(
        worker: UploadFile,
        args: %{code: ctx.code, name: name, version: version}
      )
    end
  end

  test "should do nothing if it doesnt typecheck", ctx do
    with_mock(Forall.FileChecker, check: fn _code -> :error end) do
      CheckFile.perform(
        %{"name" => ctx.name, "code" => ctx.code},
        nil
      )

      assert [] = Repo.all(File)
      assert [] = Repo.all(Import)
      refute_enqueued(worker: UploadFile)
    end
  end
end
