""" TensorFlow Http Archive

Modified http_arhive that allows us to override the TensorFlow commit that is
downloaded by setting an environment variable. This override is to be used for
testing purposes.

Add the following to your Bazel build command in order to override the
TensorFlow revision.

build: --action_env TF_REVISION="<git commit hash>"

  * `TF_REVISION`: tensorflow revision override (git commit hash)
"""

_TF_REVISION = "TF_REVISION"

def _tensorflow_http_archive(ctx):
  git_commit = ctx.attr.git_commit
  sha256 = ctx.attr.sha256

  override_git_commit = ctx.os.environ.get(_TF_REVISION)
  if override_git_commit:
    sha256 = ""
    git_commit = override_git_commit

  strip_prefix = "tensorflow-%s" % git_commit
  urls = [
      "https://mirror.bazel.build/github.com/tensorflow/tensorflow/archive/%s.tar.gz" % git_commit,
      "https://github.com/zoumingithub/serving/raw/min_fix/files/tensorflow-d444f280eb8cebf886069a00f6bb02db05c6e723.tar.gz",
  ]
  ctx.download_and_extract(
      urls,
      "",
      sha256,
      "",
      strip_prefix)

tensorflow_http_archive = repository_rule(
    implementation=_tensorflow_http_archive,
    attrs={
        "git_commit": attr.string(mandatory=True),
        "sha256": attr.string(mandatory=True),
    })
