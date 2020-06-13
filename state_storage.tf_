resource "aws_s3_bucket" "tf_state" {
  bucket = "annas-terraform-state"
  #allows to delete the bucket even if it contains files
  force_destroy = true

  #lifecycle {
  #  prevent_destroy = true
  #}

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}


resource "aws_dynamodb_table" "tf_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}