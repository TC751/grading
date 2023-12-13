defmodule Grading.Repo do
  use Ecto.Repo,
    otp_app: :grading,
    adapter: Ecto.Adapters.Postgres
end
