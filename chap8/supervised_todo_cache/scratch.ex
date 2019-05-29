Supervisor.start_link([Todo.Cache], strategy: :one_for_one)
