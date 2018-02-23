job "hello-world" {

  datacenters = ["dc1"]

  group "hello-world" {

    count = 1

    task "hello-world" {
      driver = "docker"

      config {
        image = "docker/hello-world"
      }

      # Specify the maximum resources required to run the task,
      # include CPU, memory, and bandwidth.
      resources {
        cpu    = 500 # MHz
        memory = 128 # MB

        network {
          mbits = 100
        }
      }
    }
  }
}