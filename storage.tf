resource "aws_s3_bucket" "html" {
  provider      = aws.central
  bucket        = "annas-twink-s3"
  force_destroy = true
  acl           = "private"

  lifecycle_rule {
    id      = "cleanup"
    enabled = true
    expiration {
      days = 7
    }

    noncurrent_version_expiration {
      days = 7
    }
  }

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

resource "aws_s3_bucket_object" "html" {
  provider = aws.central
  key      = "index.html"
  bucket   = aws_s3_bucket.html.id
  source   = "index.html"
  acl      = "private"
  etag     = filemd5("index.html")
}


# Bucket object read only
data "aws_iam_policy_document" "bucket" {
  provider = aws.central
  statement {
    effect  = "Allow"
    actions = ["s3:GetObject"]

    principals {
      type        = "AWS"
      identifiers = [aws_organizations_account.dev.id]
    }
    resources = ["${aws_s3_bucket.html.arn}/${aws_s3_bucket_object.html.key}"]
  }

}

resource "aws_s3_bucket_policy" "bucket" {
  provider = aws.central
  bucket   = aws_s3_bucket.html.id
  policy   = data.aws_iam_policy_document.bucket.json
}

