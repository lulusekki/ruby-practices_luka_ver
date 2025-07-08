## 学習を進める上でのメモ

- プラクティス単位でブランチをmainから作成する
```
fizzbuzzのプラクティスならならば以下
$ git checkout -b my-fizzbuzz main
```
- 各プラクティスの提出物ファイルを該当のディレクトリの中に作成してください。
- ソースコードが完成したら、提出前にrubocopを実行し、警告の箇所を修正してください。(ただし、fizzbuzz、calendar、rakeの提出時は不要です)

```
# bowlingのディレクトリに配置したファイルをrubocopで確認する例
# 設定ファイルとして、ルートディレクトリにある .rubocop.yml が使用されます。
$ cd ruby-practices/04.bowling
$ rubocop
```

- Pull Requestを作成し、merge先は自分のリポジトリを指定する
  - **作成したPull Requestは提出後に確認OKをもらうまでmergeのボタンを押さないでください。**
![Pull Request作成画面](https://user-images.githubusercontent.com/2603449/99864665-0c145c00-2be8-11eb-8501-14bd484529f2.png)

<details><summary>注意点</summary>

# 注意点

- [プルリクエスト形式で提出物を出す際の「これはやっちゃダメ」リスト](https://bootcamp.fjord.jp/pages/317)、[GitHubでコードを提出するときに気をつけること](https://bootcamp.fjord.jp/pages/info-for-github)を一読してください。
- 基本的に、1課題につきPull Requestは1つとします。
- もし、誤って1つのPull Request内に複数の課題の内容を含めてしまった時、修正する方法がわからない場合は、一度リポジトリ自体を消してForkからやり直してください。

</details>

## 学習する上での確認点
- プルリク作成時に自分のプルリク(compare branch)がbase repository(ruby-practices_luka_ver)に向かっているか確認する
  - デフォルトでは、自分のプルリク(compare branch)がbase repository(fjordllc/ruby-practices)に向かっている
  - ミスらないように、デフォルトを変更したいけど、githubの仕様で変更できないっぽい