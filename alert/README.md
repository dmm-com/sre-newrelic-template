# Terraform template for NewRelic Alert

## このツールについて

Terraform による NewRelic への AWS 監視導入のためのテンプレートです。  
最小限の設定で NewRelic を用いた監視を始めることが出来ます。

## リリースノート

リリースノートについては、[コンフルエンス](https://confl.arms.dmm.com/pages/viewpage.action?pageId=1090676546)を参照してください。

## アラートの種類

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

各アラートでの監視内容については、各モジュールの README.md を参照してください。

## 前提条件

* `aws/src/modules/metricstream` の実行が完了し、AWS インテグレーションの設定が終わっているものとします。

## 事前準備

### Slack チャンネル

Slack にアラート通知を行うため、Slack チャンネルの作成と Slack の NewRelic インテグレーションの設定を行います。  
Slack の NewRelic インテグレーション設定については、以下のドキュメントを参照してください。  
https://docs.newrelic.com/jp/docs/alerts-applied-intelligence/notifications/notification-integrations#slack

### NewRelic Infrastructure エージェント

EC2 の監視を行う場合、以下のドキュメントを参照し EC2 インスタンスに NewRelic Infrastructure エージェントを導入します。  
https://docs.newrelic.com/jp/docs/infrastructure/infrastructure-monitoring/get-started/get-started-infrastructure-monitoring/#install

なお、一部の監視に [New Relic Flex](https://docs.newrelic.com/jp/docs/integrations/host-integrations/host-integrations-list/flex-integration-tool-build-your-own-integration/) を使用しています。  
Flex を有効にするために EC2 インスタンスの `/etc/newrelic-infra/integrations.d` 配下に [flex-dummy.yml](src/modules/ec2/flex-dummy.yml) をコピーしてください。

## 使い方

### 手作業

以下は手作業で terraform を実行する際の手順です。

※`alert/src/environments/example` にはサンプル設定が入っています。

1. ディレクトリを移動します。複数環境（STG/PROD）で設定を分ける場合は、それぞれのディレクトリ（staging, production）を使用してください。
    ```bash
    $ cd alert/src/environments/*****
    ```
2. `locals.tf` 内の変数を設定します。設定内容についてはファイル内のコメントを参照してください。
3. `backend.cfg` 内の変数を設定します。設定内容についてはファイル内のコメントを参照してください。
4. AWS 認証情報を読み込みます。
    ```bash
    $ export AWS_PROFILE=terraform
    ```
5. terraform を実行します。
    ```bash
    $ terraform init -backend-config="backend.cfg"
    $ terraform plan
    $ terraform apply
    ```

### CircleCI

alert テンプレートについては、CircleCI での terraform 実行に対応しています。  
ここでは【[aws テンプレート](../aws/README.md#CircleCI)】で Contexts が作成済みであるものとします。

コード内の各種設定内容については、【[手作業](../alert/README.md#手作業)】を参照してください。

## 注意点

* AWS のタグは、NewRelic に反映されるまでタイムラグがあります。30分程度待ってから確認することをおすすめします。
* 同一の AWS アカウント内に複数のサブシステムがあり監視を切り分けたい場合、EC2 などではタグによるフィルターが可能です。  
  ただし、CloudFront や ElastiCache などではタグ情報が NewRelic に送られないため、タグによるフィルターを行うことが出来ません。
