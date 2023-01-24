resource "aws_wafv2_web_acl" "waf" {
  name  = "waf-rule"
  scope = "REGIONAL"
  default_action {
    allow {}
  }
  rule {
    name     = "managed_rule"
    priority = 1
    override_action {
      count {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"

        # 指定のルールのアクションをoverrideできる
        rule_action_override {
          action_to_use {
            count {}
          }
          name = "NoUserAgent_HEADER"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "managed-waf-rule-metric"
      sampled_requests_enabled   = false
    }
  }

  tags = {
    "associated" = "alb"
  }
  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "managed-waf-metric"
    sampled_requests_enabled   = false
  }
}

resource "aws_wafv2_web_acl_association" "waf" {
  web_acl_arn  = aws_wafv2_web_acl.waf.arn
  resource_arn = module.alb.arn
}

resource "aws_wafv2_web_acl_logging_configuration" "waf" {
  log_destination_configs = [aws_kinesis_firehose_delivery_stream.log.arn]
  resource_arn            = aws_wafv2_web_acl.waf.arn
}