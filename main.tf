# Configure the AWS provider
provider "aws" {
  region = "us-east-1"  # You can change this to your desired region
} 


# Create an S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-bucket-name-12345"
  
 server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.my_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Create an EC2 instance
resource "aws_instance" "my_instance" {
  ami           = "ami-0c55b159cbfafe1f0"  # Example AMI ID for Amazon Linux 2 in us-east-1, change it based on your region
  instance_type = "t2.micro"
  key_name      = "my-key-pair"  # Ensure you have created a key pair in your AWS account for SSH access

  tags = {
    Name = "MyEC2Instance"
  }
}

# Outputs for reference
output "s3_bucket_name" {
  value = aws_s3_bucket.my_bucket.bucket
}

output "ec2_instance_id" {
  value = aws_instance.my_instance.id
}
