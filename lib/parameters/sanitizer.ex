defmodule Parameters.Sanitizer do
  use Plug.Builder

  alias Ecto.Changeset

  plug :sanitize

  defp sanitize(conn, _opts) do
    case Parameters.params_for(conn) do
      {:ok, params} ->
        Map.put(conn, :params, params)
      {:error, changeset} ->
        errors = errors_from_changeset(changeset)

        conn
        |> put_resp_content_type("application/json")
        |> resp(:bad_request, Jason.encode!(errors))
        |> send_resp()
        |> halt()
    end
  end

  defp errors_from_changeset(changeset) do
    Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end