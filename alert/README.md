# Terraform template for New Relic

## このツールについて

TerraformによるAWSへのNew Relic監視導入のためのテンプレートです。
最低限の変更で、New Relicを用いたインフラ監視を始めることができます。

## リリースノート

リリースノートについては、[コンフルエンス](https://confl.arms.dmm.com/pages/viewpage.action?pageId=1090676546)を参照してください。

## 事前準備

New RelicとAWSのアカウントがそれぞれ必要です。
また、別に以下の準備が必要となります。

- [Amazon CloudWatch Metric Stream と New Relic の連携](https://newrelic.com/jp/blog/how-to-relic/aws-cloudwatch-metric-streams)
- [アラートを送る Slack の New Relic の準備](https://docs.newrelic.com/jp/docs/alerts-applied-intelligence/new-relic-alerts/alert-notifications/notification-channels-control-where-send-alerts/#slack)
- [EC2 の監視を行う場合、New Relic infrastructure agent を EC2 インスタンスに導入](https://docs.newrelic.com/jp/docs/infrastructure/infrastructure-monitoring/get-started/get-started-infrastructure-monitoring/#install)
  - 一部の監視に、[独自のメトリクスを追加するflex](https://docs.newrelic.com/jp/docs/integrations/host-integrations/host-integrations-list/flex-integration-tool-build-your-own-integration/)を使用しているため、  
  `/etc/newrelic-infra/integrations.d/flex-dummy.yml` にリポジトリのflex-dummy にコピー

## 使い方

example.tfvars を元に監視対象や、必要な認証情報を記載したtfvarsファイルを作成し、

```bash
terraform init
terraform plan -var-file prod.tfvars
terraform apply -var-file prod.tfvars
```

とすると使用できます。

### 注意点

AWSのタグは、New Relicに反映されるまでかなり時間がかかります。30分程度待ってから動作確認することをおすすめします。

### 複数のAWSアカウントを使用したい場合

tfvars を分けることで対応してください。

### 同一のAWSアカウント内に、複数のサブシステムがあり、監視を切り分けたい場合

EC2 などではタグでの切り分けが可能です。
Elasticache などではタグの指定ができませんが、これは現状の検証ではタグが使えなかったためです。
詳しくはvariable.tfをご覧ください。

## コードの書き換えを行いたい場合

このテンプレートを作る上で、いくつか得られた知見についてメモしておきます。

- CloudWatch Metric Stream は、AWS 側でどんなメトリクスが取れるかを見る方が良い
  - New Relic 側からは、Cloud Watch Metric Stream とそれ以外が混在しているため、見分けがつきにくい
  - 例えば [EC2](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/viewing_metrics_with_cloudwatch.html), [RDS](https://docs.aws.amazon.com/ja_jp/AmazonRDS/latest/UserGuide/monitoring-cloudwatch.html), [Elastcache(memcached)](https://docs.aws.amazon.com/ja_jp/AmazonElastiCache/latest/mem-ug/CacheMetrics.html) であればドキュメントに記載がある
    - 特にデータの単位は New Relic 側からは分からないので、適宜AWS側で調べたほうが早い
- 一部の死活監視は素直に行うことは難しい
  - Aurora 以外の RDS などでは、ネットワークが全く流れていない場合は落ちているという判定をしているが、これは直接statusに取れないため
