
resource "aws_s3_bucket" "trackdirect_state" {
  bucket = "trackdirect-for-hetzner"
  # Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "trackdirect_enabled" {
  bucket = aws_s3_bucket.trackdirect_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "trackdirect_default" {
  bucket = aws_s3_bucket.trackdirect_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "trackdirect_public_access" {
  bucket                  = aws_s3_bucket.trackdirect_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "trackdirect_locks" {
  name         = "trackdirect-for-hetzner"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
