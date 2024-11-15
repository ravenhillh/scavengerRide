defmodule ScavengerRide.Repo.Migrations.CreatePoints do
  use Ecto.Migration

  def change do
    create table(:points) do
      add :name, :string
      add :lat, :float
      add :long, :float
      add :prompt, :string
      add :answer, :string

      timestamps(type: :utc_datetime)
    end
  end
end
