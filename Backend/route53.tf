resource "aws_route53_zone" "example_zone" {
  name = "tawaklresumetest.com"
}

resource "aws_route53_record" "cloudfront_distro" {
  zone_id = aws_route53_zone.example_zone.zone_id
  name    = "example.com"
  type    = "A"
  alias {
  name    = aws_cloudfront_distribution.s3_distribution.domain_name
  zone_id = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
  evaluate_target_health = false
  }

}

resource "aws_route53_record" "example_cname_record" {
  zone_id = aws_route53_zone.example_zone.zone_id
  name    = "_2f87939d4ccbb49caed14092baf488db.tawakalresume.com"
  type    = "CNAME"
  ttl     = "300"
  records = ["_713e994a3ca3132a3f74eaf474a052f9.lqynnrqbbf.acm-validations.aws."]
}

resource "aws_route53_record" "example_ns_record" {
  zone_id = aws_route53_zone.example_zone.zone_id
  allow_overwrite = true
  name    = "tawakalresumetest.com"
  type    = "NS"
  ttl     = "300"
  records = ["ns-1840.awsdns-38.co.uk", "ns-391.awsdns-48.com", "ns-1101.awsdns-09.org", "ns-901.awsdns-48.net"]
}



