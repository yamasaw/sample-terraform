# sample-terraform
Terraformを利用してAWSのインフラを構築するコマンド群をお試しに作成しました。  

AWS CLIを動作させるので .aws/credentialsに `terraform` の認証情報を追加する必要があります。  

本リポジトリではサンプル用のため、デプロイされるインフラの実態の`terraform.tfstate`をgitignoreに含めています。  
利用する場合は、gitignoreから削除をお勧めします(インフラの実態がローカル環境で完結するため、環境毎でインフラの実態の一致ができない)  
`terraform.tfstate`にはリソース名などインフラのそれなりにセキュアな情報が記載されています。

# 実行環境
![Terraform is 1.3.7](https://img.shields.io/badge/Terraform-1.3.7-blueviolet)

# Installation
## Terraformのインストール
`tfenv`を利用してインストールを行います
```
brew install tfenv
tfenv install 1.3.7
```

# Usage
コマンドの実行は、構築したいインフラをカレントディレクトリに指定して実行を行なってください

## .variables.tfの複製しvariables.tfを作成(初回のみ)
ファイル内に定義されている変数に値を定義していく

## Terraformの初期化実行環境の構築(初回のみ)
```
terraform init
```

# Terraformの実行インフラ環境の構築
## コードからどの様にインフラを構築するか計画を
*実行を保証するものではない。Terraform以外の操作が行われたリソースがインフラに含まれる場合は実行時にエラーとなる場合がある
```
terraform plan
```

## Terraformの実行インフラ環境の構築
```
terraform apply
```

## 構築したインフラの破棄
```
terraform destory
```

# このPRの構成
```
/
├ front/ # CloudFront + S3の環境を構築。指定したドメインで静的コンテンツを配布できる環境を作成する
│
└ README.md
```

# 参照
AWSのプロバイダーを利用した設定は以下のサイト利用すると良い(たまに情報が古いものがある)
https://registry.terraform.io/providers/hashicorp/aws/latest/docs

プロバイダーはOpen SourceであるためGitHubに公開されています。わからない事があった場合ここで調べるのが情報の鮮度としても良い感じです
https://github.com/hashicorp/terraform-provider-aws
