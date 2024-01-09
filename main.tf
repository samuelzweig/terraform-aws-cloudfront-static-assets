locals {
  comment = coalesce(var.comment, var.bucket)
}

data "aws_cloudfront_cache_policy" "selected" {
  name = var.cache_policy
}

module "s3_bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  version       = "3.15.1"
  bucket        = var.bucket
  attach_policy = true
  policy = jsonencode(
    {
      Id = "PolicyForCloudFrontPrivateContent"
      Statement = [
        {
          Action = "s3:GetObject"
          Condition = {
            StringEquals = {
              "AWS:SourceArn" = module.cdn.cloudfront_distribution_arn
            }
          }
          Effect = "Allow"
          Principal = {
            Service = "cloudfront.amazonaws.com"
          }
          Resource = "arn:aws:s3:::${var.bucket}/*"
          Sid      = "AllowCloudFrontServicePrincipal"
        },
      ]
      Version = "2012-10-17"
    }
  )
  server_side_encryption_configuration = var.server_side_encryption_configuration
  tags                                 = var.bucket_tags
}

module "cdn" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "3.2.1"

  aliases             = var.aliases
  comment             = local.comment
  default_root_object = var.default_root_object
  enabled             = var.enabled
  http_version        = var.http_version
  is_ipv6_enabled     = var.is_ipv6_enabled
  price_class         = var.price_class #"PriceClass_All"
  retain_on_delete    = var.retain_on_delete
  wait_for_deployment = var.wait_for_deployment
  web_acl_id          = var.web_acl_id
  tags                = var.cloudfront_tags

  logging_config = var.logging_config

  # only supporting 1 origin (the s3 bucket)
  # not supporting origin access identity since origin access control is generally recommended instead
  origin = {
    s3_bucket = {
      connection_attempts      = var.origin_connection_attempts
      connection_timeout       = var.origin_connection_timeout
      domain_name              = module.s3_bucket.s3_bucket_bucket_regional_domain_name
      origin_access_control_id = module.oac.cloudfront_origin_access_controls_ids[0]
      origin_id                = module.s3_bucket.s3_bucket_bucket_regional_domain_name
    }
  }

  default_cache_behavior = merge({
    allowed_methods = [
      "GET",
      "HEAD",
    ]
    cache_policy_id = data.aws_cloudfront_cache_policy.selected.id
    cached_methods = [
      "GET",
      "HEAD",
    ]
    compress               = true
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    smooth_streaming       = false
    target_origin_id       = module.s3_bucket.s3_bucket_bucket_regional_domain_name
    trusted_key_groups     = []
    trusted_signers        = []
    viewer_protocol_policy = "allow-all"
    use_forwarded_values   = false
    }, var.default_cache_behavior
  )
  # TODO add support for ordered_cache_behavior

  viewer_certificate = {
    acm_certificate_arn            = lookup(var.viewer_certificate, "acm_certificate_arn", null)
    cloudfront_default_certificate = lookup(var.viewer_certificate, "cloudfront_default_certificate", true)
    # overriding module default (TLSv1) here
    minimum_protocol_version = lookup(var.viewer_certificate, "minimum_protocol_version", "TLSv1.2_2021")
    iam_certificate_id       = lookup(var.viewer_certificate, "iam_certificate_id", null)
    ssl_support_method       = lookup(var.viewer_certificate, "ssl_support_method", null)
  }
  custom_error_response          = var.custom_error_response
  geo_restriction                = var.geo_restriction
  create_monitoring_subscription = var.create_monitoring_subscription
}

module "oac" {
  source                       = "terraform-aws-modules/cloudfront/aws"
  version                      = "3.2.1"
  create_distribution          = false
  create_origin_access_control = true
  retain_on_delete             = var.retain_on_delete
  origin_access_control = {
    "${var.bucket}" : {
      "description" : "",
      "origin_type" : "s3",
      "signing_behavior" : "always",
      "signing_protocol" : "sigv4"
    }
  }
  tags = var.cloudfront_tags
}

resource "aws_s3_object" "assets" {
  bucket   = module.s3_bucket.s3_bucket_id
  for_each = fileset("${path.root}/${var.content_directory}", "**")
  key      = each.value
  source   = "${path.root}/${var.content_directory}/${each.value}"
  etag     = filemd5("${path.root}/${var.content_directory}/${each.value}")
}

resource "aws_route53_record" "cdn_alias" {
  for_each = var.route53_zone_id == null ? [] : toset(var.aliases)
  zone_id  = var.route53_zone_id
  name     = each.key
  type     = "A"
  alias {
    name                   = module.cdn.cloudfront_distribution_domain_name
    zone_id                = module.cdn.cloudfront_distribution_hosted_zone_id
    evaluate_target_health = var.evaluate_target_health
  }
}

