defmodule Tutorial.CMSTest do
  use Tutorial.DataCase

  alias Tutorial.CMS

  describe "floks" do
    alias Tutorial.CMS.Flok

    @valid_attrs %{description: "some description", published: "some published", sport: "some sport", title: "some title"}
    @update_attrs %{description: "some updated description", published: "some updated published", sport: "some updated sport", title: "some updated title"}
    @invalid_attrs %{description: nil, published: nil, sport: nil, title: nil}

    def flok_fixture(attrs \\ %{}) do
      {:ok, flok} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CMS.create_flok()

      flok
    end

    test "list_floks/0 returns all floks" do
      flok = flok_fixture()
      assert CMS.list_floks() == [flok]
    end

    test "get_flok!/1 returns the flok with given id" do
      flok = flok_fixture()
      assert CMS.get_flok!(flok.id) == flok
    end

    test "create_flok/1 with valid data creates a flok" do
      assert {:ok, %Flok{} = flok} = CMS.create_flok(@valid_attrs)
      assert flok.description == "some description"
      assert flok.published == "some published"
      assert flok.sport == "some sport"
      assert flok.title == "some title"
    end

    test "create_flok/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CMS.create_flok(@invalid_attrs)
    end

    test "update_flok/2 with valid data updates the flok" do
      flok = flok_fixture()
      assert {:ok, flok} = CMS.update_flok(flok, @update_attrs)
      assert %Flok{} = flok
      assert flok.description == "some updated description"
      assert flok.published == "some updated published"
      assert flok.sport == "some updated sport"
      assert flok.title == "some updated title"
    end

    test "update_flok/2 with invalid data returns error changeset" do
      flok = flok_fixture()
      assert {:error, %Ecto.Changeset{}} = CMS.update_flok(flok, @invalid_attrs)
      assert flok == CMS.get_flok!(flok.id)
    end

    test "delete_flok/1 deletes the flok" do
      flok = flok_fixture()
      assert {:ok, %Flok{}} = CMS.delete_flok(flok)
      assert_raise Ecto.NoResultsError, fn -> CMS.get_flok!(flok.id) end
    end

    test "change_flok/1 returns a flok changeset" do
      flok = flok_fixture()
      assert %Ecto.Changeset{} = CMS.change_flok(flok)
    end
  end

  describe "creators" do
    alias Tutorial.CMS.Creator

    @valid_attrs %{bio: "some bio", favorite_sport: "some favorite_sport", role: "some role"}
    @update_attrs %{bio: "some updated bio", favorite_sport: "some updated favorite_sport", role: "some updated role"}
    @invalid_attrs %{bio: nil, favorite_sport: nil, role: nil}

    def creator_fixture(attrs \\ %{}) do
      {:ok, creator} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CMS.create_creator()

      creator
    end

    test "list_creators/0 returns all creators" do
      creator = creator_fixture()
      assert CMS.list_creators() == [creator]
    end

    test "get_creator!/1 returns the creator with given id" do
      creator = creator_fixture()
      assert CMS.get_creator!(creator.id) == creator
    end

    test "create_creator/1 with valid data creates a creator" do
      assert {:ok, %Creator{} = creator} = CMS.create_creator(@valid_attrs)
      assert creator.bio == "some bio"
      assert creator.favorite_sport == "some favorite_sport"
      assert creator.role == "some role"
    end

    test "create_creator/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CMS.create_creator(@invalid_attrs)
    end

    test "update_creator/2 with valid data updates the creator" do
      creator = creator_fixture()
      assert {:ok, creator} = CMS.update_creator(creator, @update_attrs)
      assert %Creator{} = creator
      assert creator.bio == "some updated bio"
      assert creator.favorite_sport == "some updated favorite_sport"
      assert creator.role == "some updated role"
    end

    test "update_creator/2 with invalid data returns error changeset" do
      creator = creator_fixture()
      assert {:error, %Ecto.Changeset{}} = CMS.update_creator(creator, @invalid_attrs)
      assert creator == CMS.get_creator!(creator.id)
    end

    test "delete_creator/1 deletes the creator" do
      creator = creator_fixture()
      assert {:ok, %Creator{}} = CMS.delete_creator(creator)
      assert_raise Ecto.NoResultsError, fn -> CMS.get_creator!(creator.id) end
    end

    test "change_creator/1 returns a creator changeset" do
      creator = creator_fixture()
      assert %Ecto.Changeset{} = CMS.change_creator(creator)
    end
  end
end
