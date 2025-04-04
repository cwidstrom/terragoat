resource "random_integer" "rnd_int" {
  min     = 1
  max     = 10000
}

variable "mailgun_api_key" {
  description = "Your Mailgun API key"
}
variable "demo_email_address" {
  description = "Enter your email (e.g. me@gmail.com), so you'll get a copy-pasteable curl command for testing the API immediately"
}
# Configure the Mailgun provider
# https://www.terraform.io/docs/providers/mailgun/index.html
provider "mailgun" {
  version = "~> 0.1"
  api_key = "${var.mailgun_api_key}"
}
module "my_mailgun_domain" {
  # Available inputs: https://github.com/futurice/terraform-utils/tree/master/aws_mailgun_domain#inputs
  # Check for updates: https://github.com/futurice/terraform-utils/compare/v11.0...master
  source = "git::ssh://git@github.com/futurice/terraform-utils.git//aws_mailgun_domain?ref=v11.0"
  mail_domain   = "example.com"
  smtp_password = "SECRET SECRET SECRET"
}
output "demo_curl_command" {
  value = "curl -s --user 'api:${var.mailgun_api_key}' ${module.my_mailgun_domain.api_base_url}messages -F from='Demo <demo@${module.my_mailgun_domain.mail_domain}>' -F to='${var.demo_email_address}' -F subject='Hello' -F text='Testing, testing...'"
}
