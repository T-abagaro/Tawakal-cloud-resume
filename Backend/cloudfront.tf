resource "aws_cloudfront_origin_access_control" "origin" {
  name                              = "origin"
  description                       = "origin_access_to_S3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
  
}

locals {
  s3_origin_id = "iacresume"
}



resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.iacresume.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.origin.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = false
  default_root_object = "resume.html"
  aliases = ["tawakalresume.com"]
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

 

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      
    }
  }
 
 viewer_certificate {
    acm_certificate_arn = "arn:aws:acm:us-east-1:538012638601:certificate/ca829094-cb44-4f98-9eca-ab90c1f15c1d"
    ssl_support_method  = "sni-only"
     minimum_protocol_version = "TLSv1.2_2021"
  }
 
 
}



