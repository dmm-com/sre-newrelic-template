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

本テンプレートは staging や production といった区別なく利用するため、実環境への適用時には `dashboard/src/environments/production` を使用してください。

以下は手作業で terraform を実行する際の手順です。  
※現状、dashboard について CI/CD に対応していません。

1. ディレクトリを移動します。
    ```bash
    $ cd dashboard/src/environments/production
    ```
2. カレントディレクトリ配下に `terraform.tfvars` ファイルを作成します。
3. 必要となる変数を `terraform.tfvars` に定義します。
    ```bash
    nr_account_id  = 1234567                                    # NewRelicアカウントID, 数値型
    nr_api_key     = "NRAK-XXXXXXXXXXXXXXXXXXXXXXXXXXX"         # Type:USERのAPIキー
    ```
4. `backend.cfg` 内の `bucket` 変数を設定します。設定内容についてはファイル内のコメントを参照してください。
5. `locals.tf` 内の変数を設定します。設定内容についてはファイル内のコメントを参照してください。
6. AWS 認証情報を読み込みます。
    ```bash
    $ export AWS_PROFILE=terraform
    ```
7. terraform を実行します。
    ```bash
    $ terraform init -backend-config="backend.cfg"
    $ terraform plan -var-file="terraform.tfvars"
    $ terraform apply -var-file="terraform.tfvars"
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
