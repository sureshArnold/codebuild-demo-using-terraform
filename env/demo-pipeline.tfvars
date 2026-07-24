terraform {
    git_source = git@github.com:sureshArnold/codebuild-demo-using-terraform.git
}

application = "codebuild_demo"

codebuild_image = "aws/codebuild/standard:7.0"
codebuild_type= "LINUX_CONTAINER"
priviliged = "false"


github_repo="https://github.com/sureshArnold/WebApp"
clone_depth = 1
github_repo_name = "codebuild-demo-using-terraform"

filters = [
    {
        type = "EVENT", pattern ="PUSH"
    },
    {
        type = "HEAD_REF", pattern = "main"
    }
]

pat_secret_arn = "arn:aws:secretsmanager:us-east-1:557393770670:secret:codebuild/Github_PAT-atlGUP"

enable_customl_role_policy = true

s3_bucket ="codebuild-demo-bucket123"
region = "us-east-1"

environment_variables ={
    deploy_bucet="codebuild-demo-bucket123"
    project_name="codebuild-demo-using-terraform"
}

artifact_path= "config/"
artifact_packaging="NONE"


tags ={
    source = "https://github.com/sureshArnold/codebuild-demo-using-terraform"
}
