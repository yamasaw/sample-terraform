# sample-terraform
Terraformを動作させるためのお試し用のコマンド

AWS CLIを動作させるので .aws/credentialsに `sample-terraform` の認証情報を追加する必要がある

# 実行方法
## .variables.tfの複製しvariables.tfを作成
ファイル内に定義されている変数に値を定義していく

## Terraformの初期化実行環境の構築(*初回のみ)
```
terraform init
```

## Terraformの実行インフラ環境の構築
```
terraform apply
```
