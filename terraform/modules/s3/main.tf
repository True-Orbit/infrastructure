resource "aws_s3_bucket" "alb_logs" {
  bucket = "true-orbit-alb-logs-bucket"
}

resource "aws_s3_bucket_policy" "alb_logs_policy" {
  bucket = aws_s3_bucket.alb_logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowAllAccess",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:*",
        Resource = [
          "${aws_s3_bucket.alb_logs.arn}",
          "${aws_s3_bucket.alb_logs.arn}/*"
        ]
      }
    ]
  })
}