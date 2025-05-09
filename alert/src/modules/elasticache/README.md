# モジュールの説明

本モジュールで作成されるアラートは以下の通りです。

## Amazon ElastiCache

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
