

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}



provider "aws"{
  profile = "default"

}



resource "aws_s3_bucket" "iacresume" {
  
    bucket = "iacresume"
    tags = {
      Name = "Res_bucket"
    }
    
}


resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.iacresume.id 
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "access" {
  bucket = aws_s3_bucket.iacresume.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "public"{
  bucket = aws_s3_bucket.iacresume.id 
  depends_on = [
    aws_s3_bucket_ownership_controls.ownership,
    aws_s3_bucket_public_access_block.access,

  ]
  acl = "public-read"
  
}

variable "content_type_map" {
  type = map(string)
  default = {
    "html" = "text/html"
    "css" = "text/css"
    "png" = "image/png"
    "jpg" = "image/jpeg"
    "js"  = "application/javascript"
  }
}

resource "aws_s3_object" "upload_resume" {
  for_each = fileset("C:/Users/Toke/Desktop/frontend/website/", "*")

  bucket = aws_s3_bucket.iacresume.id
  key    = each.value
   source = "C:/Users/Toke/Desktop/frontend/website/${each.value}"
    content_type = var.content_type_map[split(".", each.value)[length(split(".", each.value)) - 1]]
}



resource "aws_s3_bucket_policy" "iacresume_bucket_policy" {
  bucket = aws_s3_bucket.iacresume.bucket

  policy = jsonencode({
    "Version": "2008-10-17",
    "Id": "PolicyForCloudFrontPrivateContent",
    "Statement": [
        {
            "Sid": "AllowCloudFrontServicePrincipal",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudfront.amazonaws.com"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::iacresume/*",
            "Condition": {
                "StringEquals": {
                   "AWS:SourceArn": "arn:aws:cloudfront::538012638601:distribution/E3OXGA494V1V99"    
                }
            }
            
        }
    ]
})
}


