resource "aws_iam_role" "codebuild-role" {
    name = "${var.application}-codebuild-role"
    assume_role_policy = file("${var.enable_customl_trust_policy == true ? "custom/role-trust-${terraform.workspace}.json" : "trusts/codebuild.json"}")
    managed_policy_arns = concat([aws_iam_policy.codebuild_policy.arn],var.iam_managed_policy_arns)
}


output "codebuild_role_name" {
  value = aws_iam_role.codebuild-role.name
}

output "codebuild_role_arn" {
    value = aws.iam_role.codebuild-role.arn
}