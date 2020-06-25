# This is a Bazel + Gazelle + Go + AWS + Terraform test

This project works perfectly with `Goland` + `Intellij Bazel plugin` <3

When adding/updating/removing a go module:
 - Update the go repositories with ``bazel run //:gazelle -- update-repos -from_file=go.mod -prune``
 - Update the BUILD dependencies with ``bazel run //:gazelle -- update``

To test the project, in the `prometer-hello-world` directory, run `./build_and_deploy.sh`.
Don't forget to run `terraform destroy -auto-approve` to clean up everything.
