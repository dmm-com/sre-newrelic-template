# Terraform template for AWS Integration (Metric Streams)

## このモジュールについて

Terraform による NewRelic での AWS インテグレーション設定を行うためのテンプレートです。  
NewRelic でアラートやダッシュボードを作成する際に必須で実行する必要があります。

参考：https://newrelic.com/jp/blog/how-to-relic/aws-cloudwatch-metric-streams

なお、このモジュールでは任意のリージョンに Metric Streams で使用する共通の AWS リソースを作成します。

* NewRelic AWS インテグレーション用の IAM ロール
* Firehose ログ出力先の S3 バケット
* Firehose にアタッチする IAM ロール
* MetricStream にアタッチする IAM ロール

加えて、NewRelic に対して Integration 設定を行います。

* NewRelic と AWS のアカウントリンク

## 補足

このモジュールでは、コード内で AWS アカウントエイリアス名を使用しているため、事前にアカウントエイリアスの設定を行ってください。
