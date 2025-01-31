variable "app_name" {
  description = "Name of the app"
  type        = string
}

resource "aws_s3_bucket" "app_s3_bucket" {
  bucket = "products-${var.app_name}"

  tags = {
    Name = "App S3 Bucket"
  }
}

resource "aws_s3_bucket_versioning" "app_s3_bucket_versioning" {
  bucket = aws_s3_bucket.app_s3_bucket.id

  versioning_configuration {
    status = "Suspended"
  }
}

resource "aws_s3_bucket_public_access_block" "app_bucket_public_access_block" {
  
  bucket = aws_s3_bucket.app_s3_bucket.id
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "my_bucket_policy" {
  bucket = aws_s3_bucket.app_s3_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::098922872245:role/ecsTaskExecutionRole"
        }
        Action = "s3:GetObject"
        Resource = "arn:aws:s3:::${aws_s3_bucket.app_s3_bucket.bucket}/*.env"
      },
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::098922872245:role/ecsTaskExecutionRole"
        }
        Action = "s3:GetBucketLocation"
        Resource = aws_s3_bucket.app_s3_bucket.arn
      }
    ]
  })
}

resource "aws_s3_object" "app_env_file" {
  bucket       = aws_s3_bucket.app_s3_bucket.bucket
  key          = ".env"
  source       = "${path.module}/../../.env.prod"
  acl          = "private"
  content_type = "text/plain"
}

output "env_file" {
  value = "arn:aws:s3:::${aws_s3_bucket.app_s3_bucket.bucket}/.env"
  description = "ARN of the uploaded environment file"
}