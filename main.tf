# main.tf

provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "autoprovisioned" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name

  tags = {
    Name = "Demo Server"
  }
}

