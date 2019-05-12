pid = ServerProcess.start(KeyValueStore)
ServerProcess.call(pid, {:put, :some_key, :some_value})
ServerProcess.call(pid, {:get, :some_key})
