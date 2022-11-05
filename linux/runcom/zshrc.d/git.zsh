function git_develop_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local branch
  for branch in dev devel develop development; do
    if command git show-ref -q --verify refs/heads/$branch; then
      echo $branch
      return 0
    fi
  done

  echo develop
  return 1
}

function git_main_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local ref
  for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default,stable,master}; do
    if command git show-ref -q --verify $ref; then
      echo ${ref:t}
      return 0
    fi
  done

  echo master
  return 1
}

alias gcl='git clone --recurse-submodules'

alias gf='git fetch'
alias gfa='git fetch --all --prune --jobs=10'
alias gfo='git fetch origin'

alias ga='git add'
alias gaa='git add --all'
alias gapa='git add --patch'
alias gau='git add --update'

alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'

alias grm='git rm'
alias grmc='git rm --cached'

alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase --interactive'
alias grbo='git rebase --onto'
alias grbs='git rebase --skip'
alias grbd='git rebase $(git_develop_branch)'
alias grbm='git rebase $(git_main_branch)'
alias grbom='git rebase "origin/$(git_main_branch)"'

alias gm='git merge'
alias gma='git merge --abort'
alias gms='git merge --squash'
alias gmom='git merge "origin/$(git_main_branch)"'
alias gmum='git merge "upstream/$(git_main_branch)"'

alias gcam='git commit --all --message'
alias gcas='git commit --all --signoff'
alias gcasm='git commit --all --signoff --message'
alias gcmsg='git commit --message'
alias gcsm='git commit --signoff --message'
alias gc='git commit'
alias gca='git commit --all'
alias gca!='git commit --all --amend'
alias gcan!='git commit --all --no-edit --amend'
alias gcans!='git commit --all --signoff --no-edit --amend'
alias gc!='git commit --amend'
alias gcn!='git commit --no-edit --amend'

alias gup='git pull --rebase'
alias gupa='git pull --rebase --autostash'
alias gupom='git pull --rebase origin $(git_main_branch)'

alias gp='git push'
alias gpd='git push --delete'
alias gpf='git push --force-with-lease --force-if-includes'
alias gpf!='git push --force'
alias gpsup='git push --set-upstream origin $(git branch --show-current)'
alias gpsupf='git push --set-upstream origin $(git branch --show-current) --force-with-lease --force-if-includes'
alias gpoat='git push --all --tags origin'

alias gst='git status'
alias gss='git status --short'
alias gsb='git status --short --branch'

alias gts='git tag -s'
alias gtv='git tag --sort=-v:refname'

alias gsw='git switch'
alias gswc='git switch -c'
alias gswm='git switch $(git_main_branch)'
alias gswd='git switch $(git_develop_branch)'

alias gb='git branch'
alias gba='git branch --all'
alias gbd='git branch --delete'
alias gbD='git branch --delete --force'
alias gbnm='git branch --no-merged'
alias gbr='git branch --remote'
alias ggsup='git branch --set-upstream-to="origin/$(git branch --show-current)"'
alias gbg='LANG=C git branch -vv | grep ": gone\]"'

alias gco='git checkout'
alias gcor='git checkout --recurse-submodules'
alias gcb='git checkout -b'
alias gcd='git checkout $(git_develop_branch)'
alias gcm='git checkout $(git_main_branch)'

alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias glgm='git log --graph --max-count=10'
alias glods='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset" --date=short'
alias glod='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset"'
alias glola='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --all'
alias glols='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --stat'
alias glol='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"'
alias glo='git log --oneline --decorate'
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'
alias glp='git log --pretty'
alias glg='git log --stat'
alias glgp='git log --stat --patch'

alias gsh='git show'
alias gsps='git show --pretty=short --show-signature'

alias gignore='git update-index --assume-unchanged'
alias gunignore='git update-index --no-assume-unchanged'

alias gignored='git ls-files -v | grep "^[[:lower:]]"'
alias gfg='git ls-files | Select-String -Pattern'

alias gr='git remote'
alias gra='git remote add'
alias grset='git remote set-url'
alias grmv='git remote rename'
alias grrm='git remote remove'

alias gbs='git bisect'
alias gbss='git bisect start'
alias gbsg='git bisect good'
alias gbsb='git bisect bad'
alias gbsr='git bisect reset'

alias grh='git reset'
alias grhh='git reset --hard'
alias gpristine='git reset --hard && git clean --force -dfx'
alias groh='git reset --hard "origin/$(git branch --show-current)"'

alias grs='git restore'
alias grss='git restore --source'
alias grst='git restore --staged'

alias gsta='git stash push'
alias gstall='git stash push --all'
alias gstl='git stash list'
alias gsts='git stash show --text'
alias gstaa='git stash apply'
alias gstp='git stash pop'
alias gstd='git stash drop'
alias gstc='git stash clear'

alias gwt='git worktree'
alias gwta='git worktree add'
alias gwtls='git worktree list'
alias gwtmv='git worktree move'
alias gwtrm='git worktree remove'

alias gsi='git submodule init'
alias gsu='git submodule update'

alias gcf='git config --list'
