resource "aws_iam_role" "aws_config_role" {
  name = "aws_config_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "config.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "aws_config_role_policy" {
  name = "aws_config_policy"
  role = aws_iam_role.aws_config_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "s3:PutObject",
        "s3:GetBucketAcl",
        "s3:GetBucketLocation",
        "sns:Publish"
      ],
      Resource = "*"
    }]
  })
}

resource "aws_s3_bucket" "config_bucket" {
  bucket = "my-config-logs-opa-policy123"
}


resource "aws_config_configuration_recorder" "config" {
  name     = "config"
  role_arn = aws_iam_role.aws_config_role.arn
}

resource "aws_config_delivery_channel" "config" {
  name           = "config-channel"
  s3_bucket_name = aws_s3_bucket.config_bucket.bucket

  depends_on = [aws_config_configuration_recorder.config]
}

resource "aws_config_configuration_recorder_status" "config" {
  name    = aws_config_configuration_recorder.config.name
  is_enabled = true
}
# Configure the AWS provider
provider "aws" {
  region = "us-east-1"  # You can change this to your desired region
} 



