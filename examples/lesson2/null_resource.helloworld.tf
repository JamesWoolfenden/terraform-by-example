resource "null_resource" "hello_world" {
  provisioner "local-exec" {
    # This is a comment
    command = "echo 'hello world from ${var.user}'"
  }
}