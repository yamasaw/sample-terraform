# sample-terraform
Terraformを利用してAWSのインフラを構築するコマンド群をお試しに作成しました。  

AWS CLIを動作させるので .aws/credentialsに `terraform` の認証情報を追加する必要があります。  

本リポジトリ内ではサンプルようであるため、デプロイされているインフラストラクチャーの実態を管理している`terraform.tfstate`をgitignoreに含めています。  
プロジェクトで利用する場合は、gitignoreから削除することをお勧めします(インフラの実態がローカル環境で完結してしますため、環境毎でインフラの実態の一致ができないため)  
`terraform.tfstate`にはリソース名などインフラのそれなりにセキュアな情報が記載されているため、gitignoreから削除したプロジェクトはprivateで管理した方がいいです。

# 実行環境
![Terraform is 1.3.7](https://img.shields.io/badge/Terraform-1.3.7-blueviolet)

# Usage
## Installation
### Terraformのインストール
`tfenv`を利用してインストールを行います
```
brew install tfenv
tfenv install 1.3.7
```

### .variables.tfの複製しvariables.tfを作成
ファイル内に定義されている変数に値を定義していく

### Terraformの初期化実行環境の構築(*初回のみ)
```
terraform init
```

## Terraformの実行インフラ環境の構築
### コードからどの様にインフラを構築するか計画を
*実行を保証するものではない。Terraform以外の操作が行われたリソースがインフラに含まれる場合は実行時にエラーとなる場合がある
```
terraform plan
```

### Terraformの実行インフラ環境の構築
```
terraform apply
```

# このPRの構成

# 参照
AWSのプロバイダーを利用した設定は以下のサイト利用すると良い(たまに情報が古いものがある)
https://registry.terraform.io/providers/hashicorp/aws/latest/docs
プロバイダーはOpen SourceであるためGitHubに公開されています。わからない事があった場合ここで調べるのが情報の鮮度としても良い感じです
https://github.com/hashicorp/terraform-provider-aws
