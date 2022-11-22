# Terraform template for AWS

## このツールについて

Terraform による NewRelic に関係した AWS リソースの作成を行うためのテンプレートです。

## リリースノート

リリースノートについては、[コンフルエンス](https://confl.arms.dmm.com/pages/viewpage.action?pageId=1246768485)を参照してください。

## モジュールの説明

本テンプレートで利用可能なモジュールは以下の通りです。

| モジュール名 | 説明 |
| ---- | ---- |
| metricstream_common | NewRelic で AWS インテグレーション設定を行う際に必要なリソースを作成。リージョン共通で使用されるリソースがここに含まれる。 |
| metricstream | NewRelic で AWS インテグレーション設定を行う際に必要なリソースを作成。リージョン単位で使用されるリソースがここに含まれる。 |

## 使い方

### 手作業

以下は手作業で terraform を実行する際の手順です。

※`aws/src/environments/example` にはサンプル設定が入っています。

1. ディレクトリを移動します。複数環境（STG/PROD）で設定を分ける場合は、それぞれのディレクトリ（staging, production）を使用してください。
    ```bash
    $ cd aws/src/environments/*****
    ```
2. `locals.tf` および `env.tf` 内の変数を設定します。設定内容についてはファイル内のコメントを参照してください。
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
