resource "aws_route53_record" "jenkins_validation" {
  for_each = {
    for dvo in aws_acm_certificate.jenkins.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.this.zone_id
}

resource "aws_route53_record" "jenkins_alb" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = "jenkins"
  type    = "A"

  alias {
    name                   = module.jenkins_alb.dns_name
    zone_id                = module.jenkins_alb.zone_id
    evaluate_target_health = true
  }
}
