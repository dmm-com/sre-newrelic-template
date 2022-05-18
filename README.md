# Terraform template for NewRelic Dashboard

## このツールについて

Terraform による NewRelic ダッシュボード導入のためのテンプレートです。  
最小限の設定で NewRelic ダッシュボードを作成することが出来ます。

## ダッシュボードの説明

本テンプレートで作成可能なダッシュボードは以下の通りです。

* dashboard_aws_newrelic_charge
* dashboard_core_web_vitals
* dashboard_circleci

### dashboard_aws_newrelic_charge

AWS と NewRelic の料金推移を可視化します。

### dashboard_core_web_vitals

Core Web Vitals を可視化します。  
Core Web Vitals については、https://web.dev/i18n/ja/vitals/ を参照してください。

### dashboard_circleci

CircleCI の実行状況を可視化します。  
詳細については、https://newrelic.com/instant-observability/circleci/39109d3d-b1d8-4366-8ca9-b8925005f727 を参照してください。

## 事前準備

### dashboard_aws_newrelic_charge

AWS の料金をクエリするには、AWS polling integrations の設定を行い、Billing を有効にしてください。

https://docs.newrelic.com/jp/docs/infrastructure/amazon-integrations/connect/connect-aws-new-relic-infrastructure-monitoring/

NewRelic の料金をクエリするための事前準備はありません。

### dashboard_core_web_vitals

Browser が設定されており、`FROM PageViewTiming SELECT count(*)` でクエリ結果が正常に出力されることを確認してください。

https://docs.newrelic.com/jp/docs/browser/browser-monitoring/getting-started/introduction-browser-monitoring/

### dashboard_circleci

CircleCI の Webhooks 設定を行います。  
設定方法については、https://docs.newrelic.com/docs/logs/forward-logs/circleci-logs/ を参照してください。

## 使い方

example.tfvars を元に tfvars ファイルを新規作成し、各項目を入力後に以下のコマンドを実行してください。

```bash
$ terraform init
$ terraform plan -var-file sre.tfvars
$ terraform apply -var-file sre.tfvars
```

※任意  
初回の terraform apply 以降は NewRelic の画面上から変更を行うことを想定しているため、以下のコマンドを実行し、ダッシュボード作成について Terraform の管理下から外してください。

```bash
$ terraform state rm newrelic_one_dashboard.aws_newrelic_charge
$ terraform state rm newrelic_one_dashboard.circleci
$ terraform state rm newrelic_one_dashboard.core_web_vitals
```
