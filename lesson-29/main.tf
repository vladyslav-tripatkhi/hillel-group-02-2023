resource "aws_lb" "this" {
  name               = "lesson-29-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.this.id]
  subnets         = data.aws_subnets.this.ids
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_listener_rule" "http_health" {
  listener_arn = aws_lb_listener.http.arn

  condition {
    path_pattern {
      values = ["/health", "/check"]
    }
  }

  action {
    type = "fixed-response"
    fixed_response {
      content_type = "application/json"
      message_body = jsonencode({ status = "ok" })
      status_code  = "200"
    }
  }
}

resource "aws_lb_target_group" "this" {
  name     = "hillel-lesson-29-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.this.id

  deregistration_delay = 30

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 10
    timeout             = 5

    matcher = "200"
  }
}

