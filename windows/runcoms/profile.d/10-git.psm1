#
# Functions
#

# Pretty log messages
function _git_log_prettily {
  if ($args[0]) {
    git log --pretty=$args[0]
  }
}

# Warn if the current branch is a WIP
function work_in_progress {
  if (git -c log.showSignature=false log -n 1 2>&1 | Select-String -Pattern '--wip--' -Quiet) { return 'WIP!!' }
}

# Similar to `gunwip` but recursive "Unwips" all recent `--wip--` commits not just the last one
function gunwipall {
  $commit = $(git log --grep='--wip--' --invert-grep --max-count=1 --format=format:%H)

  # Check if a commit without "--wip--" was found and it's not the same as HEAD
  if ("$commit" -ne "$(git rev-parse HEAD)") {
    git reset "$commit" || return 1
  }
}

# Check if main exists and use instead of master
function git_main_branch {
  if (git rev-parse --git-dir 2>&1 | Out-Null) { return }

  $refs = @('refs/heads', 'refs/remotes/origin', 'refs/remotes/upstream') | ForEach-Object -Process {
    $i = $_
    @('main', 'trunk', 'mainline', 'default') | ForEach-Object -Process { "$i/$_" }
  }
  ForEach ($ref in $refs) {
    if (git show-ref --quiet --verify $ref) {
      return $ref.Split('/')[-1]
    }
  }
  return 'master'
}

# Check for develop and similarly named branches
function git_develop_branch {
  if (git rev-parse --git-dir 2>&1 | Out-Null) { return }

  ForEach ($branch in @('dev', 'devel', 'development')) {
    if (git show-ref --quiet --verify "refs/heads/$branch") {
      return "$branch"
    }
  }
  return 'develop'
}

#
# Aliases
#

Set-Alias -Name 'g' -Value 'git'
Remove-Alias -Name 'gc' -Force
Remove-Alias -Name 'gcb' -Force
Remove-Alias -Name 'gcm' -Force
Remove-Alias -Name 'gcs' -Force
Remove-Alias -Name 'gl' -Force
Remove-Alias -Name 'gm' -Force
Remove-Alias -Name 'gp' -Force
Remove-Alias -Name 'gpv' -Force

${function:ga} = { git add $args }
${function:gaa} = { git add --all $args }
${function:gapa} = { git add --patch $args }
${function:gau} = { git add --update $args }
${function:gav} = { git add --verbose $args }
${function:gap} = { git apply $args }
${function:gapt} = { git apply --3way $args }

${function:gb} = { git branch $args }
${function:gba} = { git branch --all $args }
${function:gbd} = { git branch --delete $args }
${function:gbda} = {
  git branch -d @(
    git branch --no-color --merged `
    | Select-String -NotMatch -Pattern "^([+*]|\s*($(git_main_branch)|$(git_develop_branch))\s*$)" `
    | ForEach-Object -Process { $_.Line.Trim() }
  )
}
${function:gbD} = { git branch --delete --force $args }
${function:gbg} = { git branch -vv | Select-String -Pattern ': gone\]' }
${function:gbgd} = {
  git branch -d @(
    git branch --no-color -vv `
    | Select-String -Pattern ': gone\]' `
    | ForEach-Object -Process { ($_ -split '\s+')[1] }
  )
}
${function:gbgD} = {
  git branch -D @(
    git branch --no-color -vv `
    | Select-String -Pattern ': gone\]' `
    | ForEach-Object -Process { ($_ -split '\s+')[1] }
  )
}
${function:gbl} = { git blame -b -w $args }
${function:gbnm} = { git branch --no-merged $args }
${function:gbr} = { git branch --remote $args }
${function:gbs} = { git bisect $args }
${function:gbsb} = { git bisect bad $args }
${function:gbsg} = { git bisect good $args }
${function:gbsr} = { git bisect reset $args }
${function:gbss} = { git bisect start $args }

${function:gc} = { git commit --verbose $args }
${function:gc!} = { git commit --verbose --amend $args }
${function:gcn!} = { git commit --verbose --no-edit --amend $args }
${function:gca} = { git commit --verbose --all $args }
${function:gca!} = { git commit --verbose --all --amend $args }
${function:gcan!} = { git commit --verbose --all --no-edit --amend $args }
${function:gcans!} = { git commit --verbose --all --signoff --no-edit --amend $args }
${function:gcam} = { git commit --all --message $args }
${function:gcsm} = { git commit --signoff --message $args }
${function:gcas} = { git commit --all --signoff $args }
${function:gcasm} = { git commit --all --signoff --message $args }
${function:gcb} = { git checkout -b $args }
${function:gcf} = { git config --list $args }

function gccd {
  git clone --recurse-submodules $args
  if (Test-Path -Path $args) {
    Set-Location -Path $args
  } else {
    Set-Location -Path $args.Split('/')[-1]
  }
}

${function:gcl} = { git clone --recurse-submodules $args }
${function:gclean} = { git clean --interactive -d $args }
${function:gpristine} = { git reset --hard && git clean --force -dfx $args }
${function:gcm} = { git checkout $(git_main_branch) }
${function:gcd} = { git checkout $(git_develop_branch) $args }
${function:gcmsg} = { git commit --message $args }
${function:gco} = { git checkout $args }
${function:gcor} = { git checkout --recurse-submodules $args }
${function:gcount} = { git shortlog --summary --numbered $args }
${function:gcp} = { git cherry-pick $args }
${function:gcpa} = { git cherry-pick --abort }
${function:gcpc} = { git cherry-pick --continue }
${function:gcs} = { git commit --gpg-sign $args }
${function:gcss} = { git commit --gpg-sign --signoff $args }
${function:gcssm} = { git commit --gpg-sign --signoff --message $args }

${function:gd} = { git diff $args }
${function:gdca} = { git diff --cached $args }
${function:gdcw} = { git diff --cached --word-diff $args }
${function:gdct} = { git describe --tags $(git rev-list --tags --max-count=1) $args }
${function:gds} = { git diff --staged $args }
${function:gdt} = { git diff-tree --no-commit-id --name-only -r $args }
${function:gdup} = { git diff '@{upstream}' $args }
${function:gdw} = { git diff --word-diff $args }

function gdnolock {
  git diff $args ':(exclude)package-lock.json' ':(exclude)*.lock'
}

function gdv { git diff -w $args | &"$env:EDITOR" -R - }

${function:gf} = { git fetch $args }
${function:gfa} = { git fetch --all --prune --jobs=10 $args }
${function:gfo} = { git fetch origin $args }

${function:gfg} = { git ls-files | Select-String -Pattern $args }

${function:gg} = { git gui citool $args }
${function:gga} = { git gui citool --amend $args }

function ggf {
  $b = if ($args.count -ne 1) { git_current_branch } else { $args[0] }
  git push --force origin "$b"
}

function ggfl {
  $b = if ($args.count -ne 1) { git_current_branch } else { $args[0] }
  git push --force-with-lease origin "$b"
}

function ggl {
  if (($args.count -ne 0) -and ($args.count -ne 1)) {
    git pull origin $args
  } else {
    $b = if ($args.count -eq 0) { git_current_branch } else { $args[0] }
    git pull origin "$b"
  }
}

function ggp {
  if (($args.count -ne 0) -and ($args.count -ne 1)) {
    git push origin $args
  } else {
    $b = if ($args.count -eq 0) { git_current_branch } else { $args[0] }
    git push origin "$b"
  }
}

function ggpnp {
  if ($args.count -eq 0) {
    ggl && ggp
  } else {
    ggl $args && ggp $args
  }
}

function ggu {
  $b = if ($args.count -ne 1) { git_current_branch } else { $args[0] }
  git pull --rebase origin "$b"
}

${function:ggpur} = { ggu $args }
${function:ggpull} = { git pull origin $(git_current_branch) }
${function:ggpush} = { git push origin $(git_current_branch) }

${function:ggsup} = { git branch --set-upstream-to="origin/$(git_current_branch)" $args }
${function:gpsup} = { git push --set-upstream origin $(git_current_branch) }

${function:ghh} = { git help $args }

${function:gignore} = { git update-index --assume-unchanged $args }
${function:gignored} = { git ls-files -v | Select-String -CaseSensitive -Pattern '^[a-z].*$' }
${function:gsdp} = { git svn dcommit && git push github "$(git_main_branch):svntrunk" }

${function:gk} = { gitk --all --branches $args }
${function:gke} = { gitk --all $(git log --walk-reflogs --pretty=%h) $args }

${function:gl} = { git pull $args }
${function:glg} = { git log --stat $args }
${function:glgp} = { git log --stat -p $args }
${function:glgg} = { git log --graph $args }
${function:glgga} = { git log --graph --decorate --all $args }
${function:glgm} = { git log --graph --max-count=10 $args }
${function:glo} = { git log --oneline --decorate $args }
${function:glol} = { git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' $args }
${function:glols} = { git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --stat $args }
${function:glod} = { git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' $args }
${function:glods} = { git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --date=short $args }
${function:glola} = { git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --all $args }
${function:glog} = { git log --oneline --decorate --graph $args }
${function:gloga} = { git log --oneline --decorate --graph --all $args }
${function:glp} = { _git_log_prettily $args }

${function:gm} = { git merge $args }
${function:gmom} = { git merge "origin/$(git_main_branch)" $args }
${function:gmtl} = { git mergetool --no-prompt $args }
${function:gmtlvim} = { git mergetool --no-prompt --tool='nvim -d' $args }
${function:gmum} = { git merge "upstream/$(git_main_branch)" $args }
${function:gma} = { git merge --abort }
${function:gms} = { git merge --squash $args }

${function:gp} = { git push $args }
${function:gpd} = { git push --dry-run $args }
${function:gpf} = { git push --force-with-lease --force-if-includes $args }
${function:gpf!} = { git push --force $args }
${function:gpoat} = { git push origin --all && git push origin --tags }
${function:gpod} = { git push origin --delete $args }
${function:gpr} = { git pull --rebase $args }
${function:gpu} = { git push upstream $args }
${function:gpv} = { git push --verbose $args }

${function:gr} = { git remote $args }
${function:gra} = { git remote add $args }
${function:grb} = { git rebase $args }
${function:grba} = { git rebase --abort }
${function:grbc} = { git rebase --continue }
${function:grbd} = { git rebase $(git_develop_branch) $args }
${function:grbi} = { git rebase -i $args }
${function:grbm} = { git rebase $(git_main_branch) }
${function:grbom} = { git rebase "origin/$(git_main_branch)" $args }
${function:grbo} = { git rebase --onto $args }
${function:grbs} = { git rebase --skip }
${function:grev} = { git revert $args }
${function:grh} = { git reset $args }
${function:grhh} = { git reset --hard $args }
${function:groh} = { git reset "origin/$(git_current_branch)" --hard $args }
${function:grm} = { git rm $args }
${function:grmc} = { git rm --cached $args }
${function:grmv} = { git remote rename $args }
${function:grrm} = { git remote remove $args }
${function:grs} = { git restore $args }
${function:grset} = { git remote set-url $args }
${function:grss} = { git restore --source $args }
${function:grst} = { git restore --staged $args }
${function:grst} = { git restore --staged $args }
${function:grt} = { Set-Location -Path "$(git rev-parse --show-toplevel || Write-Output -InputObject .)" $args }
${function:gru} = { git reset -- $args }
${function:grup} = { git remote update $args }
${function:grv} = { git remote --verbose $args }

${function:gsb} = { git status --short --branch $args }
${function:gsd} = { git svn dcommit $args }
${function:gsh} = { git show $args }
${function:gsi} = { git submodule init $args }
${function:gsps} = { git show --pretty=short --show-signature $args }
${function:gsr} = { git svn rebase $args }
${function:gss} = { git status --short $args }
${function:gst} = { git status $args }

${function:gsta} = { git stash push $args }
${function:gstaa} = { git stash apply $args }
${function:gstc} = { git stash clear $args }
${function:gstd} = { git stash drop $args }
${function:gstl} = { git stash list $args }
${function:gstp} = { git stash pop $args }
${function:gsts} = { git stash show --text $args }
${function:gstu} = { gsta --include-untracked $args }
${function:gstall} = { git stash --all $args }
${function:gsu} = { git submodule update $args }
${function:gsw} = { git switch $args }
${function:gswc} = { git switch -c $args }
${function:gswm} = { git switch $(git_main_branch) }
${function:gswd} = { git switch $(git_develop_branch) $args }

${function:gts} = { git tag -s $args }
${function:gtv} = { git tag | Sort-Object }
${function:gtl} = { git tag --sort=-v:refname -n -l $args }

${function:gunignore} = { git update-index --no-assume-unchanged $args }
${function:gunwip} = { if (git log -n 1 | Select-String -Pattern '--wip--') { git reset '@~' } }
${function:gup} = { git pull --rebase $args }
${function:gupv} = { git pull --rebase -v $args }
${function:gupa} = { git pull --rebase --autostash $args }
${function:gupav} = { git pull --rebase --autostash -v $args }
${function:gupom} = { git pull --rebase origin $(git_main_branch) }
${function:gupomi} = { git pull --rebase=interactive origin $(git_main_branch) }
${function:glum} = { git pull upstream $(git_main_branch) }
${function:gluc} = { git pull upstream $(git_current_branch) }

${function:gwch} = { git whatchanged -p --abbrev-commit --pretty=medium $args }
${function:gwip} = { git add -A; git rm $(git ls-files --deleted) 2>&1 | Out-Null; git commit --no-verify --no-gpg-sign -m '--wip-- [skip ci]' }

${function:gwt} = { git worktree $args }
${function:gwta} = { git worktree add $args }
${function:gwtls} = { git worktree list $args }
${function:gwtmv} = { git worktree move $args }
${function:gwtrm} = { git worktree remove $args }

${function:gam} = { git am $args }
${function:gamc} = { git am --continue }
${function:gams} = { git am --skip }
${function:gama} = { git am --abort }
${function:gamscp} = { git am --show-current-patch }

function grename {
  if (-not ([bool]$args[0] && [bool]$args[1])) {
    Write-Output -InputObject "Usage: $((Get-PSCallStack).FunctionName[0]) old_branch new_branch"
    return 1
  }

  # Rename branch locally
  git branch -m $args[0] $args[1]
  # Rename branch in origin remote
  if (git push origin :$args[1]) {
    git push --set-upstream origin $args[1]
  }
}
