provider "aws" {
  default_tags {
    tags = {
      Hillel    = "Lesson 26"
      Terraform = true
    }
  }
}

provider "aws" {
  alias = "us-west-2"

  region = "us-west-2"
  default_tags {
    tags = {
      Hillel    = "Lesson 26"
      Terraform = true
    }
  }
}

provider "external" {}
