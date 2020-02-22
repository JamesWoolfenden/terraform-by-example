resource "null_resource" "hello_world" {
  provisioner "local-exec" {
    # This is a comment
    command = "echo '${templatefile("${path.module}/template/hello.tmpl", { ip = module.ip.ip, user = var.user })}'"
  }
}
