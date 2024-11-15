defmodule ScavengerRide.Repo do
  use Ecto.Repo,
    otp_app: :scavengerRide,
    adapter: Ecto.Adapters.Postgres
end
