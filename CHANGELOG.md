# CHANGELOG

## Unreleased

## Released

### 2022/11/28

Alert テンプレート

- その他
  - Email 通知の destination 名を変更できるように修正

Dashboard テンプレート

- その他
  - 料金ダッシュボードの為替レートとデータ料金単価を修正
  - ダッシュボードの管理を JSON に変更

### 2022/11/24

Alert テンプレート

- その他
  - Terraform アップデート
    - 1.1.9 → 1.3.5

AWS テンプレート

- その他
  - Terraform アップデート
    - 1.1.9 → 1.3.5

Dashboard テンプレート

- その他
  - Terraform アップデート
    - 1.1.9 → 1.3.5

### 2022/11/23

AWS テンプレート

- 新機能
  - CircleCI で実行できるようにした。

### 2022/11/22

Alert テンプレート

- その他
  - Terraform AWS プロバイダのアップデート
    - 4.32.0 → 4.40.0
  - Terraform NewRelic プロバイダのアップデート
    - 3.2.0 → 3.7.0

AWS テンプレート

- 新機能
  - メトリクスストリームの設定を任意のリージョンに対して設定できるようにした。

- その他
  - Terraform AWS プロバイダのアップデート
    - 4.32.0 → 4.40.0
  - Terraform NewRelic プロバイダのアップデート
    - 3.2.0 → 3.7.0
  - Terraform Time プロバイダのアップデート
    - 0.8.0 → 0.9.0

Dashboard テンプレート

- その他
  - Terraform NewRelic プロバイダのアップデート
    - 3.2.0 → 3.7.0

### 2022/10/12

Alert テンプレート

- 新機能
  - 通知方法を Notification Channel から Workflow/Destinations へ変更
    - [アラートとAI機能に関する大規模変更について | New Relic](https://newrelic.com/jp/blog/nerdlog/bignewsforalertsandappliedintelligence)

### 2022/09/30

Alert テンプレート

- その他
  - Slack メンションについて here や channel に対応

### 2022/09/24

Alert テンプレート

- その他
  - Terraform AWS プロバイダのアップデート
    - 4.14.0 → 4.32.0
  - Terraform NewRelic プロバイダのアップデート
    - 2.45.1 → 3.2.0

AWS テンプレート

- その他
  - Terraform AWS プロバイダのアップデート
    - 4.14.0 → 4.32.0

Dashboard テンプレート

- その他
  - Terraform NewRelic プロバイダのアップデート
    - 2.45.1 → 3.2.0

### 2022/09/23

AWS テンプレート

- 新機能
  - alert テンプレートにあった IAM ロールの作成モジュールを AWS リソース作成用のテンプレートに移動。
  - メトリクスストリームを使うためのリソース作成コードを作成。

### 2022/05/25

Alert テンプレート

- 新機能
  - Syntheticsのアラートを追加。
    | 監視項目 | 監視内容 |
    | -- | -- |
    | SyntheticCheck duration (Ping) | この要求の合計時間 (ミリ秒単位)。 |
    | SyntheticCheck duration (Simple Browser) | この要求の合計時間 (ミリ秒単位)。 |
    | SyntheticCheck result | FAILEDの発生を監視。 |

- その他
  - Syntheticsアラート
    - 一部アラートの説明コメントを追加。
    - 一部リソース名を変更。

Dashboard テンプレート

- その他
  - コードのモジュール化を行った。

### 2022/05/23

Alert テンプレート

- その他
  - deprecatedとなっていたvalue_functionを削除。
  - Syntheticsアラート
    - 監視名を変更。
    - サンプル設定値を変更。
  - 一部リソース名を変更。
  - 一部アラートの説明コメントを追加。
  - 一部アラートのコメントを修正。

### 2022/05/20

Alert テンプレート

- 新機能
  - RDS/Auroraのアラートを追加。
    | 監視項目 | 監視内容 |
    | -- | -- |
    | CPUUtilization (RDS/Aurora) | CPU 使用率。 |
    | FreeableMemory (RDS/Aurora) | 使用可能な RAM の容量。 |
    | FreeLocalStorage (RDS/Aurora) | 使用できるローカルストレージスペースの量。マルチ AZ の DB クラスターにのみ適用されます。 (RDS)<br>使用できるローカルストレージの量。 (Aurora) |
    | DatabaseConnections (RDS/Aurora) | データベースインスタンスへのクライアントネットワーク接続の数。 |
    | BlockedTransactions (Aurora) | 1 秒あたりのブロックされたデータベース内のトランザクションの平均数。 |
    | Deadlocks (Aurora) | 1 秒あたりのデータベース内のデッドロックの平均回数。 |
    | FreeStorageSpace (RDS) | 使用可能なストレージ領域の容量。 |
    | SwapUsage (RDS) | DB インスタンスで使用するスワップ領域の量。 |
  - APMのアラートを追加。
    | 監視内容 |
    | -- |
    | APMのサーバー側レスポンスタイム監視。95パーセンタイル。（秒） |
    | APMのデータベース側レスポンスタイム監視。95パーセンタイル。（秒） |
    | APMの外部サービス側レスポンスタイム監視。（秒） |
    | APMの5xxエラー率監視。 |

- その他
  - Aurora死活監視を削除。
    - aws.rds.statusが正常機能しないため。加えて、最適なものが見つからないため。
  - RDS/AuroraアラートのFACETを変更。
    - RDS固有: entityName → DBInstanceIdentifier
    - RDS/Aurora: entityName → aws.rds.DBClusterIdentifier, aws.rds.DBInstanceIdentifier
  - コンディション名をユーザーフレンドリーなものに変更。
  - 不要コメント、不要変数の削除。
  - 各アラートの説明コメントを追加。
  - RDS/Auroraアラートにおいてtagsでのフィルタリングを廃止。

### 2022/05/18

Alert テンプレート

- その他
  - New Relic Providerのアップデートを実施。
    - 2.43.4 → 2.45.1
  - AWS Providerのアップデートを実施。
    - 3.58.0 → 4.14.0

Dashboard テンプレート

- 新機能
  - 以下のダッシュボードを作成。
    | モジュール名 | ダッシュボード名 | 用途 |
    | -- | -- | -- |
    | aws_newrelic_charge | 料金 | AWS と NewRelic の料金推移を可視化する。 |
    | core_web_vitals | Core Web Vitals | Core Web Vitals を可視化する。 |
    | circleci | CircleCI | CircleCI の実行状況を可視化する。 |

### 2022/05/13

Alert テンプレート

- 新機能
  - NAT Gatewayのアラートを追加。
    | 監視項目 | 監視内容 |
    | -- | -- |
    | PacketsDropCount | NAT ゲートウェイによって破棄されたパケットの数。 |
    | ErrorPortAllocation | NAT ゲートウェイが送信元ポートを割り当てられなかった回数。 |
  - EC2のアラートを追加。
    | 監視項目 | 監視内容 |
    | -- | -- |
    | diskUsedPercent | 累積ディスク使用率の割合。 |
    | inodesUsedPercent | i ノード使用率の割合。 |
  - ECSのアラートを追加。
    | 監視項目 | 監視内容 |
    | -- | -- |
    | CPUUtilization | CPU使用率。 |
    | MemoryUtilization | メモリ使用率。 |
    | RunningTaskPercent | タスク正常率。 |
    | RunningTaskCount | 現在、RUNNING 状態にあるタスクの数。 |

- バグフィックス
  - ec2_timesyncのFACETが効いていなかったため修正。
    - aws.ec2.instanceId → entityKey

- その他
  - コンディション名をユーザーフレンドリーなものに変更。
  - EC2アラートのFACETにtags.Nameを追加。
  - 不要コメント、不要変数の削除。
  - 各アラートの説明コメントを追加。
  - EC2アラートにおいてtagsでのフィルタリングを廃止。

### 2022/05/11

Alert テンプレート

- 新機能
  - ElastiCacheのアラートを追加。
    | 監視項目 | 監視内容 |
    | -- | -- |
    | Evictions (Memcached/Redis) | 新しく書き込むための領域を確保するためにキャッシュが排除した、期限切れではない項目の数。 (Memcached)<br>maxmemory の制限のため排除されたキーの数。 (Redis) |
    | CurrConnections (Memcached/Redis) | 特定の時点でキャッシュに接続された接続回数。 (Memcached)<br>リードレプリカからの接続を除く、クライアント接続の数。 (Redis) |
    | EngineCPUUtilization (Redis) | Redis エンジンスレッドの CPU 使用率を提供します。 |
    | ReplicationLag (Redis) | レプリカのプライマリノードからの変更適用の進行状況を秒で表します。Redis エンジンバージョン 5.0.6 以降では、ラグはミリ秒単位で測定できます。 |
    | DatabaseMemoryUsagePercentage (Redis) | 使用中のクラスターで使用中のメモリの割合。 |
  - ELBのアラートを追加。
    | 監視項目 | 監視内容 |
    | -- | -- |
    | HTTPCode_ELB_5XX_Count (ALB) | ロードバランサーから送信される HTTP 5XX サーバーエラーコードの数。 |
    | RejectedConnectionCount (ALB) | ロードバランサーが接続の最大数に達したため、拒否された接続の数。 |
    | HTTPCode_Target_5XX_Count (ALB) | ターゲットによって生成された HTTP 5XX 応答コードの数。 |
    | TargetConnectionErrorCount (ALB) | ロードバランサーとターゲット間で正常に確立されなかった接続数。 |
    | UnHealthyHostCount (ALB) | 異常と見なされるターゲットの数。 |
    | PortAllocationErrorCount (NLB) | クライアント IP 変換操作中の一時ポート割り当てエラーの総数。 |
    | UnHealthyHostCount (NLB) | 異常と見なされるターゲットの数。 |

- その他
  - New Relic Providerのアップデートを実施。
    - 2.34.1 → 2.43.4
  - aws.elasticache.FreeableMemory監視のしきい値を変更。
    - 300バイト → 300メガバイト
  - コンディション名をユーザーフレンドリーなものに変更。
  - 不要コメント、不要変数を削除。
  - 一部リソース名を変更。
  - 各アラートの説明コメントを追加。
