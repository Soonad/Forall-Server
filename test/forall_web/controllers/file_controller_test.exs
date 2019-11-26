defmodule ForallWeb.FileControllerTest do
  use ForallWeb.ConnCase
  alias ForallWeb.OpenApiSpex.Spec, as: ApiSpec

  setup do
    %{api_spec: ApiSpec.spec()}
  end

  describe "POST /api/files" do
    test "should schedule a job", ctx do
      namespace = "public"
      name = "Name"
      code = "code"

      assert %{"name" => ^name, "version" => version} =
               ctx.conn
               |> put_req_header("content-type", "application/json")
               |> post("/api/files", %{code: code, name: name, namespace: namespace})
               |> json_response(202)

      assert String.length(version) == 4

      assert_enqueued(
        worker: Forall.Files.CheckFile,
        args: %{code: code, name: name, namespace: namespace}
      )
    end

    test "should return 403 if namespace is not public", ctx do
      namespace = file_namespace()
      name = "Name"
      code = "code"

      assert %{} =
               ctx.conn
               |> put_req_header("content-type", "application/json")
               |> post("/api/files", %{code: code, name: name, namespace: namespace})
               |> json_response(403)

      refute_enqueued(worker: Forall.Files.CheckFile)
    end
  end

  describe "GET /api/files/:name/:version" do
    test "should return the file converted to the spec", ctx do
      imported_ref = build(:file_reference)
      importer_ref = build(:file_reference)
      file = insert(:file, deep_imports: [imported_ref])
      insert(:import, imported_file: file, importer_ref: importer_ref)

      response =
        ctx.conn
        |> put_req_header("content-type", "application/json")
        |> get("/api/files/#{file.namespace}/#{file.name}/#{file.version}")
        |> json_response(200)

      assert_schema(response, "File", ctx.api_spec)

      assert response == %{
               "reference" => %{
                 "namespace" => file.namespace,
                 "name" => file.name,
                 "version" => file.version
               },
               "imported_by" => [
                 %{
                   "namespace" => importer_ref.namespace,
                   "name" => importer_ref.name,
                   "version" => importer_ref.version
                 }
               ],
               "deep_imports" => [
                 %{
                   "namespace" => imported_ref.namespace,
                   "name" => imported_ref.name,
                   "version" => imported_ref.version
                 }
               ]
             }
    end
  end
end
