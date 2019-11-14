defmodule Hexpm.Repository.PackageDependent do
  use Hexpm.Schema

  @primary_key false
  schema "package_dependents" do
    field :name, :string
    field :repo, :string
    belongs_to :package, Package
    belongs_to :dependent, Package
  end
end
