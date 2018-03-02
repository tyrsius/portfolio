resource "aws_route53_record" "website" {
  name    = "${local.tyrsius_apex}"
  zone_id = "${local.bucket_zone_id}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.website.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.website.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "web_aliases" {
  name    = "${local.tyrsius_alias}"
  zone_id = "${local.tyrsius_hosted_zone_id}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.website.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.website.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "website_kye" {
  name    = "${local.kye_apex}"
  zone_id = "${local.kye_hosted_zone_id}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.website.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.website.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "web_kye_aliases" {
  name    = "${local.kye_alias}"
  zone_id = "${local.kye_hosted_zone_id}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.website.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.website.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_s3_bucket" "website" {
  bucket = "${local.bucket_domain}"
  acl    = "public-read"

  policy = <<EOF
{
      "Id": "bucket_policy_site",
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "bucket_policy_site_main",
          "Action": [
            "s3:GetObject"
          ],
          "Effect": "Allow",
          "Resource": "arn:aws:s3:::${local.bucket_domain}/*",
          "Principal": "*"
        }
      ]
    }
EOF

  acl = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_cloudfront_distribution" "website" {
  enabled         = true
  is_ipv6_enabled = true
  price_class     = "PriceClass_100"

  # http_version = "http2"

  "origin" {
    origin_id   = "origin-bucket-${aws_s3_bucket.website.id}"
    domain_name = "${local.bucket_domain}.s3.amazonaws.com"

    custom_origin_config {
      origin_protocol_policy = "http-only"
      http_port              = "80"
      https_port             = "443"
      origin_ssl_protocols   = ["SSLv3", "TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }
  default_root_object = "index.html"
  custom_error_response {
    error_code         = "404"
    response_code      = "200"
    response_page_path = "/index.html"
  }
  "default_cache_behavior" {
    allowed_methods = ["GET", "HEAD", "DELETE", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD"]

    "forwarded_values" {
      query_string = "true"

      cookies {
        forward = "none"
      }
    }

    min_ttl          = "0"
    default_ttl      = "300"
    max_ttl          = "1200"
    target_origin_id = "origin-bucket-${aws_s3_bucket.website.id}"

    viewer_protocol_policy = "redirect-to-https"
    compress               = true
  }
  "restrictions" {
    "geo_restriction" {
      restriction_type = "none"
    }
  }
  "viewer_certificate" {
    acm_certificate_arn      = "${var.website_certifcate_arn}"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"
  }
  aliases = ["${local.cloufront__domains}"]
}
