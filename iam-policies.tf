data "template_file" "codebuild_policy_data" {
  template = templatefile("${var.enable_customl_role_policy == true ? "custom/role-policy-codebuild.json" : "policies/role-policy.json.tpl"}")
  vars = {
    s3_bucket = var.s3_bucket
    artifact_type = var.artifact_type
    artifact_path = var.artifact_path
    region = var.region
    application = var.application
  }
}

resource "aws_iam_policy" "codebuild_policy" {
    name = "${var.application}-codebuild-policy"
    policy = data.template_file.codebuild_policy_data
  
}