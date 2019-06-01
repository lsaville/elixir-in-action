Supervisor.start_link([Todo.Cache], strategy: :one_for_one)
bobs_list = Todo.Cache.server_process("Bob's list")
cache_pid = Process.whereis(Todo.Cache)
Process.exit(cache_pid, :kill)
Process.whereis(Todo.Cache)

Supervisor.start_link(
  [
    %{
      id: Todo.Cache,
      start: {Todo.Cache, :start_link, [nil]}
    }
  ],
  strategy: :one_for_one
)

Supervisor.start_link(
  [{Todo.Cache, nil}],
  strategy: :one_for_one
)

Supervisor.start_link([Todo.Cache], strategy: :one_for_one)
# ^^^ 7-22 are various permutations of the same thing

Todo.Cache.child_spec(nil)
# This should give back
# %{id: Todo.Cache, start: {Todo.Cache, :start_link, [nil]}}

Todo.System.start_link()
bobs_list = Todo.Cache.server_process("Bob's list")
:erlang.system_info(:process_count)
Process.exit(Process.whereis(Todo.Cache), :kill)
Todo.Cache.server_process("Bob's list")
:erlang.system_info(:process_count)


for _ <- 1..4 do
  Process.exit(Process.whereis(Todo.Cache), :kill)
  Process.sleep(200)
end
