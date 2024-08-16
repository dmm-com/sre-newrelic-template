# Terraform template for AWS Integration (Metric Streams)

## このモジュールについて

Terraform による NewRelic での AWS インテグレーション設定を行うためのテンプレートです。  
NewRelic で AWS と連携するアラートやダッシュボードを作成する際に必須で実行する必要があります。

参考：https://newrelic.com/jp/blog/how-to-relic/aws-cloudwatch-metric-streams

なお、このモジュールでは任意のリージョンに以下の AWS リソースを作成します。

* NewRelic にメトリクスを送信する Firehose 配信ストリーム
* Firehose にメトリクスを送信する Metric Streams
