resource "aws_codebuild_project" "codebuild_project" {
    name = "${var.application}-codebuild-project"
    description = "Codebuild project for ${var.application}"
    build_timeout = var.codebuild_build_timeout
    service_role = aws_iam_role.codebuild-role.arn

    artifacts {
      type = var.artifact_type
      name =  var.artifact_type == "S3" ? "${var.application}-codebuild-artifact" : null
      location = var.artifact_type == "S3" ? var.s3_bucket : null
      path = var.artifact_type == "S3" ? var.artifact_path : null
      packaging = var.artifact_type == "S3" ? upper(var.artifact_packaging) : null
    }

    dynamic "cache" {
      for_each = contains(["","S3"],var.cache_type) ? [] : [1]

      content{
        type= var.cache_type
        location = var.cache_type == "S3" ? var.s3_bucket : null
        # only S3 and LOCAL cache types are supported; omit modes to avoid referencing undefined variable
        # use var.cache_modes if defined in your variables.tf
      }
    }

    environment {
      compute_type = var.compute_type
      image = var.standard_image == true ? var.codebuild_image : var.arm64_codebuild_image
      type = var.codebuild_type
      privileged_mode = var.priviliged

      dynamic "environment_variable" {
         for_each = var.environment_variables

         content {
         name = environment_variable.key
         value = environment_variable.value
         }
       }
    }

    source{
      type = var.source_type
      location = var.source_type == "NO_SOURCE" ? null : var.github_repo
      git_clone_depth = var.source_type == "GITHUB_ENTERPRISE" ? var.clone_depth : null
    }
}


//resource "aws_codebuild_source_credential" "codebuild_project" {
//    count = var.source_type == "GITHUB" ? 1 : 0
//    auth_type = "secretsmanager"
//    server_type = "GITHUB"
//    token = data.aws_secretsmanager_secret_version.github_pat[0].secret_string


//    lifecycle {
//        prevent_destroy = false
//    }
// }

# 1. Fetch the actual content from the Secrets Manager ARN
data "aws_secretsmanager_secret_version" "github_pat" {
  count     = var.source_type == "GITHUB" ? 1 : 0
  secret_id = var.pat_secret_arn
}

# 2. Pass the decrypted string value to CodeBuild
resource "aws_codebuild_source_credential" "codebuild_project" {
  count       = var.source_type == "GITHUB" ? 1 : 0
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  #
  token       = jsondecode(data.aws_secretsmanager_secret_version.github_pat[0].secret_string)["Github PAT"]
  lifecycle {
    prevent_destroy = false
  }
}

resource "github_repository_webhook" "foo" {
  count = var.webhook_active == true ? 1 : 0
  repository = var.github_repo_name
  events     = ["push"]
  configuration {
    url = aws_codebuild_webhook.codebuild_project[count.index].payload_url
    content_type = "json"
    insecure_ssl = false
    secret = aws_codebuild_source_credential.codebuild_project[count.index].token
  }
}


resource "aws_codebuild_webhook" "codebuild_project" {
  count = var.webhook_active == true ? 1 : 0
  project_name = aws_codebuild_project.codebuild_project.name
  depends_on = [aws_codebuild_source_credential.codebuild_project]

  filter_group{
    dynamic "filter" {
      for_each = var.filters

      content {
        type = filter.value.type
        pattern = filter.value.pattern
      }
    }
  }
}


