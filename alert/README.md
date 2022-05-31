# Terraform template for NewRelic Alert

## このツールについて

Terraform による NewRelic への AWS 監視導入のためのテンプレートです。  
最小限の設定で NewRelic を用いた監視を始めることが出来ます。

## リリースノート

リリースノートについては、[コンフルエンス](https://confl.arms.dmm.com/pages/viewpage.action?pageId=1090676546)を参照してください。

## アラートの説明

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

### AWS

#### CloudFront

| アラート名 | 説明 |
| ---- | ---- |
| [CloudFront] 4xx エラー率監視 | レスポンスの HTTP ステータスコードが 4xx であるすべてのビューワーリクエストの割合 (%)。 |
| [CloudFront] 5xx エラー率監視 | レスポンスの HTTP ステータスコードが 5xx であるすべてのビューワーリクエストの割合 (%)。 |
| [CloudFront] オリジン遅延監視 | CloudFront キャッシュではなくオリジンから送信されたリクエストについて、CloudFront がリクエストを受信してからネットワーク (ビューワーではなく) にレスポンスを提供し始めるまでに費やした合計時間 (ミリ秒単位)。 |

#### EC2

| アラート名 | 説明 |
| ---- | ---- |
| [EC2] CPU使用率監視 | 割り当てられた EC2 コンピュートユニットのうち、現在インスタンス上で使用されているものの比率。 |
| [EC2] ステータス監視 | インスタンスが過去 1 分間にインスタンスのステータスチェックとシステムステータスチェックの両方に合格したかどうかを報告します。 |
| [EC2] CPU I/O Wait監視 | 現在の CPU 使用率の部分は、I/O 待機時間の使用状況のみで構成されます。 |
| [EC2] ディスクI/O Wait監視 | 読み取りまたは書き込みディスク I/O 操作の待機に費やされた時間の割合。 |
| [EC2] ロードアベレージ監視 | 過去 5 分間に、CPU 時間を待機し、準備完了しているシステム・プロセス、スレッド、またはタスクの平均数。 |
| [EC2] 時刻同期監視 | 時刻同期のずれ。 |
| [EC2] メモリ使用率監視 | メモリ使用率。 |
| [EC2] ディスク使用率監視 | 累積ディスク使用率の割合。 |
| [EC2] iノード使用率監視 | i ノード使用率の割合。 |

#### ECS

| アラート名 | 説明 |
| ---- | ---- |
| [ECS] CPU使用率監視 | CPU使用率を算出。 |
| [ECS] メモリ使用率監視 | メモリ使用率を算出。 |
| [ECS] タスク正常率監視 | タスク正常率を算出。 |
| [ECS] タスク起動数監視 | 現在、RUNNING 状態にあるタスクの数。 |

#### ElastiCache

| アラート名 | 説明 |
| ---- | ---- |
| [ElastiCache] CPU使用率監視 | ホスト全体の CPU 使用率の割合 (%)。 |
| [ElastiCache] SWAP使用量監視 | ホストで使用されるスワップの量。 |
| [ElastiCache] 空きメモリ監視 | ホストで使用可能な空きメモリの量。 |
| [ElastiCache] 排除キー監視 | 新しく書き込むための領域を確保するためにキャッシュが排除した、期限切れではない項目の数。 (Memcached)<br>maxmemory の制限のため排除されたキーの数。 (Redis) |
| [ElastiCache] クライアント接続数監視 | 特定の時点でキャッシュに接続された接続回数。 (Memcached)<br>リードレプリカからの接続を除く、クライアント接続の数。 (Redis) |
| [ElastiCache] RedisスレッドCPU使用率監視 | Redis エンジンスレッドの CPU 使用率を提供します。 |
| [ElastiCache] Redisレプリケーションラグ監視 | レプリカのプライマリノードからの変更適用の進行状況を秒で表します。Redis エンジンバージョン 5.0.6 以降では、ラグはミリ秒単位で測定できます。 |
| [ElastiCache] Redisメモリ使用率監視 | 使用中のクラスターで使用中のメモリの割合。 |

#### ELB

| アラート名 | 説明 |
| ---- | ---- |
| [ALB] LB 5xx エラー数監視 | ロードバランサーから送信される HTTP 5XX サーバーエラーコードの数。 |
| [ALB] LB リクエスト拒否数監視 | ロードバランサーが接続の最大数に達したため、拒否された接続の数。 |
| [ALB] Target 5xx エラー数監視 | ターゲットによって生成された HTTP 5XX 応答コードの数。 |
| [ALB] Target 接続確立エラー数監視 | ロードバランサーとターゲット間で正常に確立されなかった接続数。 |
| [ALB] Target 異常数監視 | 異常と見なされるターゲットの数。 |
| [NLB] ポート割り当てエラー数監視 | クライアント IP 変換操作中の一時ポート割り当てエラーの総数。 |
| [NLB] Target 異常数監視 | 異常と見なされるターゲットの数。 |

#### NAT Gateway

| アラート名 | 説明 |
| ---- | ---- |
| [NAT Gateway] パケットドロップ監視 | NAT ゲートウェイによって破棄されたパケットの数。 |
| [NAT Gateway] ポート割り当てエラー監視 | NAT ゲートウェイが送信元ポートを割り当てられなかった回数。 |

#### RDS

| アラート名 | 説明 |
| ---- | ---- |
| [RDS] レプリカ同期遅延監視 | レプリカ遅延 (ミリ秒) |
| [Aurora] レプリカ同期遅延監視 | Aurora でのレプリカ遅延 (ミリ秒) |
| [RDS/Aurora] CPU使用率監視 | CPU 使用率。 |
| [RDS/Aurora] メモリ空き容量監視 | 使用可能な RAM の容量。 |
| [RDS/Aurora] ローカルストレージ空き容量監視 | 使用できるローカルストレージスペースの量。マルチ AZ の DB クラスターにのみ適用されます。 (RDS)<br>使用できるローカルストレージの量。 (Aurora) |
| [RDS/Aurora] データベース接続数監視 | データベースインスタンスへのクライアントネットワーク接続の数。 |
| [Aurora] ブロックトランザクション数監視 | 1 秒あたりのブロックされたデータベース内のトランザクションの平均数。 |
| [Aurora] デッドロック数監視 | 1 秒あたりのデータベース内のデッドロックの平均回数。 |
| [RDS] ストレージ空き容量監視 | 使用可能なストレージ領域の容量。 |
| [RDS] SWAP使用量監視 | DB インスタンスで使用するスワップ領域の量。 |

### NewRelic

#### APM

| アラート名 | 説明 |
| ---- | ---- |
| [APM] サーバー レスポンスタイム監視 | APMのサーバー側レスポンスタイム監視。95パーセンタイル。（秒） |
| [APM] データベース レスポンスタイム監視 | APMのデータベース側レスポンスタイム監視。95パーセンタイル。（秒） |
| [APM] 外部サービス レスポンスタイム監視（試験的） | APMの外部サービス側レスポンスタイム監視。（秒） |
| [APM] 5xx エラー率監視 | APMの5xxエラー率監視。 |

#### Synthetics

| アラート名 | 説明 |
| ---- | ---- |
| [Synthetics Ping] レスポンスタイム監視 | この要求の合計時間 (ミリ秒単位)。 |
| [Synthetics Simple Browser] レスポンスタイム監視 | この要求の合計時間 (ミリ秒単位)。 |
| [Synthetics Ping] FAILED監視 | FAILEDの発生を監視。 |

## 事前準備

### 各種アカウント

AWS アカウントは既に発行済みとします。  
NewRelic アカウントが未取得の場合は、作成申請を行ってください。  

https://confl.arms.dmm.com/pages/viewpage.action?pageId=947665682  
Q. アカウントの開設／閉鎖をするにはどうしたら良いですか

### AWS 認証情報

terraform 実行用の IAM ユーザーが存在することを確認してください。  
通常であれば、AWS アカウント発行時に既に TerraformUser というユーザーが作成されています。  
存在しない場合は、以下の内容で IAM ユーザーを作成してください。
* ユーザー名：任意のユーザー名
* AWS 認証情報タイプ：アクセスキー - プログラムによるアクセス
* グループ：Infrastructures

### Slack チャンネル

Slack にアラート通知を行うため、Slack チャンネルの作成と Slack の NewRelic インテグレーションの設定を行います。  
Slack の NewRelic インテグレーション設定については、以下のドキュメントを参照してください。  
https://docs.newrelic.com/jp/docs/alerts-applied-intelligence/new-relic-alerts/alert-notifications/notification-channels-control-where-send-alerts/#slack

### Amazon CloudWatch Metric Streams と NewRelic の統合

以下のドキュメントを参照し、AWS インテグレーションの設定を行います。  
https://newrelic.com/jp/blog/how-to-relic/aws-cloudwatch-metric-streams

### NewRelic Infrastructure エージェント

EC2 の監視を行う場合、以下のドキュメントを参照し EC2 インスタンスに NewRelic Infrastructure エージェントを導入します。  
https://docs.newrelic.com/jp/docs/infrastructure/infrastructure-monitoring/get-started/get-started-infrastructure-monitoring/#install

なお、一部の監視に [New Relic Flex](https://docs.newrelic.com/jp/docs/integrations/host-integrations/host-integrations-list/flex-integration-tool-build-your-own-integration/) を使用しています。  
Flex を有効にするために EC2 インスタンスの `/etc/newrelic-infra/integrations.d` 配下に [flex-dummy.yml](src/modules/ec2/flex-dummy.yml) をコピーしてください。

## 使い方

### 手作業

以下は手作業で terraform を実行する際の手順です。

※`alert/src/environments/example` にはサンプル設定が入っています。

1. AWS 認証情報ファイルの作成を行います。（作成例）
    ```bash
    $ aws configure --profile terraform
    AWS Access Key ID [None]: ********
    AWS Secret Access Key [None]: ************************
    Default region name [None]: ap-northeast-1
    Default output format [None]: json
    ```
2. ディレクトリを移動します。複数環境（STG/PROD）で設定を分ける場合は、それぞれのディレクトリ（staging, production）を使用してください。
    ```bash
    $ cd alert/src/environments/*****
    ```
3. `locals.tf` および `env.tf` 内の変数を設定します。設定内容についてはファイル内のコメントを参照してください。
4. `backend.cfg` 内の変数を設定します。設定内容についてはファイル内のコメントを参照してください。
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

### CircleCI

alert テンプレートについては、CircleCI での terraform 実行に対応しています。  
実行の前に以下の内容で Contexts の設定が必要となります。

1. CircleCI の Organization Settings で Contexts を作成します。
    | Contexts 名 | 説明 |
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

コード内の各種設定内容については、【[手作業](../alert/README.md#手作業)】を参照してください。

## 注意点

* AWS のタグは、NewRelic に反映されるまでタイムラグがあります。30分程度待ってから確認することをおすすめします。
* 同一の AWS アカウント内に複数のサブシステムがあり監視を切り分けたい場合、EC2 などではタグによるフィルターが可能です。  
  ただし、CloudFront や ElastiCache などではタグ情報が NewRelic に送られないため、タグによるフィルターを行うことが出来ません。
