output "s3_bucket_arn" {
  description = "The Amazon Resource Name (ARN) of the Amazon S3 bucket."
  value       = aws_s3_bucket.example.arn
}

output "s3_bucket_region" {
  description = "The region of the Amazon S3 bucket."
  value       = aws_s3_bucket.example.region
}
