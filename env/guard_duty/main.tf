data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_guardduty_detector" "detector" {
  enable = true

  datasources {
    s3_logs {
      enable = true
    }
    kubernetes {
      audit_logs {
        enable = false
      }
    }
    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          enable = true
        }
      }
    }
  }
}

resource "aws_guardduty_publishing_destination" "detector" {
  detector_id     = aws_guardduty_detector.detector.id
  destination_arn = aws_s3_bucket.gd_bucket.arn
  kms_key_arn     = aws_kms_key.gd_key.arn

  depends_on = [
    aws_s3_bucket_policy.gd_bucket_policy,
  ]
}