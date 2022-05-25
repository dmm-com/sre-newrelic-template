# Terraform template for NewRelic

## このリポジトリについて

このリポジトリは、Terraform 実行により NewRelic の各種設定を行うためのテンプレート集です。  
本リポジトリ内のテンプレートを使用することで、以下の NewRelic 設定を行うことが出来ます。

- Alert
- Dashboard

各テンプレートの説明については、各テンプレート内の README.md を参照してください。

## 事前準備

tfstate の管理には S3 を使用しています。  
terraform を実行する前に任意の環境で以下のコマンドを実行し S3 バケットの作成を行ってください。

なお、コマンドの実行を行う前に AWS_PROFILE あるいは aws configure の設定が行われていることを確認してください。

**変数定義**
```bash
$ AWS_ACCOUNT_ID=`aws sts get-caller-identity --query 'Account' --output text`; echo $AWS_ACCOUNT_ID
$ BUCKET_NAME="${AWS_ACCOUNT_ID}-newrelic-tfstate"; echo $BUCKET_NAME
```

**バケット作成**
```bash
$ aws s3api create-bucket \
  --create-bucket-configuration LocationConstraint=ap-northeast-1 \
  --bucket ${BUCKET_NAME}
```

**パブリックアクセスブロック**
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

**バージョニング有効化**
```bash
$ aws s3api put-bucket-versioning \
  --bucket ${BUCKET_NAME} \
  --versioning-configuration Status=Enabled
```

**暗号化**
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
