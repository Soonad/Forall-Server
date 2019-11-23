defmodule Forall.Factory do
  @moduledoc false
  use ExMachina.Ecto, repo: Forall.Repo

  alias Forall.Files.File
  alias Forall.Files.FileReference
  alias Forall.Files.Import

  def file_reference_factory do
    %FileReference{
      name: file_name(),
      version: file_version()
    }
  end

  def file_factory do
    %File{
      name: file_name(),
      version: file_version(),
      deep_imports: []
    }
  end

  def import_factory(attrs) do
    %Import{
      imported_name: get_import_field(attrs, :imported, :name),
      imported_version: get_import_field(attrs, :imported, :version),
      importer_name: get_import_field(attrs, :importer, :name),
      importer_version: get_import_field(attrs, :importer, :version)
    }
  end

  defp get_import_field(attrs, importex, field) do
    generated = %{
      name: file_name(),
      version: file_version()
    }

    Enum.find(
      [
        attrs[:"#{importex}_#{field}"],
        Map.get(Map.get(attrs, :"#{importex}_file", %{}), field),
        Map.get(Map.get(attrs, :"#{importex}_ref", %{}), field)
      ],
      generated[field],
      &(not is_nil(&1))
    )
  end

  def valid_term(name \\ "a"), do: "#{name} : Number 1"
  def unnanotated_term(name \\ "a"), do: "#{name} 1"
  def invalid_term(name \\ "a"), do: "#{name} : Number [1, 2]"

  def importing_code(body) do
    name = file_name()
    version = file_version()

    code = """
    import #{name}##{version}

    #{body}
    """

    {name, version, code}
  end

  def file_name do
    6 |> :crypto.strong_rand_bytes() |> Base.encode32(padding: false)
  end

  def file_version do
    50 |> :crypto.strong_rand_bytes() |> Forall.Files.Version.version_hash()
  end
end
