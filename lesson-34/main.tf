terraform {
  backend "s3" {
    bucket = "hillel-devops-terraform-state"
    key    = "lesson34/my.tfstate"
    region = "us-east-1"

    dynamodb_table = "hillel-terraform-lock"
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Project = "Hillel"
      Lesson  = 34
    }
  }
}

locals {
  domain_name         = "go-fish.pp.ua"
  jenkins_domain_name = "jenkins.${local.domain_name}"
}

module "jenkins_alb" {
  source = "./modules/alb"

  name                = "jenkins"
  vpc_id              = data.aws_vpc.this.id
  subnet_ids          = data.aws_subnets.this.ids
  security_group_id   = aws_security_group.jenkins_alb.id
  acm_certificate_arn = aws_acm_certificate.jenkins.arn
}

module "jenkins_instance" {
  source = "../lesson-26/modules/instance"

  name              = "jenkins_instance"
  type              = "t3.medium"
  key_name          = "hillel-gr"
  port              = 8080
  security_group_id = aws_security_group.jenkins_instance.id
  user_data         = <<EOF
#!/usr/bin/env bash
yum install -y docker git
usermod -aG docker ec2-user
systemctl enable docker
systemctl start docker
curl -L https://github.com/docker/compose/releases/download/1.20.0/docker-compose-`uname -s`-`uname -m` -o /usr/bin/docker-compose
chmod +x /usr/bin/docker-compose
git clone https://github.com/vladyslav-tripatkhi/hillel-group-02-2023 /home/ec2-user/hillel
chown -R ec2-user:ec2-user /home/ec2-user/hillel
cd /home/ec2-user/hillel/lesson-30 && docker-compose config && docker-compose up -d

EOF
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = module.jenkins_alb.tg.arn
  target_id        = module.jenkins_instance.ids[0]
  port             = 8080
}
