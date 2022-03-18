# function __git_prompt_git {
#   GIT_OPTIONAL_LOCKS=0 git "$@"
# }

# function git_prompt_info() {
#   # If we are on a folder not tracked by git, get out.
#   # Otherwise, check for hide-info at global and local repository level
#   if ! __git_prompt_git rev-parse --git-dir &> /dev/null \
#      || [[ "$(__git_prompt_git config --get oh-my-zsh.hide-info 2>/dev/null)" == 1 ]]; then
#     return 0
#   fi

#   local ref
#   ref=$(__git_prompt_git symbolic-ref --short HEAD 2> /dev/null) \
#   || ref=$(__git_prompt_git rev-parse --short HEAD 2> /dev/null) \
#   || return 0

#   # Use global ZSH_THEME_GIT_SHOW_UPSTREAM=1 for including upstream remote info
#   local upstream
#   if (( ${+ZSH_THEME_GIT_SHOW_UPSTREAM} )); then
#     upstream=$(__git_prompt_git rev-parse --abbrev-ref --symbolic-full-name "@{upstream}" 2>/dev/null) \
#     && upstream=" -> ${upstream}"
#   fi

#   echo "${ZSH_THEME_GIT_PROMPT_PREFIX}${ref:gs/%/%%}${upstream:gs/%/%%}$(parse_git_dirty)${ZSH_THEME_GIT_PROMPT_SUFFIX}"
# }

# # Checks if working tree is dirty
# function parse_git_dirty() {
#   local STATUS
#   local -a FLAGS
#   FLAGS=('--porcelain')
#   if [[ "$(__git_prompt_git config --get oh-my-zsh.hide-dirty)" != "1" ]]; then
#     if [[ "${DISABLE_UNTRACKED_FILES_DIRTY:-}" == "true" ]]; then
#       FLAGS+='--untracked-files=no'
#     fi
#     case "${GIT_STATUS_IGNORE_SUBMODULES:-}" in
#       git)
#         # let git decide (this respects per-repo config in .gitmodules)
#         ;;
#       *)
#         # if unset: ignore dirty submodules
#         # other values are passed to --ignore-submodules
#         FLAGS+="--ignore-submodules=${GIT_STATUS_IGNORE_SUBMODULES:-dirty}"
#         ;;
#     esac
#     STATUS=$(__git_prompt_git status ${FLAGS} 2> /dev/null | tail -n 1)
#   fi
#   if [[ -n $STATUS ]]; then
#     echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
#   else
#     echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
#   fi
# }

# # Gets the difference between the local and remote branches
# function git_remote_status() {
#     local remote ahead behind git_remote_status git_remote_status_detailed
#     remote=${$(__git_prompt_git rev-parse --verify ${hook_com[branch]}@{upstream} --symbolic-full-name 2>/dev/null)/refs\/remotes\/}
#     if [[ -n ${remote} ]]; then
#         ahead=$(__git_prompt_git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
#         behind=$(__git_prompt_git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)

#         if [[ $ahead -eq 0 ]] && [[ $behind -eq 0 ]]; then
#             git_remote_status="$ZSH_THEME_GIT_PROMPT_EQUAL_REMOTE"
#         elif [[ $ahead -gt 0 ]] && [[ $behind -eq 0 ]]; then
#             git_remote_status="$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE"
#             git_remote_status_detailed="$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE_COLOR$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE$((ahead))%{$reset_color%}"
#         elif [[ $behind -gt 0 ]] && [[ $ahead -eq 0 ]]; then
#             git_remote_status="$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE"
#             git_remote_status_detailed="$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE_COLOR$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE$((behind))%{$reset_color%}"
#         elif [[ $ahead -gt 0 ]] && [[ $behind -gt 0 ]]; then
#             git_remote_status="$ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE"
#             git_remote_status_detailed="$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE_COLOR$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE$((ahead))%{$reset_color%}$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE_COLOR$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE$((behind))%{$reset_color%}"
#         fi

#         if [[ -n $ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_DETAILED ]]; then
#             git_remote_status="$ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_PREFIX${remote:gs/%/%%}$git_remote_status_detailed$ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_SUFFIX"
#         fi

#         echo $git_remote_status
#     fi
# }

# # Outputs the name of the current branch
# # Usage example: git pull origin $(git_current_branch)
# # Using '--quiet' with 'symbolic-ref' will not cause a fatal error (128) if
# # it's not a symbolic ref, but in a Git repo.
# function git_current_branch() {
#   local ref
#   ref=$(__git_prompt_git symbolic-ref --quiet HEAD 2> /dev/null)
#   local ret=$?
#   if [[ $ret != 0 ]]; then
#     [[ $ret == 128 ]] && return  # no git repo.
#     ref=$(__git_prompt_git rev-parse --short HEAD 2> /dev/null) || return
#   fi
#   echo ${ref#refs/heads/}
# }


# # Gets the number of commits ahead from remote
# function git_commits_ahead() {
#   if __git_prompt_git rev-parse --git-dir &>/dev/null; then
#     local commits="$(__git_prompt_git rev-list --count @{upstream}..HEAD 2>/dev/null)"
#     if [[ -n "$commits" && "$commits" != 0 ]]; then
#       echo "$ZSH_THEME_GIT_COMMITS_AHEAD_PREFIX$commits$ZSH_THEME_GIT_COMMITS_AHEAD_SUFFIX"
#     fi
#   fi
# }

# # Gets the number of commits behind remote
# function git_commits_behind() {
#   if __git_prompt_git rev-parse --git-dir &>/dev/null; then
#     local commits="$(__git_prompt_git rev-list --count HEAD..@{upstream} 2>/dev/null)"
#     if [[ -n "$commits" && "$commits" != 0 ]]; then
#       echo "$ZSH_THEME_GIT_COMMITS_BEHIND_PREFIX$commits$ZSH_THEME_GIT_COMMITS_BEHIND_SUFFIX"
#     fi
#   fi
# }

# # Outputs if current branch is ahead of remote
# function git_prompt_ahead() {
#   if [[ -n "$(__git_prompt_git rev-list origin/$(git_current_branch)..HEAD 2> /dev/null)" ]]; then
#     echo "$ZSH_THEME_GIT_PROMPT_AHEAD"
#   fi
# }

# # Outputs if current branch is behind remote
# function git_prompt_behind() {
#   if [[ -n "$(__git_prompt_git rev-list HEAD..origin/$(git_current_branch) 2> /dev/null)" ]]; then
#     echo "$ZSH_THEME_GIT_PROMPT_BEHIND"
#   fi
# }

# # Outputs if current branch exists on remote or not
# function git_prompt_remote() {
#   if [[ -n "$(__git_prompt_git show-ref origin/$(git_current_branch) 2> /dev/null)" ]]; then
#     echo "$ZSH_THEME_GIT_PROMPT_REMOTE_EXISTS"
#   else
#     echo "$ZSH_THEME_GIT_PROMPT_REMOTE_MISSING"
#   fi
# }

# # Formats prompt string for current git commit short SHA
# function git_prompt_short_sha() {
#   local SHA
#   SHA=$(__git_prompt_git rev-parse --short HEAD 2> /dev/null) && echo "$ZSH_THEME_GIT_PROMPT_SHA_BEFORE$SHA$ZSH_THEME_GIT_PROMPT_SHA_AFTER"
# }

# # Formats prompt string for current git commit long SHA
# function git_prompt_long_sha() {
#   local SHA
#   SHA=$(__git_prompt_git rev-parse HEAD 2> /dev/null) && echo "$ZSH_THEME_GIT_PROMPT_SHA_BEFORE$SHA$ZSH_THEME_GIT_PROMPT_SHA_AFTER"
# }

# function git_prompt_status() {
#   [[ "$(__git_prompt_git config --get oh-my-zsh.hide-status 2>/dev/null)" = 1 ]] && return

#   # Maps a git status prefix to an internal constant
#   # This cannot use the prompt constants, as they may be empty
#   local -A prefix_constant_map
#   prefix_constant_map=(
#     '\?\? '     'UNTRACKED'
#     'A  '       'ADDED'
#     'M  '       'ADDED'
#     'MM '       'MODIFIED'
#     ' M '       'MODIFIED'
#     'AM '       'MODIFIED'
#     ' T '       'MODIFIED'
#     'R  '       'RENAMED'
#     ' D '       'DELETED'
#     'D  '       'DELETED'
#     'UU '       'UNMERGED'
#     'ahead'     'AHEAD'
#     'behind'    'BEHIND'
#     'diverged'  'DIVERGED'
#     'stashed'   'STASHED'
#   )

#   # Maps the internal constant to the prompt theme
#   local -A constant_prompt_map
#   constant_prompt_map=(
#     'UNTRACKED' "$ZSH_THEME_GIT_PROMPT_UNTRACKED"
#     'ADDED'     "$ZSH_THEME_GIT_PROMPT_ADDED"
#     'MODIFIED'  "$ZSH_THEME_GIT_PROMPT_MODIFIED"
#     'RENAMED'   "$ZSH_THEME_GIT_PROMPT_RENAMED"
#     'DELETED'   "$ZSH_THEME_GIT_PROMPT_DELETED"
#     'UNMERGED'  "$ZSH_THEME_GIT_PROMPT_UNMERGED"
#     'AHEAD'     "$ZSH_THEME_GIT_PROMPT_AHEAD"
#     'BEHIND'    "$ZSH_THEME_GIT_PROMPT_BEHIND"
#     'DIVERGED'  "$ZSH_THEME_GIT_PROMPT_DIVERGED"
#     'STASHED'   "$ZSH_THEME_GIT_PROMPT_STASHED"
#   )

#   # The order that the prompt displays should be added to the prompt
#   local status_constants
#   status_constants=(
#     UNTRACKED ADDED MODIFIED RENAMED DELETED
#     STASHED UNMERGED AHEAD BEHIND DIVERGED
#   )

#   local status_text
#   status_text="$(__git_prompt_git status --porcelain -b 2> /dev/null)"

#   # Don't continue on a catastrophic failure
#   if [[ $? -eq 128 ]]; then
#     return 1
#   fi

#   # A lookup table of each git status encountered
#   local -A statuses_seen

#   if __git_prompt_git rev-parse --verify refs/stash &>/dev/null; then
#     statuses_seen[STASHED]=1
#   fi

#   local status_lines
#   status_lines=("${(@f)${status_text}}")

#   # If the tracking line exists, get and parse it
#   if [[ "$status_lines[1]" =~ "^## [^ ]+ \[(.*)\]" ]]; then
#     local branch_statuses
#     branch_statuses=("${(@s/,/)match}")
#     for branch_status in $branch_statuses; do
#       if [[ ! $branch_status =~ "(behind|diverged|ahead) ([0-9]+)?" ]]; then
#         continue
#       fi
#       local last_parsed_status=$prefix_constant_map[$match[1]]
#       statuses_seen[$last_parsed_status]=$match[2]
#     done
#   fi

#   # For each status prefix, do a regex comparison
#   for status_prefix in ${(k)prefix_constant_map}; do
#     local status_constant="${prefix_constant_map[$status_prefix]}"
#     local status_regex=$'(^|\n)'"$status_prefix"

#     if [[ "$status_text" =~ $status_regex ]]; then
#       statuses_seen[$status_constant]=1
#     fi
#   done

#   # Display the seen statuses in the order specified
#   local status_prompt
#   for status_constant in $status_constants; do
#     if (( ${+statuses_seen[$status_constant]} )); then
#       local next_display=$constant_prompt_map[$status_constant]
#       status_prompt="$next_display$status_prompt"
#     fi
#   done

#   echo $status_prompt
# }

# # Outputs the name of the current user
# # Usage example: $(git_current_user_name)
# function git_current_user_name() {
#   __git_prompt_git config user.name 2>/dev/null
# }

# # Outputs the email of the current user
# # Usage example: $(git_current_user_email)
# function git_current_user_email() {
#   __git_prompt_git config user.email 2>/dev/null
# }

# # Output the name of the root directory of the git repository
# # Usage example: $(git_repo_name)
# function git_repo_name() {
#   local repo_path
#   if repo_path="$(__git_prompt_git rev-parse --show-toplevel 2>/dev/null)" && [[ -n "$repo_path" ]]; then
#     echo ${repo_path:t}
#   fi
# }

Set-Alias -Name 'g' -Value 'git'
${function:ga} = { git add $args }
${function:gst} = { git status $args }
# ${function:gaa} = { git add --all $args }
# ${function:gap} = { git apply $args }
# ${function:gapa} = { git add --patch $args }
# ${function:gapt} = { git apply --3way $args }
# ${function:gau} = { git add --update $args }
# ${function:gav} = { git add --verbose $args }
# ${function:gb} = { git branch $args }
# ${function:gbD} = { git branch -D $args }
# ${function:gba} = { git branch -a $args }
# ${function:gbd} = { git branch -d $args }
# ${function:gbl} = { git blame -b -w $args }
# ${function:gbnm} = { git branch --no-merged $args }
# ${function:gbr} = { git branch --remote $args }
# ${function:gbs} = { git bisect $args }
# ${function:gbsb} = { git bisect bad $args }
# ${function:gbsg} = { git bisect good $args }
# ${function:gbsr} = { git bisect reset $args }
# ${function:gbss} = { git bisect start $args }
# ${function:gc} = { git commit -v $args }
# ${function:gc!} = { git commit -v --amend $args }
# ${function:gca} = { git commit -v -a $args }
# ${function:gca!} = { git commit -v -a --amend $args }
${function:gcam} = { git commit -a -m $args }
# ${function:gcan!} = { git commit -v -a --no-edit --amend $args }
# ${function:gcans!} = { git commit -v -a -s --no-edit --amend $args }
# ${function:gcas} = { git commit -a -s $args }
# ${function:gcasm} = { git commit -a -s -m $args }
# ${function:gcb} = { git checkout -b $args }
# ${function:gcd} = { git checkout $(git_develop_branch) $args }
# ${function:gcf} = { git config --list $args }
# ${function:gcl} = { git clone --recurse-submodules $args }
# ${function:gclean} = { git clean -id $args }
# ${function:gcm} = { git checkout $(git_main_branch) $args }
# ${function:gcmsg} = { git commit -m $args }
# ${function:gcn!} = { git commit -v --no-edit --amend $args }
# ${function:gco} = { git checkout $args }
# ${function:gcor} = { git checkout --recurse-submodules $args }
# ${function:gcount} = { git shortlog -sn $args }
# ${function:gcp} = { git cherry-pick $args }
# ${function:gcpa} = { git cherry-pick --abort $args }
# ${function:gcpc} = { git cherry-pick --continue $args }
# ${function:gcs} = { git commit -S $args }
# ${function:gcsm} = { git commit -s -m $args }
# ${function:gcss} = { git commit -S -s $args }
# ${function:gcssm} = { git commit -S -s -m $args }
# ${function:gd} = { git diff $args }
# ${function:gdca} = { git diff --cached $args }
# ${function:gdct} = { git describe --tags $(git rev-list --tags --max-count=1) $args }
# ${function:gdcw} = { git diff --cached --word-diff $args }
# ${function:gds} = { git diff --staged $args }
# ${function:gdt} = { git diff-tree --no-commit-id --name-only -r $args }
# ${function:gdup} = { git diff @{upstream} $args }
# ${function:gdw} = { git diff --word-diff $args }
# ${function:gf} = { git fetch $args }
# ${function:gfa} = { git fetch --all --prune --jobs=10 $args }
# ${function:gfg} = { git ls-files | grep $args }
# ${function:gfo} = { git fetch origin $args }
# ${function:gg} = { git gui citool $args }
# ${function:gga} = { git gui citool --amend $args }
# ${function:ggpull} = { git pull origin "$(git_current_branch)" $args }
# ${function:ggpush} = { git push origin "$(git_current_branch)" $args }
# ${function:ggsup} = { git branch --set-upstream-to=origin/$(git_current_branch) $args }
# ${function:ghh} = { git help $args }
# ${function:gignore} = { git update-index --assume-unchanged $args }
# ${function:gignored} = { git ls-files -v | grep "^[[:lower:]]" $args }
# ${function:git-svn-dcommit-push} = { git svn dcommit && git push github $(git_main_branch):svntrunk $args }
# ${function:gk} = { \gitk --all --branches &! $args }
# ${function:gke} = { \gitk --all $(git log -g --pretty=%h) &! $args }
# ${function:gl} = { git pull $args }
# ${function:glfsi} = { git lfs install $args }
# ${function:glfsls} = { git lfs ls-files $args }
# ${function:glfsmi} = { git lfs migrate import --include= $args }
# ${function:glfst} = { git lfs track $args }
# ${function:glg} = { git log --stat $args }
# ${function:glgg} = { git log --graph $args }
# ${function:glgga} = { git log --graph --decorate --all $args }
# ${function:glgm} = { git log --graph --max-count=10 $args }
# ${function:glgp} = { git log --stat -p $args }
# ${function:glo} = { git log --oneline --decorate $args }
# ${function:globurl} = { noglob urlglobber  $args }
# ${function:glog} = { git log --oneline --decorate --graph $args }
# ${function:gloga} = { git log --oneline --decorate --graph --all $args }
# glp=_git_log_prettily
# ${function:glum} = { git pull upstream $(git_main_branch) $args }
# ${function:gm} = { git merge $args }
# ${function:gma} = { git merge --abort $args }
# ${function:gmom} = { git merge origin/$(git_main_branch) $args }
# ${function:gmtl} = { git mergetool --no-prompt $args }
# ${function:gmtlvim} = { git mergetool --no-prompt --tool=vimdiff $args }
# ${function:gmum} = { git merge upstream/$(git_main_branch) $args }
# ${function:gp} = { git push $args }
# ${function:gpd} = { git push --dry-run $args }
# ${function:gpf} = { git push --force-with-lease $args }
# ${function:gpf!} = { git push --force $args }
# ${function:gpoat} = { git push origin --all && git push origin --tags $args }
# ${function:gpr} = { git pull --rebase $args }
# ${function:gpristine} = { git reset --hard && git clean -dffx $args }
# ${function:gpsup} = { git push --set-upstream origin $(git_current_branch) $args }
# ${function:gpu} = { git push upstream $args }
# ${function:gpv} = { git push -v $args }
# ${function:gr} = { git remote $args }
# ${function:gra} = { git remote add $args }
# ${function:grb} = { git rebase $args }
# ${function:grba} = { git rebase --abort $args }
# ${function:grbc} = { git rebase --continue $args }
# ${function:grbd} = { git rebase $(git_develop_branch) $args }
# ${function:grbi} = { git rebase -i $args }
# ${function:grbm} = { git rebase $(git_main_branch) $args }
# ${function:grbo} = { git rebase --onto $args }
# ${function:grbom} = { git rebase origin/$(git_main_branch) $args }
# ${function:grbs} = { git rebase --skip $args }
# ${function:grep} = { grep --color $args }
# ${function:grev} = { git revert $args }
# ${function:grh} = { git reset $args }
# ${function:grhh} = { git reset --hard $args }
# ${function:grm} = { git rm $args }
# ${function:grmc} = { git rm --cached $args }
# ${function:grmv} = { git remote rename $args }
# ${function:groh} = { git reset origin/$(git_current_branch) --hard $args }
# ${function:grrm} = { git remote remove $args }
# ${function:grs} = { git restore $args }
# ${function:grset} = { git remote set-url $args }
# ${function:grss} = { git restore --source $args }
# ${function:grst} = { git restore --staged $args }
# ${function:grt} = { cd "$(git rev-parse --show-toplevel || echo .)" $args }
# ${function:gru} = { git reset -- $args }
# ${function:grup} = { git remote update $args }
# ${function:grv} = { git remote -v $args }
# ${function:gsb} = { git status -sb $args }
# ${function:gsd} = { git svn dcommit $args }
# ${function:gsh} = { git show $args }
# ${function:gsi} = { git submodule init $args }
# ${function:gsps} = { git show --pretty=short --show-signature $args }
# ${function:gsr} = { git svn rebase $args }
# ${function:gss} = { git status -s $args }
# ${function:gst} = { git status $args }
# ${function:gsta} = { git stash push $args }
# ${function:gstaa} = { git stash apply $args }
# ${function:gstall} = { git stash --all $args }
# ${function:gstc} = { git stash clear $args }
# ${function:gstd} = { git stash drop $args }
# ${function:gstl} = { git stash list $args }
# ${function:gstp} = { git stash pop $args }
# ${function:gsts} = { git stash show --text $args }
# ${function:gstu} = { gsta --include-untracked $args }
# ${function:gsu} = { git submodule update $args }
# ${function:gsw} = { git switch $args }
# ${function:gswc} = { git switch -c $args }
# ${function:gswd} = { git switch $(git_develop_branch) $args }
# ${function:gswm} = { git switch $(git_main_branch) $args }
# ${function:gtl} = { gtl(){ git tag --sort=-v:refname -n -l "${1}*" }; noglob gtl $args }
# ${function:gts} = { git tag -s $args }
# ${function:gtv} = { git tag | sort -V $args }
# ${function:gunignore} = { git update-index --no-assume-unchanged $args }
# ${function:gunwip} = { git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1 $args }
# ${function:gup} = { git pull --rebase $args }
# ${function:gupa} = { git pull --rebase --autostash $args }
# ${function:gupav} = { git pull --rebase --autostash -v $args }
# ${function:gupv} = { git pull --rebase -v $args }
# ${function:gwch} = { git whatchanged -p --abbrev-commit --pretty=medium $args }
# ${function:gwip} = { git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign -m "--wip-- [skip ci]" $args }
