defmodule TutorialWeb.CMS.FlokController do
  use TutorialWeb, :controller

  alias Tutorial.CMS
  alias Tutorial.CMS.Flok

  plug(:require_existing_creator)
  plug(:authorize_flok when action in [:edit, :update, :delete, :show])

  def index(conn, _params) do
    floks = CMS.only_creator_floks(conn.assigns[:current_user])
    render(conn, "index." <> get_format(conn), floks: floks)
  end

  def new(conn, _params) do
    changeset = CMS.change_flok(%Flok{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"flok" => flok_params}) do
    case CMS.create_flok(conn.assigns.current_creator, flok_params) do
      {:ok, flok} ->
        conn
        |> put_flash(:info, "Flok created successfully.")
        |> redirect(to: cms_flok_path(conn, :show, flok))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, _) do
    flok = conn.assigns[:flok]
    render(conn, "show." <> get_format(conn), flok: flok)
  end

  def edit(conn, _) do
    changeset = CMS.change_flok(conn.assigns.flok)
    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"flok" => flok_params}) do

    case CMS.update_flok(conn.assigns.flok, flok_params) do
      {:ok, flok} ->
        conn
        |> put_flash(:info, "Flok updated successfully.")
        |> redirect(to: cms_flok_path(conn, :show, flok))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, _) do
    {:ok, _flok} = CMS.delete_flok(conn.assigns.flok)

    conn
    |> put_flash(:info, "Flok deleted successfully.")
    |> redirect(to: cms_flok_path(conn, :index))
  end


  # Private methods
  defp require_existing_creator(conn, _) do
    creator = CMS.ensure_creator_exists(conn.assigns.current_user)
    assign(conn, :current_creator, creator)
  end

  defp authorize_flok(conn, _) do
    flok = CMS.get_flok!(conn.params["id"])
    if conn.assigns.current_creator.id == flok.creator_id do
      assign(conn, :flok, flok)
    else
      conn
      |> put_flash(:error, "You can't modify that page")
      |> redirect(to: cms_flok_path(conn, :index))
      |> halt()
    end
  end

  defp user_floks(user) do
    assoc(user, :floks)
  end
end
