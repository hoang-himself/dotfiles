# The git prompt's git commands are read-only and should not interfere with
# other processes. This environment variable is equivalent to running with `git
# --no-optional-locks`, but falls back gracefully for older versions of git.
# See git(1) for and git-status(1) for a description of that flag.

# We wrap in a local function instead of exporting the variable directly in
# order to avoid interfering with manually-run git commands by the user.
function __git_prompt_git {
  git --no-optional-locks $args
}

# Outputs the name of the current branch
# Usage example: git pull origin $(git_current_branch)
# Using '--quiet' with 'symbolic-ref' will not cause a fatal error (128) if
# it's not a symbolic ref, but in a Git repo.
function git_current_branch {
  git branch --show-current $args
}

# Outputs the name of the current user
# Usage example: $(git_current_user_name)
function git_current_user_name {
  __git_prompt_git config user.name
}

# Outputs the email of the current user
# Usage example: $(git_current_user_email)
function git_current_user_email {
  __git_prompt_git config user.email
}

# Output the name of the root directory of the git repository
# Usage example: $(git_repo_name)
function git_repo_name {
  $repo_path = __git_prompt_git rev-parse --show-toplevel
  if ($repo_path) {
    return Split-Path $repo_path -Leaf
  }
}
