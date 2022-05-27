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

### 各種アカウント

AWS アカウントは既に発行済みとします。  
NewRelic アカウントが未取得の場合は、作成申請を行ってください。  

https://confl.arms.dmm.com/pages/viewpage.action?pageId=947665682  
Q. アカウントの開設／閉鎖をするにはどうしたら良いですか

### AWS 認証情報

terraform 実行用の IAM ユーザーが存在することを確認してください。  
通常であれば、AWS アカウント発行時に既に TerraformUser というユーザーが作成されています。  
存在しない場合は、別名でも構わないので作成してください。


また、別に以下の準備が必要となります。

- [Amazon CloudWatch Metric Stream と NewRelic の連携](https://newrelic.com/jp/blog/how-to-relic/aws-cloudwatch-metric-streams)
- [アラートを送る Slack の NewRelic の準備](https://docs.newrelic.com/jp/docs/alerts-applied-intelligence/new-relic-alerts/alert-notifications/notification-channels-control-where-send-alerts/#slack)
- [EC2 の監視を行う場合、NewRelic infrastructure agent を EC2 インスタンスに導入](https://docs.newrelic.com/jp/docs/infrastructure/infrastructure-monitoring/get-started/get-started-infrastructure-monitoring/#install)
  - 一部の監視に、[独自のメトリクスを追加するflex](https://docs.newrelic.com/jp/docs/integrations/host-integrations/host-integrations-list/flex-integration-tool-build-your-own-integration/)を使用しているため、  
  `/etc/newrelic-infra/integrations.d/flex-dummy.yml` にリポジトリのflex-dummy にコピー

## 使い方

以下は手作業で terraform を実行する際の手順です。

※`example` にはサンプル設定が入っています。

1. AWS 認証情報ファイルの作成を行います。（作成例）
    ```bash
    $ aws configure --profile example
    AWS Access Key ID [None]: ********
    AWS Secret Access Key [None]: ************************
    Default region name [None]: ap-northeast-1
    Default output format [None]: json
    ```
2. ディレクトリを移動します。複数環境（STG/PROD）で設定を分ける場合は、それぞれのディレクトリ（staging, production）を使用してください。
    ```bash
    $ cd alert/src/environments/*****
    ```
3. `locals.tf` および `env.tf` 内の変数を設定します。
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
4. AWS 認証情報を読み込みます。
    ```bash
    $ export AWS_PROFILE=example
    ```
5. terraform を実行します。
    ```bash
    $ terraform init
    $ terraform plan
    $ terraform apply
    ```

## 注意点

* AWS のタグは、NewRelic に反映されるまでタイムラグがあります。30分程度待ってから確認することをおすすめします。
* 同一の AWS アカウント内に複数のサブシステムがあり監視を切り分けたい場合、EC2 などではタグによるフィルターが可能です。  
  ただし、CloudFront や ElastiCache などではタグ情報が NewRelic に送られないため、タグによるフィルターを行うことが出来ません。
