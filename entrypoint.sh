#!/bin/sh -l

git_setup() {
  cat <<- EOF > $HOME/.netrc
		machine github.com
		login $GITHUB_ACTOR
		password $GITHUB_TOKEN
		machine api.github.com
		login $GITHUB_ACTOR
		password $GITHUB_TOKEN
EOF
  chmod 600 $HOME/.netrc

  git config --global user.email "$GITBOT_EMAIL"
  git config --global user.name "$GITHUB_ACTOR"
  git config --global --add safe.directory /github/workspace
}

git_cmd() {
  if [[ "${DRY_RUN:-false}" == "true" ]]; then
    echo $@
  else
    eval $@
  fi
}

git_setup

# if regex is empty then exit with error 
if [[ -z "${regex:-}" ]]; then
  echo "::error::non-empty regex is required"
  exit 1
fi

# if tags_file is defined just copy it to tags.txt
# else get tags from repo
if [[ -n "${tags_file:-}" ]]; then
  git_cmd "cp $tags_file tags.txt"
else
  git_cmd "git tag -l > tags.txt"
fi

# if not dry run and tags.txt is empty, then exit with error
if [[ "${DRY_RUN:-false}" == "false" ]] && [[ ! -s "tags.txt" ]]; then
  echo "::error::No tags found in repo"
  exit 1
fi

# use perl to regex search for last tag matching pattern
git_cmd "LAST_TAG=$(perl search.pl $regex tags.txt)"

# if not dry run and last tag is empty, then exit with error
if [[ "${DRY_RUN:-false}" == "false" ]] && [[ -z "$LAST_TAG" ]]; then
  echo "::error::No tags found matching pattern $regex"
  exit 1
fi

# get commit hash for last tag 
git_cmd "LAST_TAG_COMMIT=$(git rev-list -n 1 $LAST_TAG)"

git_cmd 'echo "::set-output name=tag::$LAST_TAG"'
git_cmd 'echo "::set-output name=tag_commit::$LAST_TAG_COMMIT"'

