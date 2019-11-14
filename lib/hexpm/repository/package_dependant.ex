defmodule Hexpm.Repository.PackageDependant do
  use Hexpm.Schema

  @primary_key false
  schema "package_dependants" do
    field :name, :string
    field :repo, :string
    belongs_to :package, Package
    belongs_to :dependant, Package
  end
end
