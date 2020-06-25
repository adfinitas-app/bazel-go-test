bazel build --platforms=@io_bazel_rules_go//go/toolchain:linux_amd64 //prometer-hello-world:bin &&
  terraform apply -auto-approve
