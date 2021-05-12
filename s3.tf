resource "aws_kms_key" "artifact_key" {
  description             = "key to encrypt artifact bucket"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "pipeline_artifacts" {
  bucket = "gs-pipeline-artifacts-bucket"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.artifact_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

}