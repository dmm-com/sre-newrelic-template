# Terraform template for NewRelic Alert

## このツールについて

Terraform による NewRelic への AWS 監視導入のためのテンプレートです。  
最小限の設定で NewRelic を用いた監視を始めることが出来ます。

## リリースノート

リリースノートについては、[コンフルエンス](https://confl.arms.dmm.com/pages/viewpage.action?pageId=1090676546)を参照してください。

## アラートの説明

本テンプレートで作成可能なアラートは以下の通りです。

* AWS
  * CloudFront
  * EC2
  * ECS
  * ElastiCache
  * ELB
  * NAT Gateway
  * RDS
* NewRelic
  * APM
  * Synthetics

### AWS

#### CloudFront

#### EC2

#### ECS

#### ElastiCache

#### ELB

#### NAT Gateway

### NewRelic

#### APM

#### Synthetics

## 事前準備

NewRelicとAWSのアカウントがそれぞれ必要です。
また、別に以下の準備が必要となります。

- [Amazon CloudWatch Metric Stream と NewRelic の連携](https://newrelic.com/jp/blog/how-to-relic/aws-cloudwatch-metric-streams)
- [アラートを送る Slack の NewRelic の準備](https://docs.newrelic.com/jp/docs/alerts-applied-intelligence/new-relic-alerts/alert-notifications/notification-channels-control-where-send-alerts/#slack)
- [EC2 の監視を行う場合、NewRelic infrastructure agent を EC2 インスタンスに導入](https://docs.newrelic.com/jp/docs/infrastructure/infrastructure-monitoring/get-started/get-started-infrastructure-monitoring/#install)
  - 一部の監視に、[独自のメトリクスを追加するflex](https://docs.newrelic.com/jp/docs/integrations/host-integrations/host-integrations-list/flex-integration-tool-build-your-own-integration/)を使用しているため、  
  `/etc/newrelic-infra/integrations.d/flex-dummy.yml` にリポジトリのflex-dummy にコピー

## 使い方

以下は手作業で terraform を実行する際の手順です。

※`example` にはサンプル設定が入っています。

1. ディレクトリを移動します。複数環境（STG/PROD）で設定を分ける場合は、それぞれのディレクトリ（staging, production）を使用してください。
    ```bash
    $ cd alert/src/environments/*****
    ```
2. `locals.tf` および `env.tf` 内の変数を設定します。
  * locals.tf
    ```
    nr_account_id ･･･ Alert を作成する NewRelic アカウント ID
    nr_api_key    ･･･ Type が USERの API キー
    ```
  * env.tf
    ```
    alert_policy_name           ･･･ アラートポリシー名
    alert_slack_channel.name    ･･･ NewRelic チャンネル設定名
    alert_slack_channel.url     ･･･ Slack Incoming Webhook URL
    alert_slack_channel.channel ･･･ Slack チャンネル名
    slack_mention               ･･･ Slack 通知時のメンション先
    apm_app_name_prefix         ･･･ NewRelic APM の監視対象とする appName の接頭辞
    ```
3. AWS 認証情報を読み込みます。
    ```bash
    export AWS_PROFILE=example
    ```
4. terraform を実行します。
    ```bash
    $ terraform init
    $ terraform plan
    $ terraform apply
    ```

### 注意点

AWSのタグは、NewRelicに反映されるまでかなり時間がかかります。30分程度待ってから動作確認することをおすすめします。

### 同一のAWSアカウント内に、複数のサブシステムがあり、監視を切り分けたい場合

EC2 などではタグでの切り分けが可能です。
Elasticache などではタグの指定ができませんが、これは現状の検証ではタグが使えなかったためです。

## コードの書き換えを行いたい場合

このテンプレートを作る上で、いくつか得られた知見についてメモしておきます。

- CloudWatch Metric Stream は、AWS 側でどんなメトリクスが取れるかを見る方が良い
  - NewRelic 側からは、Cloud Watch Metric Stream とそれ以外が混在しているため、見分けがつきにくい
  - 例えば [EC2](https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/viewing_metrics_with_cloudwatch.html), [RDS](https://docs.aws.amazon.com/ja_jp/AmazonRDS/latest/UserGuide/monitoring-cloudwatch.html), [Elastcache(memcached)](https://docs.aws.amazon.com/ja_jp/AmazonElastiCache/latest/mem-ug/CacheMetrics.html) であればドキュメントに記載がある
    - 特にデータの単位は NewRelic 側からは分からないので、適宜AWS側で調べたほうが早い
