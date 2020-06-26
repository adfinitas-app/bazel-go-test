bazel build --platforms=@io_bazel_rules_go//go/toolchain:linux_amd64 //prometer-hello-world:lambda_deploy &&
  terraform apply -auto-approve
