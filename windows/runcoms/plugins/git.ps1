Set-Alias -Name 'g' -Value 'git'
# Set-Alias -Name 'ga' -Value 'git add'
# Set-Alias -Name 'gaa' -Value 'git add --all'
# Set-Alias -Name 'gap' -Value 'git apply'
# Set-Alias -Name 'gapa' -Value 'git add --patch'
# Set-Alias -Name 'gapt' -Value 'git apply --3way'
# Set-Alias -Name 'gau' -Value 'git add --update'
# Set-Alias -Name 'gav' -Value 'git add --verbose'
# Set-Alias -Name 'gb' -Value 'git branch'
# Set-Alias -Name 'gbD' -Value 'git branch -D'
# Set-Alias -Name 'gba' -Value 'git branch -a'
# Set-Alias -Name 'gbd' -Value 'git branch -d'
# Set-Alias -Name 'gbl' -Value 'git blame -b -w'
# Set-Alias -Name 'gbnm' -Value 'git branch --no-merged'
# Set-Alias -Name 'gbr' -Value 'git branch --remote'
# Set-Alias -Name 'gbs' -Value 'git bisect'
# Set-Alias -Name 'gbsb' -Value 'git bisect bad'
# Set-Alias -Name 'gbsg' -Value 'git bisect good'
# Set-Alias -Name 'gbsr' -Value 'git bisect reset'
# Set-Alias -Name 'gbss' -Value 'git bisect start'
# Set-Alias -Name 'gc' -Value 'git commit -v'
# Set-Alias -Name 'gc!' -Value 'git commit -v --amend'
# Set-Alias -Name 'gca' -Value 'git commit -v -a'
# Set-Alias -Name 'gca!' -Value 'git commit -v -a --amend'
# Set-Alias -Name 'gcam' -Value 'git commit -a -m'
# Set-Alias -Name 'gcan!' -Value 'git commit -v -a --no-edit --amend'
# Set-Alias -Name 'gcans!' -Value 'git commit -v -a -s --no-edit --amend'
# Set-Alias -Name 'gcas' -Value 'git commit -a -s'
# Set-Alias -Name 'gcasm' -Value 'git commit -a -s -m'
# Set-Alias -Name 'gcb' -Value 'git checkout -b'
# Set-Alias -Name 'gcd' -Value 'git checkout $(git_develop_branch)'
# Set-Alias -Name 'gcf' -Value 'git config --list'
# Set-Alias -Name 'gcl' -Value 'git clone --recurse-submodules'
# Set-Alias -Name 'gclean' -Value 'git clean -id'
# Set-Alias -Name 'gcm' -Value 'git checkout $(git_main_branch)'
# Set-Alias -Name 'gcmsg' -Value 'git commit -m'
# Set-Alias -Name 'gcn!' -Value 'git commit -v --no-edit --amend'
# Set-Alias -Name 'gco' -Value 'git checkout'
# Set-Alias -Name 'gcor' -Value 'git checkout --recurse-submodules'
# Set-Alias -Name 'gcount' -Value 'git shortlog -sn'
# Set-Alias -Name 'gcp' -Value 'git cherry-pick'
# Set-Alias -Name 'gcpa' -Value 'git cherry-pick --abort'
# Set-Alias -Name 'gcpc' -Value 'git cherry-pick --continue'
# Set-Alias -Name 'gcs' -Value 'git commit -S'
# Set-Alias -Name 'gcsm' -Value 'git commit -s -m'
# Set-Alias -Name 'gcss' -Value 'git commit -S -s'
# Set-Alias -Name 'gcssm' -Value 'git commit -S -s -m'
# Set-Alias -Name 'gd' -Value 'git diff'
# Set-Alias -Name 'gdca' -Value 'git diff --cached'
# Set-Alias -Name 'gdct' -Value 'git describe --tags $(git rev-list --tags --max-count=1)'
# Set-Alias -Name 'gdcw' -Value 'git diff --cached --word-diff'
# Set-Alias -Name 'gds' -Value 'git diff --staged'
# Set-Alias -Name 'gdt' -Value 'git diff-tree --no-commit-id --name-only -r'
# Set-Alias -Name 'gdup' -Value 'git diff @{upstream}'
# Set-Alias -Name 'gdw' -Value 'git diff --word-diff'
# Set-Alias -Name 'gf' -Value 'git fetch'
# Set-Alias -Name 'gfa' -Value 'git fetch --all --prune --jobs=10'
# Set-Alias -Name 'gfg' -Value 'git ls-files | grep'
# Set-Alias -Name 'gfo' -Value 'git fetch origin'
# Set-Alias -Name 'gg' -Value 'git gui citool'
# Set-Alias -Name 'gga' -Value 'git gui citool --amend'
# Set-Alias -Name 'ggpull' -Value 'git pull origin "$(git_current_branch)"'
# Set-Alias -Name 'ggpush' -Value 'git push origin "$(git_current_branch)"'
# Set-Alias -Name 'ggsup' -Value 'git branch --set-upstream-to=origin/$(git_current_branch)'
# Set-Alias -Name 'ghh' -Value 'git help'
# Set-Alias -Name 'gignore' -Value 'git update-index --assume-unchanged'
# Set-Alias -Name 'gignored' -Value 'git ls-files -v | grep "^[[:lower:]]"'
# Set-Alias -Name 'git-svn-dcommit-push' -Value 'git svn dcommit && git push github $(git_main_branch):svntrunk'
# Set-Alias -Name 'gk' -Value '\gitk --all --branches &!'
# Set-Alias -Name 'gke' -Value '\gitk --all $(git log -g --pretty=%h) &!'
# Set-Alias -Name 'gl' -Value 'git pull'
# Set-Alias -Name 'glfsi' -Value 'git lfs install'
# Set-Alias -Name 'glfsls' -Value 'git lfs ls-files'
# Set-Alias -Name 'glfsmi' -Value 'git lfs migrate import --include='
# Set-Alias -Name 'glfst' -Value 'git lfs track'
# Set-Alias -Name 'glg' -Value 'git log --stat'
# Set-Alias -Name 'glgg' -Value 'git log --graph'
# Set-Alias -Name 'glgga' -Value 'git log --graph --decorate --all'
# Set-Alias -Name 'glgm' -Value 'git log --graph --max-count=10'
# Set-Alias -Name 'glgp' -Value 'git log --stat -p'
# Set-Alias -Name 'glo' -Value 'git log --oneline --decorate'
# Set-Alias -Name 'globurl' -Value 'noglob urlglobber '
# Set-Alias -Name 'glog' -Value 'git log --oneline --decorate --graph'
# Set-Alias -Name 'gloga' -Value 'git log --oneline --decorate --graph --all'
# glp=_git_log_prettily
# Set-Alias -Name 'glum' -Value 'git pull upstream $(git_main_branch)'
# Set-Alias -Name 'gm' -Value 'git merge'
# Set-Alias -Name 'gma' -Value 'git merge --abort'
# Set-Alias -Name 'gmom' -Value 'git merge origin/$(git_main_branch)'
# Set-Alias -Name 'gmtl' -Value 'git mergetool --no-prompt'
# Set-Alias -Name 'gmtlvim' -Value 'git mergetool --no-prompt --tool=vimdiff'
# Set-Alias -Name 'gmum' -Value 'git merge upstream/$(git_main_branch)'
# Set-Alias -Name 'gp' -Value 'git push'
# Set-Alias -Name 'gpd' -Value 'git push --dry-run'
# Set-Alias -Name 'gpf' -Value 'git push --force-with-lease'
# Set-Alias -Name 'gpf!' -Value 'git push --force'
# Set-Alias -Name 'gpoat' -Value 'git push origin --all && git push origin --tags'
# Set-Alias -Name 'gpr' -Value 'git pull --rebase'
# Set-Alias -Name 'gpristine' -Value 'git reset --hard && git clean -dffx'
# Set-Alias -Name 'gpsup' -Value 'git push --set-upstream origin $(git_current_branch)'
# Set-Alias -Name 'gpu' -Value 'git push upstream'
# Set-Alias -Name 'gpv' -Value 'git push -v'
# Set-Alias -Name 'gr' -Value 'git remote'
# Set-Alias -Name 'gra' -Value 'git remote add'
# Set-Alias -Name 'grb' -Value 'git rebase'
# Set-Alias -Name 'grba' -Value 'git rebase --abort'
# Set-Alias -Name 'grbc' -Value 'git rebase --continue'
# Set-Alias -Name 'grbd' -Value 'git rebase $(git_develop_branch)'
# Set-Alias -Name 'grbi' -Value 'git rebase -i'
# Set-Alias -Name 'grbm' -Value 'git rebase $(git_main_branch)'
# Set-Alias -Name 'grbo' -Value 'git rebase --onto'
# Set-Alias -Name 'grbom' -Value 'git rebase origin/$(git_main_branch)'
# Set-Alias -Name 'grbs' -Value 'git rebase --skip'
# Set-Alias -Name 'grep' -Value 'grep --color'
# Set-Alias -Name 'grev' -Value 'git revert'
# Set-Alias -Name 'grh' -Value 'git reset'
# Set-Alias -Name 'grhh' -Value 'git reset --hard'
# Set-Alias -Name 'grm' -Value 'git rm'
# Set-Alias -Name 'grmc' -Value 'git rm --cached'
# Set-Alias -Name 'grmv' -Value 'git remote rename'
# Set-Alias -Name 'groh' -Value 'git reset origin/$(git_current_branch) --hard'
# Set-Alias -Name 'grrm' -Value 'git remote remove'
# Set-Alias -Name 'grs' -Value 'git restore'
# Set-Alias -Name 'grset' -Value 'git remote set-url'
# Set-Alias -Name 'grss' -Value 'git restore --source'
# Set-Alias -Name 'grst' -Value 'git restore --staged'
# Set-Alias -Name 'grt' -Value 'cd "$(git rev-parse --show-toplevel || echo .)"'
# Set-Alias -Name 'gru' -Value 'git reset --'
# Set-Alias -Name 'grup' -Value 'git remote update'
# Set-Alias -Name 'grv' -Value 'git remote -v'
# Set-Alias -Name 'gsb' -Value 'git status -sb'
# Set-Alias -Name 'gsd' -Value 'git svn dcommit'
# Set-Alias -Name 'gsh' -Value 'git show'
# Set-Alias -Name 'gsi' -Value 'git submodule init'
# Set-Alias -Name 'gsps' -Value 'git show --pretty=short --show-signature'
# Set-Alias -Name 'gsr' -Value 'git svn rebase'
# Set-Alias -Name 'gss' -Value 'git status -s'
# Set-Alias -Name 'gst' -Value 'git status'
# Set-Alias -Name 'gsta' -Value 'git stash push'
# Set-Alias -Name 'gstaa' -Value 'git stash apply'
# Set-Alias -Name 'gstall' -Value 'git stash --all'
# Set-Alias -Name 'gstc' -Value 'git stash clear'
# Set-Alias -Name 'gstd' -Value 'git stash drop'
# Set-Alias -Name 'gstl' -Value 'git stash list'
# Set-Alias -Name 'gstp' -Value 'git stash pop'
# Set-Alias -Name 'gsts' -Value 'git stash show --text'
# Set-Alias -Name 'gstu' -Value 'gsta --include-untracked'
# Set-Alias -Name 'gsu' -Value 'git submodule update'
# Set-Alias -Name 'gsw' -Value 'git switch'
# Set-Alias -Name 'gswc' -Value 'git switch -c'
# Set-Alias -Name 'gswd' -Value 'git switch $(git_develop_branch)'
# Set-Alias -Name 'gswm' -Value 'git switch $(git_main_branch)'
# Set-Alias -Name 'gtl' -Value 'gtl(){ git tag --sort=-v:refname -n -l "${1}*" }; noglob gtl'
# Set-Alias -Name 'gts' -Value 'git tag -s'
# Set-Alias -Name 'gtv' -Value 'git tag | sort -V'
# Set-Alias -Name 'gunignore' -Value 'git update-index --no-assume-unchanged'
# Set-Alias -Name 'gunwip' -Value 'git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'
# Set-Alias -Name 'gup' -Value 'git pull --rebase'
# Set-Alias -Name 'gupa' -Value 'git pull --rebase --autostash'
# Set-Alias -Name 'gupav' -Value 'git pull --rebase --autostash -v'
# Set-Alias -Name 'gupv' -Value 'git pull --rebase -v'
# Set-Alias -Name 'gwch' -Value 'git whatchanged -p --abbrev-commit --pretty=medium'
# Set-Alias -Name 'gwip' -Value 'git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign -m "--wip-- [skip ci]"'