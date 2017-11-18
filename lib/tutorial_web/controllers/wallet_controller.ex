defmodule TutorialWeb.WalletController do
  use TutorialWeb, :controller

  alias Tutorial.Accounts
  alias Tutorial.Accounts.Wallet

  def index(conn, _params) do
    wallets = Accounts.list_wallets()
    render(conn, "index.html", wallets: wallets)
  end

  def new(conn, _params) do
    changeset = Accounts.change_wallet(%Wallet{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"wallet" => wallet_params}) do
    case Accounts.create_wallet(wallet_params) do
      {:ok, wallet} ->
        conn
        |> put_flash(:info, "Wallet created successfully.")
        |> redirect(to: wallet_path(conn, :show, wallet))

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

    case Accounts.update_wallet(wallet, wallet_params) do
      {:ok, wallet} ->
        conn
        |> put_flash(:info, "Wallet updated successfully.")
        |> redirect(to: wallet_path(conn, :show, wallet))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", wallet: wallet, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    wallet = Accounts.get_wallet!(id)
    {:ok, _wallet} = Accounts.delete_wallet(wallet)

    conn
    |> put_flash(:info, "Wallet deleted successfully.")
    |> redirect(to: wallet_path(conn, :index))
  end
end