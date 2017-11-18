defmodule TutorialWeb.HelloChannel do
  use TutorialWeb, :channel

  alias TutorialWeb.Presence

  def join("hello:person", payload, socket) do
    IO.inspect(payload)

    if authorized?(payload) do
      send(self(), :after_join)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def join("hello:" <> _private_topic_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  # Channels can be used in a request/response fashion
  def handle_in("new_msg", %{"body" => body}, socket) do
    user = current_user(socket)
    broadcast!(socket, "new_msg", %{body: body, user: user.username})
    {:noreply, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (hello:lobby).

  def handle_info(:after_join, socket) do
    push(socket, "presence_state", Presence.list(socket))
    Presence.track_user_join(socket, current_user(socket))
    # Monitor.get_challenge_state(challenge.id)
    broadcast!(socket, "user:joined", %{})
    {:noreply, socket}
  end

  # intercept(["user_joined"])

  # def handle_out("user_joined", msg, socket) do
  #   if Accounts.ignoring_user?(socket.assigns[:user], msg.user_id) do
  #     {:noreply, socket}
  #   else
  #     push(socket, "user_joined", msg)
  #     {:noreply, socket}
  #   end
  # end
  defp current_user(socket) do
    socket.assigns[:current_user]
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
