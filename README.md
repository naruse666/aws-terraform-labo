![last-commit](https://img.shields.io/github/gist/last-commit/bbc0253b337fc35cb7594035d9dad0cb) ![commit-activity](https://img.shields.io/github/commit-activity/m/naruse666/aws-terraform-labo) ![issues-pr-closed](https://img.shields.io/github/issues-pr-closed/naruse666/aws-terraform-labo) ![repo-size](https://img.shields.io/github/repo-size/naruse666/aws-terraform-labo)

# aws-terraform-labo
# 目的
awsの各サービスの練習や検証用のリポジトリ。(terraformの練習も兼ねて:book:)
## 内容
よく見る構成の復習や業務で気になったことを検証するサンドボックス的運用を行う。コスト削減のため、使い終わったら```terraform destroy```を実行。  
PR作成時に```terraform plan```を実行してデグレーションを検査。(applyはしない。)

# ファイル階層
無難な感じで。
```
/
|_env/
  |_ec2test/
    |_ec2.tf
  |_hoge/
    |_hoge.tf
|
|_modules/
  |_ec2/
    |_main.tf
    |_output.tf
    |_variable.tf
```
