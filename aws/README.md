# Terraform template for AWS

## このツールについて

Terraform による NewRelic に関係した AWS リソースの作成を行うためのテンプレートです。

## モジュールの説明

本テンプレートで利用可能なモジュールは以下の通りです。

| モジュール名 | 説明 |
| ---- | ---- |
| metricstream_common | NewRelic で AWS インテグレーション設定を行う際に必要なリソースを作成。リージョン共通で使用されるリソースがここに含まれる。 |
| metricstream | NewRelic で AWS インテグレーション設定を行う際に必要なリソースを作成。リージョン単位で使用されるリソースがここに含まれる。 |

## 使い方

本テンプレートは AWS アカウントを development, staging, production といった環境でアカウント分離を行っていることを前提としています。  
テンプレートで用意している環境は development のみですが、必要に応じてその他環境用のディレクトリを development ディレクトリを元に  `aws/src/environments/` 配下に作成してください。

### 手作業

以下は手作業で terraform を実行する際の手順です。

#### development 環境の場合

ここでは development 環境を例とした手順を記載しています。

1. ディレクトリを移動します。他の環境にデプロイする場合は、それぞれのディレクトリ（staging, production）として読み替えてください。
    ```bash
    $ cd aws/src/environments/development
    ```
2. カレントディレクトリ配下に `terraform.tfvars` ファイルを作成します。
3. 必要となる変数を `terraform.tfvars` に定義します。
    ```bash
    nr_account_id  = 1234567                                    # NewRelicアカウントID, 数値型
    nr_api_key     = "NRAK-XXXXXXXXXXXXXXXXXXXXXXXXXXX"         # Type:USERのAPIキー
    nr_license_key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXFFFFNRAL" # Type:Licenseキー
    ```
4. `backend.cfg` 内の `bucket` 変数を設定します。設定内容についてはファイル内のコメントを参照してください。
5. AWS 認証情報を読み込みます。
    ```bash
    $ export AWS_PROFILE=terraform
    ```
6. terraform を実行します。
    ```bash
    $ terraform init -backend-config="backend.cfg"
    $ terraform plan -var-file="terraform.tfvars"
    $ terraform apply -var-file="terraform.tfvars"
    ```

#### その他環境の場合

ここではその他の環境を例とした手順を記載しています。  
基本的に development 環境での手順と同じですが、以下のように一部変更が必要です。

1. `aws/src/environments/` 配下にデプロイする対象の環境用ディレクトリを作成します。
2. 作成した環境用ディレクトリ配下に `terraform.tfvars` ファイルを作成します。
3. `backend.cfg` 内の `bucket` 変数を設定します。設定内容についてはファイル内のコメントを参照してください。

### CircleCI

aws テンプレートについては、CircleCI での terraform 実行に対応しています。  
事前に以下の内容で Contexts を作成してください。
```
Contexts 名は CircleCI の Organization で一意である必要があるため、適宜変更してください。
ここで作成した Contexts を .circleci/config.yml に設定します。
```

1. CircleCI の Organization Settings で Contexts を作成します。
    | Contexts 名（例） | 説明 |
    | ---- | ---- |
    | stg-newrelic-template | ステージング環境用の Contexts |
    | prd-newrelic-template | 本番環境用の Contexts |
2. 作成した Contexts に以下の環境変数を作成します。
    | 環境変数名 | 説明 |
    | ---- | ---- |
    | AWS_ACCESS_KEY_ID | 操作対象とする AWS アカウントの AWS アクセスキー ID |
    | AWS_SECRET_ACCESS_KEY | 操作対象とする AWS アカウントの AWS シークレットアクセスキー |
    | NEWRELIC_ACCOUNT_ID | 操作対象とする NewRelic のアカウント ID |
    | NEWRELIC_API_KEY | 操作対象とする NewRelic の API キー（Type:USER） |
    | NEWRELIC_LICENSE_KEY | 操作対象とする NewRelic の API キー（Type:License） |

コード内の各種設定内容については、【[手作業](../aws/README.md#手作業)】を参照してください。
