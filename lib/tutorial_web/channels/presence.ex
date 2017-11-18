defmodule TutorialWeb.Presence do
  use Phoenix.Presence,
    otp_app: :tutorial,
    pubsub_server: Tutorial.PubSub

  alias TutorialWeb.Presence

  def track_user_join(socket, user) do
    Presence.track(socket, user.id, %{
      online_at: inspect(System.system_time(:seconds)),
      typing: false,
      first_name: user.username,
      user_id: user.id
    })
  end

  def do_user_update(socket, user, %{typing: typing}) do
    Presence.update(socket, user.id, %{
      typing: typing,
      first_name: user.username,
      user_id: user.id
    })
  end

end
