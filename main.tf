# Configure Terraform with required AWS provider
terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 4.0"
    }
  }
}

# Process template files from the "web" directory
module "template_files" {
    source = "hashicorp/dir/template"

    base_dir = "${path.module}/web"
}
# Configure AWS provider with region and credentials
provider "aws" {
    region = var.aws_region
    access_key = "test"
    secret_key = "test"
  
}

# Create S3 bucket for hosting

resource "aws_s3_bucket" "hosting_bucket" {
    bucket = var.bucket_name
}


# Configure ownership controls for the S3 bucket
resource "aws_s3_bucket_ownership_controls" "hosting-bucket-ownership" {
  bucket = aws_s3_bucket.hosting_bucket.id   

  rule {
    object_ownership = "ObjectWriter"
  }
}
# Configure public access block policy for the S3 bucket

resource "aws_s3_bucket_public_access_block" "public-block-policy" {
  bucket = aws_s3_bucket.hosting_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
# Configure ACL for the S3 bucket
resource "aws_s3_bucket_acl" "bucket_name_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.hosting-bucket-ownership,
    aws_s3_bucket_public_access_block.public-block-policy,
  ]

  bucket = aws_s3_bucket.hosting_bucket.id
  acl    = "public-read"
}
# Configure bucket policy to allow public read access
resource "aws_s3_bucket_policy" "hosting_bucket_policy" {
    bucket = aws_s3_bucket.hosting_bucket.id

    policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": "*",
                "Action": "s3:GetObject",
                "Resource": "arn:aws:s3:::${var.bucket_name}/*"
            }
        ]
    })
}
# Configure website configuration for the S3 bucket
resource "aws_s3_bucket_website_configuration" "hosting_bucket_website_configuration" {
    bucket = aws_s3_bucket.hosting_bucket.id

    index_document {
      suffix = "index.html"
    }
}
# Upload files to the S3 bucket
resource "aws_s3_object" "hosting_bucket_files" {
    bucket = aws_s3_bucket.hosting_bucket.id

    for_each = module.template_files.files

    key          = each.key
    content_type = each.value.content_type

    source  = each.value.source_path
    content = each.value.content

    etag = each.value.digests.md5
}
