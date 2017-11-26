defmodule TutorialWeb.CMS.WalletController do
  use TutorialWeb, :controller

  alias Tutorial.Accounts
  alias Tutorial.Accounts.Wallet

  def index(conn, _params) do
    wallets = Accounts.list_user_wallets(conn.assigns.current_user)
    render(conn, "index.html", wallets: wallets)
  end

  def new(conn, _params) do
    changeset = Accounts.change_wallet(%Wallet{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"wallet" => wallet_params}) do
    with user <- conn.assigns.current_user,
      {:ok, wallet} <- Accounts.create_wallet(wallet_params, user) do
        conn
        |> put_flash(:info, "Wallet created successfully.")
        |> redirect(to: cms_wallet_path(conn, :show, wallet))
      else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    if wallet = Accounts.get_wallet!(id) do
      conn
      |> render("show.html", wallet: wallet)
    else
      conn
      |> redirect(to: "/wallets")
    end
  end

  def edit(conn, %{"id" => id}) do
    wallet = Accounts.get_wallet!(id)
    changeset = Accounts.change_wallet(wallet)
    render(conn, "edit.html", wallet: wallet, changeset: changeset)
  end

  def update(conn, %{"id" => id, "wallet" => wallet_params}) do
    wallet = Accounts.get_wallet!(id)
    with {:ok, wallet} <- Accounts.update_wallet(wallet, wallet_params) do
        conn
        |> put_flash(:info, "Wallet updated successfully.")
        |> redirect(to: cms_wallet_path(conn, :show, wallet))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", wallet: wallet, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    wallet = Accounts.get_wallet!(id)
    {:ok, _wallet} = Accounts.delete_wallet(wallet)

    conn
    |> put_flash(:info, "Wallet deleted successfully.")
    |> redirect(to: cms_wallet_path(conn, :index))
  end
end
