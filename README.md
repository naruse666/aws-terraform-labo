# aws-terraform-labo
# 目的
awsの各サービスの練習や検証用のリポジトリ。(terraformの練習も兼ねて:book:)

# apply方法
```terrform apply -var-file=vars.tfvars```で実行できる様にvars.tfvarsに変数をまとめる。

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
