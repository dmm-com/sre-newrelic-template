# Terraform template for NewRelic Dashboard

## このツールについて

Terraform による NewRelic ダッシュボード導入のためのテンプレートです。  
最小限の設定で NewRelic ダッシュボードを作成することが出来ます。

## ダッシュボードの種類

本テンプレートで作成可能なダッシュボードは以下の通りです。

* aws_newrelic_charge
* core_web_vitals
* circleci

各ダッシュボードの内容については、各モジュールの README.md を参照してください。

## 事前準備

各ダッシュボードにおける事前準備については、各モジュールの README.md を参照してください。

## 使い方

本テンプレートでは、サンプル環境の定義として `example` を用意しています。

実環境への適用時には `dashboard/src/environments/example` を `dashboard/src/environments/production` などのようにコピー、あるいはリネームして使用してください。

以下は手作業で terraform を実行する際の手順です。  
※現状、dashboard について CI/CD に対応していません。

ここでは `dashboard/src/environments/example` を手作業でデプロイする手順を記載します。

1. ディレクトリを移動します。
    ```bash
    $ cd dashboard/src/environments/example
    ```
2. カレントディレクトリ配下に `terraform.tfvars` ファイルを作成し、以下のように定義します。
    ```bash
    nr_account_id = 1234567                            # NewRelicアカウントID, 数値型
    nr_api_key    = "NRAK-XXXXXXXXXXXXXXXXXXXXXXXXXXX" # Type:USERのAPIキー
    ```
3. `backend.cfg` 内の `bucket` 変数を変更します。設定内容についてはファイル内のコメントを参照してください。
4. `locals.tf` 内の変数を変更します。設定内容についてはファイル内のコメントを参照してください。
5. AWS 認証情報を読み込みます。
    ```bash
    $ export AWS_PROFILE=terraform
    ```
6. terraform を実行します。
    ```bash
    $ terraform init -backend-config="backend.cfg"
    $ terraform plan
    $ terraform apply
    ```

※任意  
初回の terraform apply 以降は NewRelic の画面上からダッシュボードの設定変更を行うことを想定しています。  
以下のコマンドを実行し、ダッシュボードのリソースを Terraform の管理下から削除してください。

```bash
$ terraform state rm module.dashboard_aws_newrelic_charge.newrelic_entity_tags.aws_newrelic_charge
$ terraform state rm module.dashboard_aws_newrelic_charge.newrelic_one_dashboard_json.aws_newrelic_charge
$ terraform state rm module.dashboard_circleci.newrelic_entity_tags.circleci
$ terraform state rm module.dashboard_circleci.newrelic_one_dashboard_json.circleci
$ terraform state rm module.dashboard_core_web_vitals.newrelic_entity_tags.core_web_vitals
$ terraform state rm module.dashboard_core_web_vitals.newrelic_one_dashboard_json.core_web_vitals
```
