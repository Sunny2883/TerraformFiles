resource "aws_key_pair" "key-" {
  key_name = "new_key_project"
  public_key = file("${path.module}/id_rsa.pub")
}