defmodule Forall.FileCheckerTest do
  use ExUnit.Case
  alias Forall.FileChecker
  alias Forall.Files.Bucket
  import Forall.Factory

  test "should validate files without imports" do
    assert {:ok, []} = FileChecker.check(valid_term())
  end

  test "should reject files that doesn't typecheck" do
    assert :error = FileChecker.check(invalid_term())
  end

  test "should reject files that has unnanotated terms" do
    assert :error = FileChecker.check(unnanotated_term())
  end

  test "should reject files with unexistent imports" do
    {_file, _version, code} = importing_code(valid_term())

    assert :error = FileChecker.check(code)
  end

  test "should return imports" do
    {name_2, version_2, code_1} = importing_code(valid_term("a"))
    code_2 = valid_term("b")
    Bucket.upload("#{name_2}/#{version_2}.fm", code_2)

    assert {:ok, [%{name: name_2, version: version_2, direct: true}]} == FileChecker.check(code_1)
  end

  test "should return nested imports" do
    {name_2, version_2, code_1} = importing_code(valid_term("a"))
    {name_3, version_3, code_2} = importing_code(valid_term("b"))
    code_3 = valid_term("c")
    Bucket.upload("#{name_2}/#{version_2}.fm", code_2)
    Bucket.upload("#{name_3}/#{version_3}.fm", code_3)
    assert {:ok, imports} = FileChecker.check(code_1)
    assert length(imports) == 2

    assert %{name: name_2, version: version_2, direct: true} ==
             Enum.find(imports, &(&1.name == name_2))

    assert %{name: name_3, version: version_3, direct: false} ==
             Enum.find(imports, &(&1.name == name_3))
  end
end
