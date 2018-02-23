job "hello-world-linux" {

  datacenters = ["dc1"]

  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }

  group "hello-world" {

    count = 1

    task "hello-world" {
      driver = "docker"

      config {
        image = "hello-world"
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