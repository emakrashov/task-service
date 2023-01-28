defmodule TaskServiceWeb.ErrorJSON do
  # If you want to customize a particular status code,
  # you may add your own clauses, such as:
  #
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".

  def render("422.json", %{conn: %{assigns: %{reason: %Ecto.InvalidChangesetError{} = changeset_error}}}) do
    render_changeset_error(changeset_error.changeset)
  end

  def render("400.json", %{conn: conn}) do
    %{errors: %{detail: conn.assigns.reason.message}}
  end

  def render(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end

  defp render_changeset_error(changeset) do
    errors =
      Enum.map(changeset.errors, fn {field, error} ->
        %{
          field: field,
          message: render_changeset_error_message(error)
        }
      end)

    %{errors: errors}
  end

  defp render_changeset_error_message({message, values}) do
    Enum.reduce(values, message, fn {k, v}, acc ->
      String.replace(acc, "%{#{k}}", to_string(v))
    end)
  end

  defp render_changeset_error_message(message), do: message
end
