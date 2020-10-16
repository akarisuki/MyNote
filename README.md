# [MyNote](https://mynote.world/)

# アプリ概要
就職活動用のポートフォリオとして開発した個人アプリです。
人見知りの人に改善する方法を提案したり、独自のタグをつけて意見の投稿ができるアプリです。

- ユーザー登録することで記事を投稿・編集・削除できる
- 投稿に対していいね、コメント、寄付で反応ができる機能を実装
- ユーザー間のコミュニケーションを促すために、フォロー・通知・DM機能を実装

# 本番環境
https://mynote.world/

ゲストユーザーとしてログインすることができます。

# このアプリを開発した背景
**「変わるきっかけ」を作れたら、と言う想いでこちらのアプリを開発しました。**

私は1年前会話がとても苦手で、いわゆる人見知りでした。
変わりたいと思っても何をしていいか分からず行動できませんでした。

そんな時に、[Noteというプラットフォーム](https://note.com/)を知り、元人見知りの人が改善した方法をまとめた投稿を見つけました。
私は「これだ！」と直感して、その人の方法を実践した結果、自分の性格がみるみる変わっていくのを実感しました。

人見知りを改善したことで **新しいことに臆せず挑戦できるようになったり、初対面の人とコミュニケーションを取るのが楽しい！** と思うようになりました。
そして、**自分に自信がついたことと自己肯定感が上がり、人生の満足度が格段に上がりました。**

ですので、今度は自分と同じ人見知りを改善したいと思ってる人に、**変わるきっかけ**を作れたら、と思います。

# 実際のアプリの動画
![sample](https://user-images.githubusercontent.com/61116343/86710699-35c45080-c056-11ea-9b3d-47b2d922ed63.gif)
![ttt](https://user-images.githubusercontent.com/61116343/86717276-fbaa7d00-c05c-11ea-85f5-b7b1b1a2f585.gif)

# 工夫した部分

## N+1問題を解消し、処理時間を大幅に短縮させたこと
トップページの読み込みに **3秒以上かかっており、ユーザーが利用した時に非常に不便**だと感じていました。

原因を調べるためにターミナルでログを確認したところ、N+1問題が発生していることが分かりました。
対策方法を考え、bulletというN+1問題を検知するgemがあることを知り、こちらを使用して問題のソースコードを特定しました。

Railsのincludesメソッドを使用し、不要なSQL文を発行しないようにして、JOINで一括に取得するように修正しました。

 **結果的に、今までは読み込みに3秒かかっていたものが、1秒に短縮することができました。**


# 特に見てほしい点

- 開発の過程をQiitaに投稿していたこと。
    - 各機能の実装方法や解説をまとめていました。
    - **実装して終わり**ではなく、ドキュメント化することで **記憶ではなく記録に残ります。** このようにドキュメンテーション力を活かして知識を積み上げていけることが私の強みです。
    - また、誰かに教えることを想定して記事を書くには自分の言葉で噛み砕く必要があり、その結果より深く理解することができます。
    - [Rails フォロー機能を非同期で実装](https://qiita.com/kaito_program/items/383820a6b2596e7be363)
    - [Rails DM機能と非同期でメッセージの送受信を実装する方法](https://qiita.com/kaito_program/items/caea319dd44f55c15aa6)
    - [Railsでいいね機能を非同期で実装](https://qiita.com/kaito_program/items/c486354196e67b5d11e0)
    - [コメント機能の非同期通信](https://qiita.com/kaito_program/items/ef348e170c64d224dd06)

- CircleCIを導入してCI/CDパイプラインを構築
    - **CircleCIを導入しただけで終わり**ではなく、最大限活用するために静的解析ツールRubocopの導入と、RSpecを使用してテストコードを100件以上作成しました。この結果、何らかの問題があった場合はすぐに発覚することで、**アプリの品質が担保されていることを実感しています。**
    - CircleCIが実行されるとcapistranoが走り自動デプロイされることで、デプロイコマンドを打ち忘れるというヒューマンエラーを仕組み化で解決しました。こういった**人の作業が自動化されることにプログラミングの面白さや可能性を感じます。**
    

# 苦労したこと

## 寄付機能の実装
ネット上に参考文献が一切なく、自力で実装していく必要がありました。

なので、今まで得た知識や経験の応用をきかせて、**どうすれば実装できるか考え込んで設計・開発・テストを行いました。**

具体的な方法は、下記になります。
- 1．必要な機能や要件をまとめて明確にする。
- 2．データ処理の流れを考えて、適切なDBの設計を行う。
- 3．使用できそうなメソッドを公式ドキュメントで調べて、実装する。
- 4．想定通りの動作することを確認するために、テストコードを書く。

この経験から、誰も解いたことがない問題に対して、自ら問題を定義して解決するための試行錯誤をすることができ、やり遂げる経験を得ました。

## AWSへデプロイ時のUnicornの設定。
Rails側の記述忘れでアプリケーションサーバのUnicornが起動できない、またはパスの指定が間違っており「Unicorn.sockファイルはありません」というエラーに悩まされました。

解決方法としては、しっかりとエラーログを確認して原因を推察し、解決する仮説を立てて一つずつ検証していきます。

例えば、パスの指定が間違っているなら、ディレクトリを確認することはもちろん、他のアプリを参考にしたり、関連する箇所がないかを探していきました。

原因が推察できなければ、第一に公式ドキュメントを読み、その後Qiitaや質問サイトなどで情報を収集し、原因を特定していきました。

そして、エラーを解決したら、原因と解決方法をまとめてQiitaやTwitterに投稿してアウトプットとドキュメント化しました。
そうすることで、似たエラーに遭遇した際は、「あの時はどうやって解決したか」をすぐに思い出すことができて、問題解決までに必要な時間を短縮することができます。

実際に投稿した記事：[【Unicorn】master failed to start, check stderr log for detailsの解決法](https://qiita.com/kaito_program/items/eee9e74df44728b640b1)

細かいなミスで発生したエラーでも原因が特定できないと、解決にかなり時間がかかってしまうことを実感して、エラーログをしっかりと確認することを徹底しています。



# アプリのポイント
- **RSpecを使用して、テストコード数が100件以上あります**
- 静的解析ツールRubocopを導入してコードの品質を担保
- 徹底的なリファクタリング
- 管理者機能を導入して本番運用を意識
- タグ入力時に自動補完機能を導入
- 実際にアプリを使ってもらい、フィードバックを受けて改善
- 完全に独学で開発
- 主要機能を非同期通信で
- 直感的に分かるデザインにする
- 開発環境でDockerを採用していること

# 今後実装したい機能
* Vue.jsを導入してSPA化をすることで更にUXを向上
* パンくず機能の実装
* AWSのECSやECRを使った本番環境のコンテナ化
* 通知機能の範囲の拡大
* 画像の複数投稿対応
* タグ登録時の利便性向上

# 使用技術等
* マークアップ：haml、Sass
* バックエンド：Ruby 2.5（Ruby on Rails 5.2）
* テスト：RSpec
* フロントエンド：JavaScript（jQuery）
* データベース：MySQL 5.6
* インフラ：AWS（VPC | ALB | EC2 | S3 | Route53 | ACM）
* ソースコード管理：GitHub
* Webサーバ：Nginx（本番環境）
* アプリケーションサーバ：Puma（開発環境）、Unicorn（本番環境）
* 開発環境：Docker　Nginx、Rails、MySQLコンテナを用意して、docker-composeで起動します。
* CI/CD：CircleCI 
    * CI：プルリク発行時にrubucopとRSpecが自動で実行されます。
    * CD：GitHubのマスターブランチにマージされた時のみcapistranoが実行して自動デプロイされます。

# AWS構成図
![MyNote AWS構成図](https://user-images.githubusercontent.com/61116343/95417165-4b0b8c80-096f-11eb-9d50-ed260078dc87.png)

# 機能一覧
- ユーザー機能
- 管理者権限
- 記事機能
- タグ付け機能
- 寄付機能
- コメント機能
- いいね機能
- フォロー機能
- ページネーション機能
- 検索機能
- ダイレクトメッセージ機能
- 通知機能
- 活動履歴の保存機能

# 機能詳細
## ユーザー機能
  - deviseを使用
  - 新規登録、ログイン、ログアウト、編集機能
  - かんたんログイン機能
  - 管理者ユーザー機能
  - ユーザーの一覧表示
  
## 管理者権限
  - 権限を持ったユーザーは、不快な記事やコメントを削除できる

## 記事機能
  - 記事一覧表示、記事詳細表示、記事投稿、記事編集、記事削除機能
  - 画像のアップロードはcarrierwaveというgemを使用
  - プレビュー機能
  - マークダウン記法対応

## ページネーション機能
  - kaminariというgemを使用

## タグ付け機能
  - acts_as_taggableというgemと、jQueryプラグインのtag-itを使用
  - 記事に複数のタグをつけられる機能
  - タグ名は自由に入力可能
  - 入力時に自動補完機能付き（gonというgemを使用）

## 寄付機能（非同期）
  - 記事に数字を入力して寄付ができる機能

## コメント機能（非同期）
  - 記事ごとのコメント表示、コメント投稿、コメント編集、コメント削除機能

## いいね機能（非同期）
  - 記事にいいねした人の一覧表示
  - ユーザーがいいねした記事の一覧表示
  - 人気順表示機能

## フォロー機能（非同期）
  - フォロー、フォロワー一覧表示機能
  - タイムライン機能

## 検索機能
  - 投稿記事の内容を検索
  - タイトルと本文の曖昧検索

## ダイレクトメッセージ機能
  - 1：1のチャットルームを作成
  - メッセージ送信、メッセージ削除機能（非同期）

## 通知機能
  - いいね、コメント、フォロー、ダイレクトメッセージを受信したら通知
  - 未読通知があるとお知らせを表示

## 活動履歴の保存機能
  - いいね、コメント、フォロー、ダイレクトメッセージを送信した履歴を確認可能

## テスト機能
  - RSpecを使用（テスト件数は100以上）


# 使用した主なgem
* devise ：ユーザーログイン機能
* kaminari ：ページネーション機能
* carrierwave：画像投稿
* act-as-taggalbe-on：タグ機能
* gon：タグ入力時の自動補完機能
* redcarpet：マークアップ記法の導入
* rspec-rails ：テストコード
* factory_bot_rails ：テストデータ作成
* faker ：ダミーデータ作成


# DB設計
<img width="1241" alt="70f4485f173d3d889da434b5ce52faf7" src="https://user-images.githubusercontent.com/61116343/85198895-cc8ad080-b326-11ea-9f81-68be47d1f8a9.png">




