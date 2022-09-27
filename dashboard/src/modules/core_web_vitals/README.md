# モジュールの説明

本モジュールで作成されるダッシュボードは以下の通りです。

## core_web_vitals

Core Web Vitals を可視化します。  
Core Web Vitals については、https://web.dev/i18n/ja/vitals/ を参照してください。

![core_web_vitals](../../../attached-file/dashboard_core_web_vitals.png)

# 事前準備

## core_web_vitals

Browser が設定されており、`FROM PageViewTiming SELECT count(*)` でクエリ結果が正常に出力されることを確認してください。

https://docs.newrelic.com/jp/docs/browser/browser-monitoring/getting-started/introduction-browser-monitoring/
