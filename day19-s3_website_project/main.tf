resource "aws_s3_bucket" "mybucketweb" {
    bucket = var.bucketname
  }
  resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.mybucketweb.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.mybucketweb.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.mybucketweb.id
  key    = "index.html"
  source = "index.html"
  content_type = "text/html"
}
resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.mybucketweb.id
  key    = "error.html"
  source = "error.html"
  content_type = "text/html"
}
resource "aws_s3_bucket_policy" "public_read" {
  depends_on = [ aws_s3_object.index,aws_s3_object.error ]
  bucket = aws_s3_bucket.mybucketweb.id
  policy = jsonencode({
    "Version": "2012-10-17",		 	 	 
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            Resource: "${aws_s3_bucket.mybucketweb.arn}/*"
        }]
        })
    }
resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.mybucketweb.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  } 
  depends_on = [aws_s3_bucket_policy.public_read]
}