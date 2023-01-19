terraform {
  source = "./"
}
remote_state {
  backend = "s3"
  config = {
    bucket = "naruse-tf-backend" 
    key    = "aws-labo/backend.tfstate"
    region = "ap-northeast-1"
    dynamodb_table = "naruse-tf-backend"
  }
}