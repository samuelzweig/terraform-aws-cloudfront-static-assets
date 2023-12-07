variable "aliases" {
  description = "Extra CNAMEs (alternate domain names), if any, for this distribution."
  type        = list(string)
  default     = null
}

variable "bucket" {
  description = "(Optional, Forces new resource) The name of the bucket. If omitted, Terraform will assign a random, unique name."
  type        = string
  default     = null
}

variable "bucket_tags" {
  description = "(Optional) A mapping of tags to assign to the bucket."
  type        = map(string)
  default     = {}
}

variable "cache_policy" {
  description = "Cache policy to attach to your CloudFront distribution"
  default     = "Managed-CachingOptimized"
}

variable "cloudfront_tags" {
  description = "A map of tags to assign to the cloudfront resources."
  type        = map(string)
  default     = null
}

variable "comment" {
  description = "Set if you want to use a custom comment for the CF distribution."
  type        = string
  default     = null
}

variable "content_directory" {
  description = "name of the directory you are keeping your static assets in"
  type        = string
  default     = null
}

variable "create_monitoring_subscription" {
  description = "If enabled, the resource for monitoring subscription will created."
  type        = bool
  default     = false
}

variable "custom_error_response" {
  description = "One or more custom error response elements"
  type        = any
  default     = {}
}

variable "default_cache_behavior" {
  description = "The default cache behavior for this distribution"
  type        = any
  default     = null
}

variable "default_root_object" {
  description = "The object that you want CloudFront to return when an end user requests the root URL."
  type        = string
  default     = null
}

variable "enabled" {
  description = "Whether the distribution is enabled to accept end user requests for content."
  type        = bool
  default     = true
}

variable "evaluate_target_health" {
  description = "Set to true if you want Route 53 to determine whether to respond to DNS queries using this resource record set by checking the health of the resource record set."
  default     = false
}

variable "geo_restriction" {
  description = "The restriction configuration for this distribution (geo_restrictions)"
  type        = any
  default     = {}
}

variable "http_version" {
  description = "The maximum HTTP version to support on the distribution. Allowed values are http1.1, http2, http2and3, and http3. The default is http2."
  default     = "http2"
}

variable "is_ipv6_enabled" {
  description = "Whether the IPv6 is enabled for the distribution."
  type        = bool
  default     = null
}

variable "logging_config" {
  description = "The logging configuration that controls how logs are written to your distribution (maximum one)."
  type        = any
  default     = {}
}

variable "origin_connection_attempts" {
  description = "The amount of attempts CF should make to connect to the s3 origin before giving up."
  default     = 3
}

variable "origin_connection_timeout" {
  description = "How long CF should wait for a response to a request to the s3 origin before giving up"
  default     = 10
}

variable "price_class" {
  description = "The price class for this distribution. One of PriceClass_All, PriceClass_200, PriceClass_100"
  type        = string
  default     = null
}

variable "retain_on_delete" {
  description = "Disables the CF distribution instead of deleting it when destroying the resource through Terraform. If this is set, the distribution needs to be deleted manually afterwards."
  type        = bool
  default     = false
}

variable "route53_zone_id" {
  description = "Route53 zone where alias record should be create. If not set no records will be created."
  type        = string
  default     = null
}

variable "server_side_encryption_configuration" {
  description = "Map containing server-side encryption configuration."
  type        = any
  default     = {}
}

variable "wait_for_deployment" {
  description = "If enabled, the resource will wait for the distribution status to change from InProgress to Deployed. Setting this to false will skip the process."
  default     = true
}

variable "web_acl_id" {
  description = "If you're using AWS WAF to filter CloudFront requests, the Id of the AWS WAF web ACL that is associated with the distribution. The WAF Web ACL must exist in the WAF Global (CloudFront) region and the credentials configuring this argument must have waf:GetWebACL permissions assigned. If using WAFv2, provide the ARN of the web ACL."
  type        = string
  default     = null
}

variable "viewer_certificate" {
  description = "The SSL configuration for this distribution"
  type        = any
  default = {
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1.2_2021"
  }
}

