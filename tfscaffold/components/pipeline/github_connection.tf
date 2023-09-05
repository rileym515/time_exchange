# AWS CodeStar connection to public GitHub
## Resource requires manual intervention after deployment ##
resource "aws_codestarconnections_connection" "github" {
  name          = "time-exchange-github"
  provider_type = "GitHub"
}
