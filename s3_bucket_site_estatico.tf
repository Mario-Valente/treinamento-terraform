resource "aws_s3_bucket" "site" {
  bucket = "s3-website-teste.aloha"

}

resource "aws_s3_bucket_website_configuration" "site" {
  bucket = aws_s3_bucket.site.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }

  routing_rule {
    condition {
      key_prefix_equals = "docs/"
    }
    redirect {
      replace_key_prefix_with = "documents/"
    }
  }
}

resource "aws_s3_bucket_policy" "site" {
  bucket = aws_s3_bucket.site.id
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:ListBucket",
        Resource  = aws_s3_bucket.site.arn
      },
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.site.arn}/*"
      }
    ]
  })
}

#############  IAM ######################

resource "aws_iam_user" "service_s3_bucket_access" {
  name = lower("${var.aws_iam_user}_s3_bucket_write_access")

  path = "/system/"
}

resource "aws_iam_access_key" "service_s3_bucket_access" {
  user = aws_iam_user.service_s3_bucket_access.name
}


resource "aws_iam_user_policy" "service_s3_bucket_write_access" {
  name = "${var.aws_iam_user}_S3BucketWriteAccessPolicy"
  user = aws_iam_user.service_s3_bucket_access.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:GetObjectAcl",
          "s3:ListBucket",
          "s3:DeleteObject",
          "s3:PutObject",
          "s3:PutObjectAcl",
        ],
        Resource = [
          aws_s3_bucket.site.arn,
          "${aws_s3_bucket.site.arn}/*"
        ]
      }
    ]
  })
}

