terraform {
  required_version = ">= 0.12.26"
}





resource "null_resource" "example" {
  count = 1
  provisioner "local-exec" {
    command = "echo \"Hello, World from $(uname -smp)\""
  }
  triggers = {
    uuid = uuid()
  }

}

data "external" "echo" {
  program = ["bash", "-c", "cat /dev/stdin"]
  query = {
    foo = "bar"
  }
}
output "echo" {
  value = data.external.echo.result
}
output "echo_foo" {
  value = data.external.echo.result.foo
}