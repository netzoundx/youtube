resource "local_file" "test-local" {
  filename = "C:/Users/netzoundx/Desktop/Terraform/local/local-test.txt"
  content = var.content
}

