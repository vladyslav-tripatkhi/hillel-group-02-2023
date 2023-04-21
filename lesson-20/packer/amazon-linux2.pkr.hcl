packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.2.4"
    }
  }
}

data "amazon-ami" "amazon-linux-2" {
  filters = {
    name                = "amzn2-ami-ecs-hvm-2.0.*-x86_64-ebs"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
    architecture        = var.architecture
  }

  most_recent = true
  owners      = ["amazon"]
}

source "amazon-ebs" "amazon-linux-2" {
  ami_name      = "packer-tutorial-awslinux-2-${local.timestamp}"
  instance_type = "t3.micro"
  region        = "us-east-1"

  source_ami = data.amazon-ami.amazon-linux-2.id

  ssh_username = "ec2-user"

  tags     = local.tags
  run_tags = local.tags
}

build {
  name = "packer-tutorial"
  sources = [
    "source.amazon-ebs.amazon-linux-2"
  ]

  provisioner "shell" {
    inline = [
      "sudo amazon-linux-extras install docker",
      "sudo systemctl enable docker",
      "sudo usermod -a -G docker ec2-user"
    ]
  }

  post-processor "manifest" {
    output     = var.manifest_file_name
    strip_path = true
  }
}
