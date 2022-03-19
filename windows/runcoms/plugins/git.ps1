function git_current_branch {
  git branch --show-current
}

function git_main_branch {
  if (git rev-parse --git-dir 2>&1 | Out-Null) { return }

  $remotes = @('heads') + (@('origin', 'upstream') | ForEach-Object { "remotes/$_" })
  $refs = @()
  ForEach ($remote in $remotes) {
    @('main', 'trunk') | ForEach-Object {
      $refs += "refs/$remote/$_"
    }
  }

  ForEach ($ref in $refs) {
    if ( -not (git show-ref -q --verify $ref)) {
      Write-Output ($ref.Split('/')[-1])
      return
    }
  }
  Write-Output 'master'
}

function git_develop_branch {
  if (git rev-parse --git-dir 2>&1 | Out-Null) { return }

  ForEach ($branch in @('dev', 'devel', 'development')) {
    if ( -not (git show-ref -q --verify "refs/heads/$branch")) {
      Write-Output "$branch"
      return
    }
  }
  Write-Output 'develop'
}

Set-Alias -Name 'g' -Value 'git'
${function:ga} = { git add $args }
${function:gaa} = { git add --all $args }
${function:gapa} = { git add --patch $args }
${function:gau} = { git add --update $args }
${function:gav} = { git add --verbose $args }
${function:gap} = { git apply $args }
${function:gapt} = { git apply --3way $args }

${function:gb} = { git branch $args }
${function:gba} = { git branch -a $args }
${function:gbd} = { git branch -d $args }
${function:gbD} = { git branch -D $args }
${function:gbl} = { git blame -b -w $args }
${function:gbnm} = { git branch --no-merged $args }
${function:gbr} = { git branch --remote $args }

${function:gc} = { git commit -v $args }
${function:gc!} = { git commit -v --amend $args }
${function:gcn!} = { git commit -v --no-edit --amend $args }
${function:gca} = { git commit -v -a $args }
${function:gca!} = { git commit -v -a --amend $args }
${function:gcan!} = { git commit -v -a --no-edit --amend $args }
${function:gcans!} = { git commit -v -a -s --no-edit --amend $args }
${function:gcam} = { git commit -a -m $args }
${function:gcsm} = { git commit -s -m $args }
${function:gcas} = { git commit -a -s $args }
${function:gcasm} = { git commit -a -s -m $args }
${function:gcb} = { git checkout -b $args }
${function:gcf} = { git config -l $args }

${function:gcl} = { git clone --recurse-submodules $args }
${function:gclean} = { git clean -id $args }
${function:gpristine} = { git reset --hard && git clean -dffx }
${function:gcm} = { git checkout $(git_main_branch) $args }
${function:gcd} = { git checkout $(git_develop_branch) $args }
${function:gcmsg} = { git commit -m $args }
${function:gco} = { git checkout $args }
${function:gcor} = { git checkout --recurse-submodules $args }
${function:gcount} = { git shortlog -sn $args }
${function:gcp} = { git cherry-pick $args }
${function:gcpa} = { git cherry-pick --abort}
${function:gcpc} = { git cherry-pick --continue }
${function:gcs} = { git commit -S $args }
${function:gcss} = { git commit -S -s $args }
${function:gcssm} = { git commit -S -s -m $args }

${function:gd} = { git diff $args }
${function:gdca} = { git diff --cached $args }
${function:gdcw} = { git diff --cached --word-diff $args }
${function:gdct} = { git describe --tags $(git rev-list --tags --max-count=1) $args }
${function:gds} = { git diff --staged $args }
${function:gdt} = { git diff-tree --no-commit-id --name-only -r $args }
${function:gdup} = { git diff '@{upstream}' $args }
${function:gdw} = { git diff --word-diff $args }

${function:gf} = { git fetch $args }
${function:gfa} = { git fetch --all --prune --jobs=10 $args }
${function:gfo} = { git fetch origin $args }

${function:gfg} = { git ls-files | Select-String -Pattern $args }

${function:gg} = { git gui citool $args }
${function:gga} = { git gui citool --amend $args }

${function:ggpull} = { git pull origin $(git_current_branch) $args }
${function:ggpush} = { git push origin $(git_current_branch) $args }

${function:ggsup} = { git branch --set-upstream-to=origin/$(git_current_branch) $args }
${function:gpsup} = { git push --set-upstream origin $(git_current_branch) $args }

${function:ghh} = { git help $args }

${function:gignore} = { git update-index --assume-unchanged $args }
${function:gignored} = { git ls-files -v | Select-String -CaseSensitive -Pattern '^[a-z].*$' }

${function:gk} = { gitk --all --branches $args }
${function:gke} = { gitk --all $(git log -g --pretty=%h) $args }

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

${function:gm} = { git merge $args }
${function:gmom} = { git merge origin/$(git_main_branch) $args }
${function:gmum} = { git merge upstream/$(git_main_branch) $args }
${function:gma} = { git merge --abort $args }

Remove-Alias -Name 'gp' -Force
${function:gp} = { git push $args }
${function:gpd} = { git push --dry-run $args }
${function:gpf} = { git push --force-with-lease $args }
${function:gpf!} = { git push --force $args }
${function:gpoat} = { git push origin --all && git push origin --tags }
${function:gpr} = { git pull --rebase $args }
${function:gpu} = { git push upstream $args }
${function:gpv} = { git push -v $args }

${function:gr} = { git remote $args }
${function:gra} = { git remote add $args }
${function:grb} = { git rebase $args }
${function:grba} = { git rebase --abort $args }
${function:grbc} = { git rebase --continue $args }
${function:grbd} = { git rebase $(git_develop_branch) $args }
${function:grbi} = { git rebase -i $args }
${function:grbm} = { git rebase $(git_main_branch) $args }
${function:grbom} = { git rebase origin/$(git_main_branch) $args }
${function:grbo} = { git rebase --onto $args }
${function:grbs} = { git rebase --skip $args }
${function:grev} = { git revert $args }
${function:grh} = { git reset $args }
${function:grhh} = { git reset --hard $args }
${function:groh} = { git reset origin/$(git_current_branch) --hard $args }
${function:grm} = { git rm $args }
${function:grmc} = { git rm --cached $args }
${function:grmv} = { git remote rename $args }
${function:grrm} = { git remote remove $args }
${function:grs} = { git restore $args }
${function:grset} = { git remote set-url $args }
${function:grss} = { git restore --source $args }
${function:grst} = { git restore --staged $args }
${function:grt} = { Set-Location $(git rev-parse --show-toplevel) }
# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_special_characters#stop-parsing-token---
${function:gru} = { git reset -- $args } # --%
${function:grup} = { git remote update $args }
${function:grv} = { git remote -v $args }

${function:gsb} = { git status -sb $args }
${function:gsh} = { git show $args }
${function:gsi} = { git submodule init $args }
${function:gsps} = { git show --pretty=short --show-signature $args }
${function:gss} = { git status -s $args }
${function:gst} = { git status $args }

${function:gsta} = { git stash push $args }
${function:gstaa} = { git stash apply $args }
${function:gstc} = { git stash clear $args }
${function:gstd} = { git stash drop $args }
${function:gstl} = { git stash list $args }
${function:gstp} = { git stash pop $args }
${function:gsts} = { git stash show --text $args }
${function:gstu} = { git stash push --include-untracked $args }
${function:gstall} = { git stash --all $args }
${function:gsu} = { git submodule update $args }
${function:gsw} = { git switch $args }
${function:gswc} = { git switch -c $args }
${function:gswm} = { git switch $(git_main_branch) $args }
${function:gswd} = { git switch $(git_develop_branch) $args }

${function:gts} = { git tag -s $args }
${function:gtv} = { git tag | Sort-Object }
${function:gtl} = { git tag --sort=-v:refname -n -l $args }

${function:gunignore} = { git update-index --no-assume-unchanged $args }
${function:gunwip} = { if (git log -n 1 | Select-String -Pattern '--wip--') { git reset HEAD~1 }}
${function:gup} = { git pull --rebase $args }
${function:gupv} = { git pull --rebase -v $args }
${function:gupa} = { git pull --rebase --autostash $args }
${function:gupav} = { git pull --rebase --autostash -v $args }
${function:glum} = { git pull upstream $(git_main_branch) $args }

${function:gwch} = { git whatchanged -p --abbrev-commit --pretty=medium $args }
${function:gwip} = { git add -A; git rm $(git ls-files --deleted) 2>&1 | Out-Null; git commit --no-verify --no-gpg-sign -m '--wip-- [skip ci]' }
