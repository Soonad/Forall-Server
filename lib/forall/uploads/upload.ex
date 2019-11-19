defmodule Forall.Uploads.Upload do
  @moduledoc """
  An upload is a code that is requested for publishing, but needs to pass some checks before it is
  published under an immutable version.

  If we decide the version will be the hash of a file, then this model doesn't need to exist since
  we don't need a way to inform the user of the version after the checking is complete since the
  uploader can know that beforehand.

  But for now, let's keep this the way it is right now.
  """

  use TypedEctoSchema

  @primary_key {:id, :binary_id, autogenerate: true}
  typed_schema "uploads" do
    field :name, :string
    field :version, :string

    timestamps()
  end
end
