#
# Functions Current
# (sorted alphabetically by function name)
# (order should follow README)
#

# Check for develop and similarly named branches
function git_develop_branch {
  $git_dir = git rev-parse --git-dir 2>&1
  if ($git_dir -ne '.git') { return }

  $refs = git show-ref | ForEach-Object -Process { $_ -split ' ' | Select-Object -Last 1 }
  $develop_refs = @('refs/heads', 'refs/remotes/origin', 'refs/remotes/upstream') | ForEach-Object -Process {
    $i = $_
    @('develop', 'dev', 'devel', 'development') | ForEach-Object -Process { "$i/$_" }
  }

  ForEach ($ref in $refs) {
    if ($develop_refs -contains $ref) {
      return $ref -split '/' | Select-Object -Last 1
    }
  }
  return 'develop'
}

# Check if main exists and use instead of master
function git_main_branch {
  $git_dir = git rev-parse --git-dir 2>&1
  if ($git_dir -ne '.git') { return }

  $refs = git show-ref | ForEach-Object -Process { $_ -split ' ' | Select-Object -Last 1 }
  $main_refs = @('refs/heads', 'refs/remotes/origin', 'refs/remotes/upstream') | ForEach-Object -Process {
    $i = $_
    @('main', 'trunk', 'mainline', 'default') | ForEach-Object -Process { "$i/$_" }
  }

  ForEach ($ref in $refs) {
    if ($main_refs -contains $ref) {
      return $ref -split '/' | Select-Object -Last 1
    }
  }
  return 'master'
}

function grename {
  param(
    [Parameter(Mandatory = $true)]
    [string]$old_branch,
    [Parameter(Mandatory = $true)]
    [string]$new_branch
  )

  # Rename branch locally
  git branch -m $old_branch $new_branch
  # Rename branch in origin remote
  if (git push origin :$new_branch) {
    git push --set-upstream origin $new_branch
  }
}

#
# Functions Work in Progress (WIP)
# (sorted alphabetically by function name)
# (order should follow README)
#

# Similar to `gunwip` but recursive "Unwips" all recent `--wip--` commits not just the last one
function gunwipall {
  $_commit = git log --grep='--wip--' --invert-grep --max-count=1 --format=format:%H

  # Check if a commit without "--wip--" was found and it's not the same as HEAD
  if ("$_commit" -ne "$(git rev-parse HEAD)") {
    git reset "$_commit" || Write-Error "Failed to reset to $_commit"
  }
}

# Warn if the current branch is a WIP
function work_in_progress {
  if ((git -c log.showSignature=false log --oneline -n 1 2>&1) -match '--wip--') { return 'WIP!!' }
}

#
# Aliases
# (sorted alphabetically by command)
# (order should follow README)
# (in some cases force the alisas order to match README, like for example gke and gk)
#

Remove-Alias -Name 'gc' -Force
Remove-Alias -Name 'gcb' -Force
Remove-Alias -Name 'gcm' -Force
Remove-Alias -Name 'gcs' -Force
Remove-Alias -Name 'gl' -Force
Remove-Alias -Name 'gm' -Force
Remove-Alias -Name 'gp' -Force
Remove-Alias -Name 'gpv' -Force

function grt {
  $git_top_level = git rev-parse --show-toplevel 2>&1
  if ($LASTEXITCODE -eq 0) {
    Set-Location -Path $git_top_level
  } else {
    Write-Error 'Failed to get the top-level directory'
  }
}

function ggpnp {
  if ($args.Count -eq 0) {
    ggl && ggp
  } else {
    ggl $args && ggp $args
  }
}

${function:ggpur} = { ggu $args }
Set-Alias -Name 'g' -Value 'git'
${function:ga} = { git add $args }
${function:gaa} = { git add --all $args }
${function:gapa} = { git add --patch $args }
${function:gau} = { git add --update $args }
${function:gav} = { git add --verbose $args }
${function:gwip} = {
  git add --all
  git commit --no-verify --no-gpg-sign -m '--wip-- [skip ci]'
}
${function:gam} = { git am $args }
${function:gama} = { git am --abort }
${function:gamc} = { git am --continue }
${function:gamscp} = { git am --show-current-patch $args }
${function:gams} = { git am --skip }
${function:gap} = { git apply $args }
${function:gapt} = { git apply --3way $args }
${function:gbs} = { git bisect $args }
${function:gbsb} = { git bisect bad $args }
${function:gbsg} = { git bisect good $args }
${function:gbsn} = { git bisect new $args }
${function:gbso} = { git bisect old $args }
${function:gbsr} = { git bisect reset $args }
${function:gbss} = { git bisect start $args }
${function:gbl} = { git blame -w $args }
${function:gb} = { git branch $args }
${function:gba} = { git branch --all $args }
${function:gbd} = { git branch --delete $args }
${function:gbD} = { git branch --delete --force $args }

${function:gbda} = {
  git branch --delete @(
    git branch --no-color --merged `
    | ForEach-Object -Process { $_ -split '\s' } `
    | Where-Object { $_ -notmatch "^([+*]|($(git_main_branch)|$(git_develop_branch))$)" }
  ) 2>&1 | Out-Null
}
${function:gbds} = {
  $default_branch = git_main_branch
  if ($LASTEXITCODE -ne 0) {
    $default_branch = git_develop_branch
  }

  git for-each-ref refs/heads/ '--format=%(refname:short)' | ForEach-Object {
    $branch = $_
    $merge_base = git merge-base $default_branch $branch
    $commit_tree = git commit-tree (git rev-parse "$branch\^ { tree }") -p $merge_base -m '_'
    if ((git cherry $default_branch $commit_tree) -like '-*') {
      git branch -D $branch
    }
  }
}
${function:gbgd} = {
  $env:LANG = 'C'
  git branch -d @(
    git branch --no-color -vv `
    | Select-String -Pattern ': gone\]' `
    | ForEach-Object -Process { $_ -split '\s+' | Select-Object -Index 1 }
  )
}
${function:gbgD} = {
  $env:LANG = 'C'
  git branch -D @(
    git branch --no-color -vv `
    | Select-String -Pattern ': gone\]' `
    | ForEach-Object -Process { $_ -split '\s+' | Select-Object -Index 1 }
  )
}
${function:gbnm} = { git branch --no-merged $args }
${function:gbr} = { git branch --remote $args }
${function:ggsup} = { git branch --set-upstream-to="origin/$(git_current_branch)" $args }
${function:gbg} = { git branch -vv | Select-String -Pattern ': gone\]' }
${function:gco} = { git checkout $args }
${function:gcor} = { git checkout --recurse-submodules $args }
${function:gcb} = { git checkout -b $args }
${function:gcd} = { git checkout $args $(git_develop_branch) }
${function:gcm} = { git checkout $args $(git_main_branch) }
${function:gcp} = { git cherry-pick $args }
${function:gcpa} = { git cherry-pick --abort }
${function:gcpc} = { git cherry-pick --continue }
${function:gclean} = { git clean --interactive -d $args }
${function:gcl} = { git clone --recurse-submodules $args }

function gccd {
  param(
    [Parameter(Mandatory = $true)]
    [string]$repo
  )

  # Clone repository and exit if it fails
  git clone --recurse-submodules $repo
  if ($LASTEXITCODE -ne 0) {
    Write-Error 'Failed to clone repository'
    return
  }

  # Get the name of the repository
  $repoName = Split-Path $repo -Leaf
  # Remove .git extension if it exists
  $repoName = $repoName -replace '\.git$', ''

  # Change directory to the cloned repository
  Set-Location -Path $repoName
}

${function:gcam} = { git commit --all --message $args }
${function:gcas} = { git commit --all --signoff $args }
${function:gcasm} = { git commit --all --signoff --message $args }
${function:gcs} = { git commit --gpg-sign $args }
${function:gcss} = { git commit --gpg-sign --signoff $args }
${function:gcssm} = { git commit --gpg-sign --signoff --message $args }
${function:gcmsg} = { git commit --message $args }
${function:gcsm} = { git commit --signoff --message $args }
${function:gc} = { git commit --verbose $args }
${function:gca} = { git commit --verbose --all $args }
${function:gca!} = { git commit --verbose --all --amend $args }
${function:gcan!} = { git commit --verbose --all --no-edit --amend $args }
${function:gcans!} = { git commit --verbose --all --signoff --no-edit --amend $args }
${function:gc!} = { git commit --verbose --amend $args }
${function:gcn!} = { git commit --verbose --no-edit --amend $args }
${function:gcf} = { git config --list $args }
${function:gdct} = { git describe --tags $(git rev-list --tags --max-count=1) $args }
${function:gd} = { git diff $args }
${function:gdca} = { git diff --cached $args }
${function:gdcw} = { git diff --cached --word-diff $args }
${function:gds} = { git diff --staged $args }
${function:gdw} = { git diff --word-diff $args }

${function:gdv} = { git diff -w $args | &"$env:EDITOR" -R - }

${function:gdup} = { git diff '@{upstream}' $args }

function gdnolock {
  git diff $args ':(exclude)package-lock.json' ':(exclude)*.lock'
}

${function:gdt} = { git diff-tree --no-commit-id --name-only -r $args }
${function:gf} = { git fetch $args }
${function:gfa} = { git fetch --all --prune --jobs=10 $args }
${function:gfo} = { git fetch origin $args }
${function:gg} = { git gui citool $args }
${function:gga} = { git gui citool --amend $args }
${function:ghh} = { git help $args }
${function:glgg} = { git log --graph $args }
${function:glgga} = { git log --graph --decorate --all $args }
${function:glgm} = { git log --graph --max-count=10 $args }
${function:glods} = { git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --date=short $args }
${function:glod} = { git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' $args }
${function:glola} = { git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --all $args }
${function:glols} = { git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --stat $args }
${function:glol} = { git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' $args }
${function:glo} = { git log --oneline --decorate $args }
${function:glog} = { git log --oneline --decorate --graph $args }
${function:gloga} = { git log --oneline --decorate --graph --all $args }

# Pretty log messages
function _git_log_prettily {
  if ($args[0]) {
    git log --pretty=$args
  }
}

${function:glp} = { _git_log_prettily $args }
${function:glg} = { git log --stat $args }
${function:glgp} = { git log --stat --patch $args }
${function:gignored} = { git ls-files -v | Select-String -CaseSensitive -Pattern '^[a-z].*$' }
${function:gfg} = { git ls-files | Select-String -Pattern $args }
${function:gm} = { git merge $args }
${function:gma} = { git merge --abort }
${function:gms} = { git merge --squash $args }
${function:gmom} = { git merge $args "origin/$(git_main_branch)" }
${function:gmum} = { git merge $args "upstream/$(git_main_branch)" }
${function:gmtl} = { git mergetool --no-prompt $args }
${function:gmtlvim} = { git mergetool --no-prompt --tool='nvim -d' $args }

${function:gl} = { git pull $args }
${function:gpr} = { git pull --rebase $args }
${function:gprv} = { git pull --rebase --verbose $args }
${function:gpra} = { git pull --rebase --autostash $args }
${function:gprav} = { git pull --rebase --autostash --verbose $args }

function ggu {
  param(
    [Parameter(Mandatory = $false)]
    [string]$branch
  )

  if (-not $branch) {
    $branch = git_current_branch
  }

  git pull --rebase origin $branch
}

${function:gprom} = { git pull --rebase origin $(git_main_branch) }
${function:gpromi} = { git pull --rebase=interactive origin $(git_main_branch) }
${function:ggpull} = { git pull origin $(git_current_branch) }

function ggl {
  param(
    [Parameter(Mandatory = $false)]
    [string]$branch
  )

  if (-not $branch) {
    $branch = git_current_branch
  }

  git pull origin $branch
}

${function:gluc} = { git pull $args upstream $(git_current_branch) }
${function:glum} = { git pull $args upstream $(git_main_branch) }
${function:gp} = { git push $args }
${function:gpd} = { git push --dry-run $args }

function ggf {
  param(
    [Parameter(Mandatory = $false)]
    [string]$branch
  )

  if (-not $branch) {
    $branch = git_current_branch
  }

  git push --force origin $branch
}

${function:gpf!} = { git push --force $args }
${function:gpf} = { git push --force-with-lease --force-if-includes $args }

function ggfl {
  param(
    [Parameter(Mandatory = $false)]
    [string]$branch
  )

  if (-not $branch) {
    $branch = git_current_branch
  }

  git push --force-with-lease origin $branch
}

${function:gpsup} = { git push $args --set-upstream origin $(git_current_branch) }
${function:gpsupf} = { git push $args --set-upstream origin $(git_current_branch) --force-with-lease --force-if-includes }
${function:gpv} = { git push --verbose $args }
${function:gpoat} = { git push --all origin && git push --tags origin }
${function:gpod} = { git push $args --delete origin }
${function:ggpush} = { git push $args origin $(git_current_branch) }

function ggp {
  param(
    [Parameter(Mandatory = $false)]
    [string]$branch
  )

  if (-not $branch) {
    $branch = git_current_branch
  }

  git push origin $branch
}

${function:gpu} = { git push upstream $args }
${function:grb} = { git rebase $args }
${function:grba} = { git rebase --abort }
${function:grbc} = { git rebase --continue }
${function:grbi} = { git rebase --interactive $args }
${function:grbo} = { git rebase --onto $args }
${function:grbs} = { git rebase --skip }
${function:grbd} = { git rebase $args $(git_develop_branch) }
${function:grbm} = { git rebase $args $(git_main_branch) }
${function:grbom} = { git rebase $args "origin/$(git_main_branch)" }
${function:gr} = { git remote $args }
${function:grv} = { git remote --verbose $args }
${function:gra} = { git remote add $args }
${function:grrm} = { git remote remove $args }
${function:grmv} = { git remote rename $args }
${function:grset} = { git remote set-url $args }
${function:grup} = { git remote update $args }
${function:grh} = { git reset $args }
${function:gru} = { git reset -- $args }
${function:grhh} = { git reset --hard $args }
${function:gpristine} = { git reset --hard && git clean --force -dfx }
${function:groh} = { git reset --hard "origin/$(git_current_branch)" }
${function:grs} = { git restore $args }
${function:grss} = { git restore --source $args }
${function:grst} = { git restore --staged $args }
${function:gunwip} = { if (git log -n 1 --pretty=%B | Select-String -Pattern '--wip--') { git reset HEAD~ } }
${function:grev} = { git revert $args }
${function:grm} = { git rm $args }
${function:grmc} = { git rm --cached $args }
${function:gcount} = { git shortlog --summary --numbered $args }
${function:gsh} = { git show $args }
${function:gsps} = { git show --pretty=short --show-signature $args }
${function:gstall} = { git stash --all $args }
${function:gstaa} = { git stash apply $args }
${function:gstc} = { git stash clear }
${function:gstd} = { git stash drop $args }
${function:gstl} = { git stash list $args }
${function:gstp} = { git stash pop $args }
${function:gsta} = { git stash push $args }
${function:gsts} = { git stash show --text $args }
${function:gst} = { git status $args }
${function:gss} = { git status --short $args }
${function:gsb} = { git status --short --branch $args }
${function:gsi} = { git submodule init $args }
${function:gsu} = { git submodule update $args }
${function:gsd} = { git svn dcommit $args }
${function:gsdp} = { git svn dcommit && git push github "$(git_main_branch):svntrunk" }
${function:gsr} = { git svn rebase $args }
${function:gsw} = { git switch $args }
${function:gswc} = { git switch -c $args }
${function:gswm} = { git switch $(git_main_branch) }
${function:gswd} = { git switch $(git_develop_branch) }
${function:gts} = { git tag -s $args }
${function:gtv} = { git tag --sort=-v:refname }
${function:gignore} = { git update-index --assume-unchanged $args }
${function:gunignore} = { git update-index --no-assume-unchanged $args }
${function:gwch} = { git whatchanged -p --abbrev-commit --pretty=medium $args }
${function:gwt} = { git worktree $args }
${function:gwta} = { git worktree add $args }
${function:gwtls} = { git worktree list $args }
${function:gwtmv} = { git worktree move $args }
${function:gwtrm} = { git worktree remove $args }
${function:gstu} = { gsta --include-untracked $args }
${function:gtl} = { git tag --sort=-v:refname -n -l $args }
${function:gk} = { gitk --all --branches $args }
${function:gke} = { gitk --all --reflog $args }
