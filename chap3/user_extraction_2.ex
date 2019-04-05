defmodule UserExtraction2 do
  def user do
    %{
      login: "meowcat",
      email: "meow@example.com",
      password: "1234"
    }
  end

  def extract_user(user) do
    case Enum.filter(
            [:login, :email, :password],
            &(not Map.has_key?(user, &1))
          ) do
      [] -> 
        IO.puts("Wow y wow they're all there")
      missing_fields ->
        IO.puts("oh no, no: #{inspect(missing_fields)}!")
    end
  end
end
