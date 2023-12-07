# terraform-aws-cloudfront-static-assets
Terraform module to deploy a CloudFront distribution with your static assets in an s3 bucket behind it.


## Usage

### Minimal Example
```hcl
module "example_static_assets" {
  source              = "./modules/terraform-aws-cloudfront-static-assets"
  bucket           = "example-static-assets"

  # if your static assets are in a directory called static_assets
  content_directory   = "static_assets"
}
```

## Notes
You might not want to use this module. 

This module can be useful if you want to quickly deploy some static assets to 
s3 behind a CloudFront CDN, and lock down the bucket so that the assets can only 
be accessed via your CloudFront distro. If you don't have an understandable 
aversion to checking assets into git, this module will allow you to manage your 
assets with terraform. This is generally a bad idea if the assets are very large 
or you have an extremely large number of assets. Maybe look into git LFS. For 
smaller, simpler deployments, the benefits of revision control might outweigh 
the downsides.

In many cases it would probably be better, albeit slightly more work, to just 
use the standard terraform-aws-s3-bucket And terraform-aws-cloudfront instead 
of this module, as this module is largely just a wrapper for those modules with 
some built-in config assumptions. 

## TODO 
- support origin groups
- ordered_cache_behavior
- add examples
- more testing

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cdn"></a> [cdn](#module\_cdn) | terraform-aws-modules/cloudfront/aws | 3.2.1 |
| <a name="module_oac"></a> [oac](#module\_oac) | terraform-aws-modules/cloudfront/aws | 3.2.1 |
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | terraform-aws-modules/s3-bucket/aws | 3.15.1 |

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.cdn_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_s3_object.assets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_cloudfront_cache_policy.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudfront_cache_policy) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aliases"></a> [aliases](#input\_aliases) | Extra CNAMEs (alternate domain names), if any, for this distribution. | `list(string)` | `null` | no |
| <a name="input_bucket"></a> [bucket](#input\_bucket) | (Optional, Forces new resource) The name of the bucket. If omitted, Terraform will assign a random, unique name. | `string` | `null` | no |
| <a name="input_bucket_tags"></a> [bucket\_tags](#input\_bucket\_tags) | (Optional) A mapping of tags to assign to the bucket. | `map(string)` | `{}` | no |
| <a name="input_cache_policy"></a> [cache\_policy](#input\_cache\_policy) | Cache policy to attach to your CloudFront distribution | `string` | `"Managed-CachingOptimized"` | no |
| <a name="input_cloudfront_tags"></a> [cloudfront\_tags](#input\_cloudfront\_tags) | A map of tags to assign to the cloudfront resources. | `map(string)` | `null` | no |
| <a name="input_comment"></a> [comment](#input\_comment) | Set if you want to use a custom comment for the CF distribution. | `string` | `null` | no |
| <a name="input_content_directory"></a> [content\_directory](#input\_content\_directory) | name of the directory you are keeping your static assets in | `string` | `null` | no |
| <a name="input_create_monitoring_subscription"></a> [create\_monitoring\_subscription](#input\_create\_monitoring\_subscription) | If enabled, the resource for monitoring subscription will created. | `bool` | `false` | no |
| <a name="input_custom_error_response"></a> [custom\_error\_response](#input\_custom\_error\_response) | One or more custom error response elements | `any` | `{}` | no |
| <a name="input_default_cache_behavior"></a> [default\_cache\_behavior](#input\_default\_cache\_behavior) | The default cache behavior for this distribution | `any` | `null` | no |
| <a name="input_default_root_object"></a> [default\_root\_object](#input\_default\_root\_object) | The object that you want CloudFront to return when an end user requests the root URL. | `string` | `null` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Whether the distribution is enabled to accept end user requests for content. | `bool` | `true` | no |
| <a name="input_evaluate_target_health"></a> [evaluate\_target\_health](#input\_evaluate\_target\_health) | Set to true if you want Route 53 to determine whether to respond to DNS queries using this resource record set by checking the health of the resource record set. | `bool` | `false` | no |
| <a name="input_geo_restriction"></a> [geo\_restriction](#input\_geo\_restriction) | The restriction configuration for this distribution (geo\_restrictions) | `any` | `{}` | no |
| <a name="input_http_version"></a> [http\_version](#input\_http\_version) | The maximum HTTP version to support on the distribution. Allowed values are http1.1, http2, http2and3, and http3. The default is http2. | `string` | `"http2"` | no |
| <a name="input_is_ipv6_enabled"></a> [is\_ipv6\_enabled](#input\_is\_ipv6\_enabled) | Whether the IPv6 is enabled for the distribution. | `bool` | `null` | no |
| <a name="input_logging_config"></a> [logging\_config](#input\_logging\_config) | The logging configuration that controls how logs are written to your distribution (maximum one). | `any` | `{}` | no |
| <a name="input_origin_connection_attempts"></a> [origin\_connection\_attempts](#input\_origin\_connection\_attempts) | The amount of attempts CF should make to connect to the s3 origin before giving up. | `number` | `3` | no |
| <a name="input_origin_connection_timeout"></a> [origin\_connection\_timeout](#input\_origin\_connection\_timeout) | How long CF should wait for a response to a request to the s3 origin before giving up | `number` | `10` | no |
| <a name="input_price_class"></a> [price\_class](#input\_price\_class) | The price class for this distribution. One of PriceClass\_All, PriceClass\_200, PriceClass\_100 | `string` | `null` | no |
| <a name="input_retain_on_delete"></a> [retain\_on\_delete](#input\_retain\_on\_delete) | Disables the CF distribution instead of deleting it when destroying the resource through Terraform. If this is set, the distribution needs to be deleted manually afterwards. | `bool` | `false` | no |
| <a name="input_route53_zone_id"></a> [route53\_zone\_id](#input\_route53\_zone\_id) | Route53 zone where alias record should be create. If not set no records will be created. | `string` | `null` | no |
| <a name="input_server_side_encryption_configuration"></a> [server\_side\_encryption\_configuration](#input\_server\_side\_encryption\_configuration) | Map containing server-side encryption configuration. | `any` | `{}` | no |
| <a name="input_viewer_certificate"></a> [viewer\_certificate](#input\_viewer\_certificate) | The SSL configuration for this distribution | `any` | <pre>{<br>  "cloudfront_default_certificate": true,<br>  "minimum_protocol_version": "TLSv1.2_2021"<br>}</pre> | no |
| <a name="input_wait_for_deployment"></a> [wait\_for\_deployment](#input\_wait\_for\_deployment) | If enabled, the resource will wait for the distribution status to change from InProgress to Deployed. Setting this to false will skip the process. | `bool` | `true` | no |
| <a name="input_web_acl_id"></a> [web\_acl\_id](#input\_web\_acl\_id) | If you're using AWS WAF to filter CloudFront requests, the Id of the AWS WAF web ACL that is associated with the distribution. The WAF Web ACL must exist in the WAF Global (CloudFront) region and the credentials configuring this argument must have waf:GetWebACL permissions assigned. If using WAFv2, provide the ARN of the web ACL. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudfront_distribution_arn"></a> [cloudfront\_distribution\_arn](#output\_cloudfront\_distribution\_arn) | The ARN (Amazon Resource Name) for the distribution. |
| <a name="output_cloudfront_distribution_caller_reference"></a> [cloudfront\_distribution\_caller\_reference](#output\_cloudfront\_distribution\_caller\_reference) | Internal value used by CloudFront to allow future updates to the distribution configuration. |
| <a name="output_cloudfront_distribution_domain_name"></a> [cloudfront\_distribution\_domain\_name](#output\_cloudfront\_distribution\_domain\_name) | The domain name corresponding to the distribution. |
| <a name="output_cloudfront_distribution_etag"></a> [cloudfront\_distribution\_etag](#output\_cloudfront\_distribution\_etag) | The current version of the distribution's information. |
| <a name="output_cloudfront_distribution_hosted_zone_id"></a> [cloudfront\_distribution\_hosted\_zone\_id](#output\_cloudfront\_distribution\_hosted\_zone\_id) | The CloudFront Route 53 zone ID that can be used to route an Alias Resource Record Set to. |
| <a name="output_cloudfront_distribution_id"></a> [cloudfront\_distribution\_id](#output\_cloudfront\_distribution\_id) | The identifier for the distribution. |
| <a name="output_cloudfront_distribution_in_progress_validation_batches"></a> [cloudfront\_distribution\_in\_progress\_validation\_batches](#output\_cloudfront\_distribution\_in\_progress\_validation\_batches) | The number of invalidation batches currently in progress. |
| <a name="output_cloudfront_distribution_last_modified_time"></a> [cloudfront\_distribution\_last\_modified\_time](#output\_cloudfront\_distribution\_last\_modified\_time) | The date and time the distribution was last modified. |
| <a name="output_cloudfront_distribution_status"></a> [cloudfront\_distribution\_status](#output\_cloudfront\_distribution\_status) | The current status of the distribution. Deployed if the distribution's information is fully propagated throughout the Amazon CloudFront system. |
| <a name="output_cloudfront_distribution_tags"></a> [cloudfront\_distribution\_tags](#output\_cloudfront\_distribution\_tags) | Tags of the distribution's |
| <a name="output_cloudfront_distribution_trusted_signers"></a> [cloudfront\_distribution\_trusted\_signers](#output\_cloudfront\_distribution\_trusted\_signers) | List of nested attributes for active trusted signers, if the distribution is set up to serve private content with signed URLs |
| <a name="output_cloudfront_monitoring_subscription_id"></a> [cloudfront\_monitoring\_subscription\_id](#output\_cloudfront\_monitoring\_subscription\_id) | The ID of the CloudFront monitoring subscription, which corresponds to the `distribution_id`. |
| <a name="output_cloudfront_origin_access_controls"></a> [cloudfront\_origin\_access\_controls](#output\_cloudfront\_origin\_access\_controls) | The origin access controls created |
| <a name="output_cloudfront_origin_access_controls_ids"></a> [cloudfront\_origin\_access\_controls\_ids](#output\_cloudfront\_origin\_access\_controls\_ids) | The IDS of the origin access identities created |
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | The ARN of the bucket. Will be of format arn:aws:s3:::bucketname. |
| <a name="output_s3_bucket_bucket_domain_name"></a> [s3\_bucket\_bucket\_domain\_name](#output\_s3\_bucket\_bucket\_domain\_name) | The bucket domain name. Will be of format bucketname.s3.amazonaws.com. |
| <a name="output_s3_bucket_bucket_regional_domain_name"></a> [s3\_bucket\_bucket\_regional\_domain\_name](#output\_s3\_bucket\_bucket\_regional\_domain\_name) | The bucket region-specific domain name. The bucket domain name including the region name, please refer here for format. Note: The AWS CloudFront allows specifying S3 region-specific endpoint when creating S3 origin, it will prevent redirect issues from CloudFront to S3 Origin URL. |
| <a name="output_s3_bucket_hosted_zone_id"></a> [s3\_bucket\_hosted\_zone\_id](#output\_s3\_bucket\_hosted\_zone\_id) | The Route 53 Hosted Zone ID for this bucket's region. |
| <a name="output_s3_bucket_id"></a> [s3\_bucket\_id](#output\_s3\_bucket\_id) | The name of the bucket. |
| <a name="output_s3_bucket_lifecycle_configuration_rules"></a> [s3\_bucket\_lifecycle\_configuration\_rules](#output\_s3\_bucket\_lifecycle\_configuration\_rules) | The lifecycle rules of the bucket, if the bucket is configured with lifecycle rules. If not, this will be an empty string. |
| <a name="output_s3_bucket_policy"></a> [s3\_bucket\_policy](#output\_s3\_bucket\_policy) | The policy of the bucket, if the bucket is configured with a policy. If not, this will be an empty string. |
| <a name="output_s3_bucket_region"></a> [s3\_bucket\_region](#output\_s3\_bucket\_region) | The AWS region this bucket resides in. |
| <a name="output_s3_bucket_website_domain"></a> [s3\_bucket\_website\_domain](#output\_s3\_bucket\_website\_domain) | The domain of the website endpoint, if the bucket is configured with a website. If not, this will be an empty string. This is used to create Route 53 alias records. |
| <a name="output_s3_bucket_website_endpoint"></a> [s3\_bucket\_website\_endpoint](#output\_s3\_bucket\_website\_endpoint) | The website endpoint, if the bucket is configured with a website. If not, this will be an empty string. |
<!-- END_TF_DOCS -->