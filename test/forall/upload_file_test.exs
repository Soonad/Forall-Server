defmodule Forall.Files.UploadFileTest do
  use Forall.DataCase, async: false
  alias Forall.Files.Bucket
  alias Forall.Files.UploadFile
  import Mock

  test_with_mock(
    "it just call bucket to upload file with correct name",
    Bucket,
    upload: fn _, _ -> :ok end
  ) do
    code = valid_term()
    name = file_name()
    version = file_version()
    UploadFile.perform(%{"name" => name, "version" => version, "code" => code}, nil)
    assert_called(Bucket.upload("#{name}/#{version}.fm", code))
  end
end
