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

本テンプレートでは、サンプル環境の定義として `example` を用意しています。

実環境への適用時には `aws/src/environments/example` を `aws/src/environments/production` などのようにコピー、あるいはリネームして使用してください。

### 手作業

以下は手作業で terraform を実行する際の手順です。

ここでは `aws/src/environments/example` を手作業でデプロイする手順を記載します。

1. ディレクトリを移動します。
    ```bash
    $ cd aws/src/environments/example
    ```
2. カレントディレクトリ配下に `terraform.tfvars` ファイルを作成し、以下のように定義します。
    ```bash
    nr_account_id  = 1234567                                    # NewRelicアカウントID, 数値型
    nr_api_key     = "NRAK-XXXXXXXXXXXXXXXXXXXXXXXXXXX"         # Type:USERのAPIキー
    nr_license_key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXFFFFNRAL" # Type:Licenseキー
    ```
3. `backend.cfg` 内の `bucket` 変数を変更します。設定内容についてはファイル内のコメントを参照してください。
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

aws テンプレートについては、CircleCI での terraform 実行に対応しています。  
事前に以下の内容で Contexts を作成してください。
```
Contexts 名は CircleCI の Organization で一意である必要があるため、適宜変更してください。
ここで作成した Contexts を .circleci/config.yml に設定します。
```

1. CircleCI の Organization Settings で Contexts を作成します。
    | Contexts 名（例） | 説明 |
    | ---- | ---- |
    | eg-newrelic-template | サンプル環境用の Contexts |
2. 作成した Contexts に以下の環境変数を作成します。
    | 環境変数名 | 説明 |
    | ---- | ---- |
    | AWS_ACCESS_KEY_ID | 操作対象とする AWS アカウントの AWS アクセスキー ID |
    | AWS_SECRET_ACCESS_KEY | 操作対象とする AWS アカウントの AWS シークレットアクセスキー |
    | AWS_DEFAULT_REGION | 操作対象とする AWS アカウントのリージョンコード |
    | NEWRELIC_ACCOUNT_ID | 操作対象とする NewRelic のアカウント ID |
    | NEWRELIC_API_KEY | 操作対象とする NewRelic の API キー（Type:USER） |
    | NEWRELIC_LICENSE_KEY | 操作対象とする NewRelic の API キー（Type:License） |

コード内の各種設定内容については、【[手作業](../aws/README.md#手作業)】を参照してください。

また、config.yml 内の workflows においては、必要に応じて filters 等を用いて実行を制御してください。
