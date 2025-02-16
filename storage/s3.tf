# 랜덤 접미사 생성 (고유한 버킷 이름 보장)
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# S3 버킷 생성
resource "aws_s3_bucket" "tf_backup_bucket" {
  bucket = "tf-backup-bucket-${random_string.suffix.result}" # 고유 이름 생성

  tags = {
    Name        = "tf_backup_bucket"
    Environment = "production"
  }
}

# S3 버킷 소유권 제어
resource "aws_s3_bucket_ownership_controls" "vss_backup_bucket_ownership" {
  bucket = aws_s3_bucket.vss_backup_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# S3 버킷 버전 관리 활성화
resource "aws_s3_bucket_versioning" "vss_backup_versioning" {
  bucket = aws_s3_bucket.vss_backup_bucket.id

  versioning_configuration {
    status = "Enabled" # 버전 관리 활성화
  }
}

# S3 버킷 수명 주기 정책 설정 (데이터 자동 삭제)
resource "aws_s3_bucket_lifecycle_configuration" "vss_backup_lifecycle" {
  bucket = aws_s3_bucket.vss_backup_bucket.id

  rule {
    id     = "Delete old versions"
    status = "Enabled"

    filter {} # 필수 추가 (빈 필터로 전체 대상)

    expiration {
      days = 7
    }
  }
}

# S3 버킷 암호화 설정 (AES256)
resource "aws_s3_bucket_server_side_encryption_configuration" "vss_backup_encryption" {
  bucket = aws_s3_bucket.vss_backup_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 버킷 공용 접근 차단
resource "aws_s3_bucket_public_access_block" "vss_backup_public_access_block" {
  bucket = aws_s3_bucket.vss_backup_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Terraform 백엔드 설정 (S3 및 DynamoDB 사용)
terraform {
  backend "s3" {
    bucket         = "vss-backup-bucket-${random_string.suffix.result}"
    key            = "path/to/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = aws_dynamodb_table.terraform_locks.name
  }
}
