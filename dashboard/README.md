# Terraform template for NewRelic Dashboard

## このツールについて

Terraform による NewRelic ダッシュボード導入のためのテンプレートです。  
最小限の設定で NewRelic ダッシュボードを作成することが出来ます。

## リリースノート

リリースノートについては、[コンフルエンス](https://confl.arms.dmm.com/pages/viewpage.action?pageId=1100764234)を参照してください。

## ダッシュボードの種類

本テンプレートで作成可能なダッシュボードは以下の通りです。

* aws_newrelic_charge
* core_web_vitals
* circleci

各ダッシュボードの内容については、各モジュールの README.md を参照してください。

## 事前準備

各ダッシュボードにおける事前準備については、各モジュールの README.md を参照してください。

## 使い方

以下は手作業で terraform を実行する際の手順です。  
※現状、dashboard について CI/CD に対応していません。

※`dashboard/src/environments/example` にはサンプル設定が入っています。

1. ディレクトリを移動します。複数環境（STG/PROD）で設定を分ける場合は、それぞれのディレクトリ（staging, production）を使用してください。
    ```bash
    $ cd dashboard/src/environments/*****
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

※任意  
初回の terraform apply 以降は NewRelic の画面上からダッシュボードの設定変更を行うことを想定しています。  
以下のコマンドを実行し、ダッシュボードのリソースを Terraform の管理下から削除してください。

```bash
$ terraform state rm module.dashboard_aws_newrelic_charge.newrelic_one_dashboard.aws_newrelic_charge
$ terraform state rm module.dashboard_core_web_vitals.newrelic_one_dashboard.core_web_vitals
$ terraform state rm module.dashboard_circleci.newrelic_one_dashboard.circleci
```
