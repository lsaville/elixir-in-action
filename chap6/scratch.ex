pid = ServerProcess.start(KeyValueStore)
ServerProcess.call(pid, {:put, :some_key, :some_value})
ServerProcess.call(pid, {:get, :some_key})

pid = KeyValueStore.start()
KeyValueStore.put(pid, :some_key, :some_value)
KeyValueStore.get(pid, :some_key)

pid = Todo
