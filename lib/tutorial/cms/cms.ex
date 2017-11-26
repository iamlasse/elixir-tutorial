defmodule Tutorial.CMS do
  @moduledoc """
  The CMS context.
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset
  alias Tutorial.Repo
  alias Tutorial.Accounts.User
  alias Tutorial.CMS.{Flok, Creator}

  @doc """
  Returns the list of floks.

  ## Examples

      iex> list_floks()
      [%Flok{}, ...]

  """
  def list_floks do
    Flok
    |> Repo.all()
    |> Ecto.assoc(:creator)
    |> Repo.preload([:players, creator: [:user]])
  end

  def only_creator_floks(user),
    do: user |> Ecto.assoc(:floks) |> Repo.all() |> Repo.preload(:creator)

  @doc """
  Gets a single flok.

  Raises `Ecto.NoResultsError` if the Flok does not exist.

  ## Examples

      iex> get_flok!(123)
      %Flok{}

      iex> get_flok!(456)
      ** (Ecto.NoResultsError)

  """
  def get_flok!(id),
    do: Flok |> Repo.get!(id) |> Repo.preload([:players, creator: [:user]])

  @doc """
  Creates a flok.

  ## Examples

      iex> create_flok(%{field: value})
      {:ok, %Flok{}}

      iex> create_flok(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_flok(%Creator{} = creator, attrs \\ %{}) do
    %Flok{}
    |> Flok.changeset(attrs)
    |> put_change(:creator_id, creator.id)
    |> Repo.insert()
  end

  @doc """
  Updates a flok.

  ## Examples

      iex> update_flok(flok, %{field: new_value})
      {:ok, %Flok{}}

      iex> update_flok(flok, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_flok(%Flok{} = flok, attrs) do
    flok
    |> Flok.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Flok.

  ## Examples

      iex> delete_flok(flok)
      {:ok, %Flok{}}

      iex> delete_flok(flok)
      {:error, %Ecto.Changeset{}}

  """
  def delete_flok(%Flok{} = flok) do
    Repo.delete(flok)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking flok changes.

  ## Examples

      iex> change_flok(flok)
      %Ecto.Changeset{source: %Flok{}}

  """
  def change_flok(%Flok{} = flok) do
    Flok.changeset(flok, %{})
  end

  alias Tutorial.CMS.Creator

  @doc """
  Returns the list of creators.

  ## Examples

      iex> list_creators()
      [%Creator{}, ...]

  """
  def list_creators do
    Repo.all(Creator)
  end

  @doc """
  Gets a single creator.

  Raises `Ecto.NoResultsError` if the Creator does not exist.

  ## Examples

      iex> get_creator!(123)
      %Creator{}

      iex> get_creator!(456)
      ** (Ecto.NoResultsError)

  """
  def get_creator!(id), do: Creator |> Repo.get!(id) |> Repo.preload(:floks)

  @doc """
  Creates a creator.

  ## Examples

      iex> create_creator(%{field: value})
      {:ok, %Creator{}}

      iex> create_creator(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_creator(attrs \\ %{}) do
    %Creator{}
    |> Creator.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a creator.

  ## Examples

      iex> update_creator(creator, %{field: new_value})
      {:ok, %Creator{}}

      iex> update_creator(creator, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_creator(%Creator{} = creator, attrs) do
    creator
    |> Creator.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Creator.

  ## Examples

      iex> delete_creator(creator)
      {:ok, %Creator{}}

      iex> delete_creator(creator)
      {:error, %Ecto.Changeset{}}

  """
  def delete_creator(%Creator{} = creator) do
    Repo.delete(creator)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking creator changes.

  ## Examples

      iex> change_creator(creator)
      %Ecto.Changeset{source: %Creator{}}

  """
  def change_creator(%Creator{} = creator) do
    Creator.changeset(creator, %{})
  end

  def ensure_creator_exists(%User{} = user) do
    %Creator{user_id: user.id}
    |> change()
    |> unique_constraint(:user_id)
    |> Repo.insert()
    |> handle_existing_creator()
  end

  defp handle_existing_creator({:ok, creator}), do: creator

  defp handle_existing_creator({:error, changeset}) do
    Repo.get_by!(Creator, user_id: changeset.data.user_id)
  end
end
