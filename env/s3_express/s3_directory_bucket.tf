resource "aws_s3_directory_bucket" "example" {
  bucket = "example--apne1-az1--x-s3"
  type = "Directory"

  location {
    name = "apne1-az1"
    type = "AvailabilityZone"
  }
}
