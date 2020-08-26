defmodule ExchangeApi.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :jwt, :text

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
