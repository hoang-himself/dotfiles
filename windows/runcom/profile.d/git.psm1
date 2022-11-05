Remove-Alias -Name 'gc' -Force
Remove-Alias -Name 'gcb' -Force
Remove-Alias -Name 'gcm' -Force
Remove-Alias -Name 'gcs' -Force
Remove-Alias -Name 'gl' -Force
Remove-Alias -Name 'gm' -Force
Remove-Alias -Name 'gp' -Force
Remove-Alias -Name 'gpv' -Force

Set-Alias -Name 'g' -Value 'git'

function git_develop_branch {
  $git_dir = git rev-parse --git-dir 2>&1
  if ($git_dir -ne '.git') { return }

  $refs = git show-ref | ForEach-Object -Process { $_ -split ' ' | Select-Object -Last 1 }
  $develop_refs = @('refs/heads', 'refs/remotes/origin', 'refs/remotes/upstream') | ForEach-Object -Process {
    $i = $_
    @('develop', 'dev', 'devel', 'development') | ForEach-Object -Process { "$i/$_" }
  }

  foreach ($ref in $refs) {
    if ($develop_refs -contains $ref) {
      return $ref -split '/' | Select-Object -Last 1
    }
  }
  return 'develop'
}

function git_main_branch {
  $git_dir = git rev-parse --git-dir 2>&1
  if ($git_dir -ne '.git') { return }

  $refs = git show-ref | ForEach-Object -Process { $_ -split ' ' | Select-Object -Last 1 }
  $main_refs = @('refs/heads', 'refs/remotes/origin', 'refs/remotes/upstream') | ForEach-Object -Process {
    $i = $_
    @('main', 'trunk', 'mainline', 'default') | ForEach-Object -Process { "$i/$_" }
  }

  foreach ($ref in $refs) {
    if ($main_refs -contains $ref) {
      return $ref -split '/' | Select-Object -Last 1
    }
  }
  return 'master'
}

${function:gcl} = { git clone --recurse-submodules $args }

${function:gf} = { git fetch $args }
${function:gfa} = { git fetch --all --prune --jobs=10 $args }
${function:gfo} = { git fetch origin $args }

${function:ga} = { git add $args }
${function:gaa} = { git add --all $args }
${function:gapa} = { git add --patch $args }
${function:gau} = { git add --update $args }

${function:gcp} = { git cherry-pick $args }
${function:gcpa} = { git cherry-pick --abort }
${function:gcpc} = { git cherry-pick --continue }

${function:grm} = { git rm $args }
${function:grmc} = { git rm --cached $args }

${function:grb} = { git rebase $args }
${function:grba} = { git rebase --abort }
${function:grbc} = { git rebase --continue }
${function:grbi} = { git rebase --interactive $args }
${function:grbo} = { git rebase --onto $args }
${function:grbs} = { git rebase --skip }
${function:grbd} = { git rebase $(git_develop_branch) $args }
${function:grbm} = { git rebase $(git_main_branch) $args }
${function:grbom} = { git rebase "origin/$(git_main_branch)" $args }

${function:gm} = { git merge $args }
${function:gma} = { git merge --abort }
${function:gms} = { git merge --squash $args }
${function:gmom} = { git merge "origin/$(git_main_branch)" $args }
${function:gmum} = { git merge "upstream/$(git_main_branch)" $args }

${function:gcam} = { git commit --all --message $args }
${function:gcas} = { git commit --all --signoff $args }
${function:gcasm} = { git commit --all --signoff --message $args }
${function:gcmsg} = { git commit --message $args }
${function:gcsm} = { git commit --signoff --message $args }
${function:gc} = { git commit $args }
${function:gca} = { git commit --all $args }
${function:gca!} = { git commit --all --amend $args }
${function:gcan!} = { git commit --all --no-edit --amend $args }
${function:gcans!} = { git commit --all --signoff --no-edit --amend $args }
${function:gc!} = { git commit --amend $args }
${function:gcn!} = { git commit --no-edit --amend $args }

${function:gup} = { git pull --rebase }
${function:gupa} = { git pull --rebase --autostash }
${function:gupom} = { git pull --rebase origin $(git_main_branch) }

${function:gp} = { git push $args }
${function:gpd} = { git push --delete $args }
${function:gpf} = { git push --force-with-lease --force-if-includes $args }
${function:gpf!} = { git push --force $args }
${function:gpsup} = { git push --set-upstream origin $(git branch --show-current) }
${function:gpsupf} = { git push --set-upstream origin $(git branch --show-current) --force-with-lease --force-if-includes }
${function:gpoat} = { git push --all --tags origin }

${function:gst} = { git status $args }
${function:gss} = { git status --short $args }
${function:gsb} = { git status --short --branch $args }

${function:gts} = { git tag -s $args }
${function:gtv} = { git tag --sort=-v:refname }

${function:gsw} = { git switch $args }
${function:gswc} = { git switch -c $args }
${function:gswm} = { git switch $(git_main_branch) }
${function:gswd} = { git switch $(git_develop_branch) }

${function:gb} = { git branch $args }
${function:gba} = { git branch --all $args }
${function:gbd} = { git branch --delete $args }
${function:gbD} = { git branch --delete --force $args }
${function:gbnm} = { git branch --no-merged $args }
${function:gbr} = { git branch --remote $args }
${function:ggsup} = { git branch --set-upstream-to="origin/$(git branch --show-current)" $args }
${function:gbg} = { git branch -vv | Select-String -Pattern ': gone\]' }

${function:gco} = { git checkout $args }
${function:gcor} = { git checkout --recurse-submodules $args }
${function:gcb} = { git checkout -b $args }
${function:gcd} = { git checkout $(git_develop_branch) $args }
${function:gcm} = { git checkout $(git_main_branch) $args }

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
${function:glp} = { git log --pretty $args }
${function:glg} = { git log --stat $args }
${function:glgp} = { git log --stat --patch $args }

${function:gsh} = { git show $args }
${function:gsps} = { git show --pretty=short --show-signature $args }

${function:gignore} = { git update-index --assume-unchanged $args }
${function:gunignore} = { git update-index --no-assume-unchanged $args }

${function:gignored} = { git ls-files -v | Select-String -CaseSensitive -Pattern '^[a-z].*$' }
${function:gfg} = { git ls-files | Select-String -Pattern $args }

${function:gr} = { git remote $args }
${function:gra} = { git remote add $args }
${function:grset} = { git remote set-url $args }
${function:grmv} = { git remote rename $args }
${function:grrm} = { git remote remove $args }

${function:gbs} = { git bisect $args }
${function:gbss} = { git bisect start $args }
${function:gbsg} = { git bisect good $args }
${function:gbsb} = { git bisect bad $args }
${function:gbsr} = { git bisect reset $args }

${function:grh} = { git reset $args }
${function:grhh} = { git reset --hard $args }
${function:gpristine} = { git reset --hard && git clean --force -dfx }
${function:groh} = { git reset --hard "origin/$(git branch --show-current)" }

${function:grs} = { git restore $args }
${function:grss} = { git restore --source $args }
${function:grst} = { git restore --staged $args }

${function:gsta} = { git stash push $args }
${function:gstall} = { git stash push --all $args }
${function:gstl} = { git stash list $args }
${function:gsts} = { git stash show --text $args }
${function:gstaa} = { git stash apply $args }
${function:gstp} = { git stash pop $args }
${function:gstd} = { git stash drop $args }
${function:gstc} = { git stash clear }

${function:gwt} = { git worktree $args }
${function:gwta} = { git worktree add $args }
${function:gwtls} = { git worktree list $args }
${function:gwtmv} = { git worktree move $args }
${function:gwtrm} = { git worktree remove $args }

${function:gsi} = { git submodule init $args }
${function:gsu} = { git submodule update $args }

${function:gcf} = { git config --list $args }
