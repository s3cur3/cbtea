defmodule Cbt.SeedHelpers do
  def apply_seeds do
    [__DIR__, "../../priv/repo/seeds.exs"]
    |> Path.join()
    |> Code.eval_file()

    %Cbt.Accounts.User{} = Cbt.Accounts.get_user_by_email("tyler@tylerayoung.com")
    [_ | _] = Cbt.Distortions.all_distortions()
  end
end
