output "codebuild_secret" {
    value = aws_codebuild_webhook.codebuild_project[*].secret
  
}

output "codebuild_url" {
  value = aws_codebuild_webhook.codebuild_project[*].url
}

output "codebuild_policy" {
  value = aws_iam_policy.codebuild_policy
}

output "codebuild_policy_id" {
    value = aws_iam_policy.codebuild_policy.id
}


output "codebuild_policy_text" {
    value = aws_iam_policy.codebuild_policy.policy
}


