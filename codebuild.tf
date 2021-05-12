resource "aws_codebuild_project" "iac-plan" {
  name          = "iac-plan"
  description   = "planning out the builds"
  service_role  = aws_iam_role.codebuild-role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "hashicorp/terraform:0.15.3"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "SERVICE_ROLE"
    registry_credential{
        credential = var.dockerhub_cred
        credential_provider = "SECRETS_MANAGER"
    }
  }

source {
    type = "CODEPIPELINE"
    buildspec = file("buildspec/plan-buildspec.yml")
}

}

resource "aws_codebuild_project" "iac-apply" {
  name          = "iac-apply"
  description   = "planning out the builds"
  service_role  = aws_iam_role.codebuild-role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "hashicorp/terraform:0.15.3"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "SERVICE_ROLE"
    registry_credential{
        credential = var.dockerhub_cred
        credential_provider = "SECRETS_MANAGER"
    }
  }

source {
    type = "CODEPIPELINE"
    buildspec = file("buildspec/apply-buildspec.yml")
}
}