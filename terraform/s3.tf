resource "aws_s3_bucket" "app_alb_log" {
  bucket = "app-alb-log-configured-by-yuizho"
  # FIXME:
  # お試しでガシガシ消す環境なので、S3にデータが残ってても強制的に消せるようにしている
  # 実運用では事故防止のためにデフォルトのfalseのままで運用した方が良いと思う
  force_destroy = true

  lifecycle_rule {
    enabled = true

    expiration {
      days = "180"
    }
  }
}

resource "aws_s3_bucket_policy" "app_alb_log_policy" {
  bucket = aws_s3_bucket.app_alb_log.id
  policy = data.aws_iam_policy_document.app_alb_log.json
}

data "aws_iam_policy_document" "app_alb_log" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.app_alb_log.id}/*"]

    # ALBからS3に書き込む場合リージョンごとにAWSが管理しているアカウントから書き込むことになるので
    # そのAWSアカウントの情報をprincipalsに指定してやる必要がある
    # このアカウントはリージョンごとに異なるので、identifiersに指定した番号はap-northeast-1から変わったら変えないといけない
    # https://docs.aws.amazon.com/ja_jp/elasticloadbalancing/latest/classic/enable-access-logs.html#attach-bucket-policy
    # https://kakakakakku.hatenablog.com/entry/2023/06/05/221205
    principals {
      type        = "AWS"
      identifiers = ["582318560864"]
    }
  }
}
