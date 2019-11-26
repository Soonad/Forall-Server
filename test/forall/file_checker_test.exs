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
    {_reference, code} = importing_code(valid_term())

    assert :error = FileChecker.check(code)
  end

  test "should return imports" do
    {ref_2, code_1} = importing_code(valid_term("a"))
    code_2 = valid_term("b")
    Bucket.upload(ref_2, code_2)

    assert {:ok, [%{reference: ref_2, direct: true}]} == FileChecker.check(code_1)
  end

  test "should use public as default namespace for imports" do
    code_2 = valid_term("a")
    ref_2 = build(:file_reference, namespace: "public")
    code_1 = "import #{ref_2.name}##{ref_2.version} #{valid_term("b")}"
    Bucket.upload(ref_2, code_2)

    assert {:ok, [%{reference: ref_2, direct: true}]} == FileChecker.check(code_1)
  end

  test "should return nested imports" do
    {ref_2, code_1} = importing_code(valid_term("a"))
    {ref_3, code_2} = importing_code(valid_term("b"))
    code_3 = valid_term("c")
    Bucket.upload(ref_2, code_2)
    Bucket.upload(ref_3, code_3)
    assert {:ok, imports} = FileChecker.check(code_1)
    assert length(imports) == 2

    assert %{reference: ref_2, direct: true} ==
             Enum.find(imports, &(&1.reference == ref_2))

    assert %{reference: ref_3, direct: false} ==
             Enum.find(imports, &(&1.reference == ref_3))
  end
end
