resource "aws_acm_certificate" "jenkins" {
  domain_name               = local.jenkins_domain_name
  subject_alternative_names = ["*.${local.domain_name}"]

  validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "jenkins" {
  certificate_arn         = aws_acm_certificate.jenkins.arn
  validation_record_fqdns = [for record in aws_route53_record.jenkins_validation : record.fqdn]
}