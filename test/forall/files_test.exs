defmodule Forall.FilesTest do
  use Forall.DataCase

  alias Forall.Files
  alias Forall.Files.File

  describe "get_file/2" do
    test "should return nil if no file is found" do
      assert {:error, :not_found} = Files.get_file(build(:file_reference))
    end

    test "should return the file" do
      imported_ref = build(:file_reference)
      importer_ref = build(:file_reference)
      file = insert(:file, deep_imports: [imported_ref])
      reference = File.reference(file)
      insert(:import, imported_file: file, importer_ref: importer_ref)

      assert {:ok, returned_file = %File{}} = Files.get_file(reference)

      assert File.reference(returned_file) == reference
      assert returned_file.deep_imports == [imported_ref]
      assert returned_file.imported_by == [importer_ref]
    end
  end
end
