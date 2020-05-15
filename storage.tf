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


resource "aws_s3_bucket_policy" "policy" {
  provider = aws.central
  bucket   = aws_s3_bucket.html.id
  policy   = <<POLICY
{
  "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "${aws_organizations_account.dev.id}"
            },
            "Action": [
                "s3:GetObject"
            ],
            "Resource": "${aws_s3_bucket.html.arn}/${aws_s3_bucket_object.html.key}"
        }
    ]
}
POLICY
}

