# Terraform template for NewRelic

## このリポジトリについて

このリポジトリは、Terraform 実行により NewRelic の各種設定を行うためのテンプレート集です。  
本リポジトリ内のテンプレートを使用することで、以下の NewRelic 設定を行うことが出来ます。

- Alert ･･･ NewRelic Alert の設定を行います
- Dashboard ･･･ NewRelic Dashboard の作成を行います
- AWS ･･･ NewRelic に関係する AWS リソースの作成を行います

各テンプレートの説明については、各テンプレート内の README.md を参照してください。

## 事前準備

### 各種アカウントの用意

AWS アカウントは発行済みであるものとします。

NewRelic アカウントが未取得の場合は、作成申請を行ってください。
```
https://confl.arms.dmm.com/pages/viewpage.action?pageId=947665682  
Q. アカウントの開設／閉鎖をするにはどうしたら良いですか
```

### Terraform 実行用 IAM ユーザーの確認

terraform 実行用の IAM ユーザーが存在することを確認してください。  
通常であれば、AWS アカウント発行時に既に TerraformUser というユーザーが作成されています。  
存在しない場合は、以下の内容で IAM ユーザーを作成してください。
* ユーザー名：任意のユーザー名
* AWS 認証情報タイプ：アクセスキー - プログラムによるアクセス
* グループ：Infrastructures

### AWS プロファイルの確認

terraform 実行用の AWS プロファイルが作成されていることを確認してください。  
作成していない場合は、以下の内容でプロファイルを作成してください。  
※プロファイル名の `terraform` は例です。

1. AWS 認証情報ファイルの作成を行います。（作成例）
    ```bash
    $ aws configure --profile terraform
    AWS Access Key ID [None]: ********
    AWS Secret Access Key [None]: ************************
    Default region name [None]: ap-northeast-1
    Default output format [None]: json
    ```

### tfstate 管理用の S3 バケット作成

tfstate の管理には S3 を使用しています。  
tfstate 管理用の S3 バケットが存在することを確認してください。  
通常であれば、AWS アカウント発行時に既に `123456789012-tfstate` といった S3 バケットが作成されています。  
存在しない場合は、任意の環境で以下のコマンドを実行し S3 バケットを作成してください。

なお、aws configure で `terraform` というプロファイル名の AWS 認証情報が作成済みであるものとします。  
※`terraform` は例です。

1. AWS 認証情報の読み込み
    ```bash
    $ export AWS_PROFILE=terraform
    ```
2. 変数定義
    ```bash
    $ AWS_ACCOUNT_ID=`aws sts get-caller-identity --query 'Account' --output text`; echo $AWS_ACCOUNT_ID
    $ BUCKET_NAME="${AWS_ACCOUNT_ID}-tfstate"; echo $BUCKET_NAME
    ```
3. バケット作成
    ```bash
    $ aws s3api create-bucket \
      --create-bucket-configuration LocationConstraint=ap-northeast-1 \
      --bucket ${BUCKET_NAME}
    ```
4. パブリックアクセスブロック
    ```bash
    $ aws s3api put-public-access-block \
      --bucket ${BUCKET_NAME} \
      --public-access-block-configuration \
      '{
      "BlockPublicAcls": true,
      "IgnorePublicAcls": true,
      "BlockPublicPolicy": true,
      "RestrictPublicBuckets": true
      }'
    ```
5. バージョニング有効化
    ```bash
    $ aws s3api put-bucket-versioning \
      --bucket ${BUCKET_NAME} \
      --versioning-configuration Status=Enabled
    ```
6. 暗号化
    ```bash
    $ aws s3api put-bucket-encryption \
      --bucket ${BUCKET_NAME} \
      --server-side-encryption-configuration \
      '{
        "Rules": [
          {
            "ApplyServerSideEncryptionByDefault": {
              "SSEAlgorithm": "AES256"
            }
          }
        ]
      }'
    ```
