resource "aws_s3_bucket" "example" {
  bucket = "d010642-tf-state-bucket"

  tags = {
    Name        = "d010642-tf-state-bucket"
    Project = "DevOps"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}