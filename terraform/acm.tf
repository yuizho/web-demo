# ACMの証明書取得などはManagementConsoleから手動でやる前提
# https://zenn.dev/not75743/articles/72679257569f2e
data "aws_acm_certificate" "app_acm_certificate" {
  count = var.domain != null ? 1 : 0

  domain   = var.domain
}
