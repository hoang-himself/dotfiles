alias vx='deactivate'

function va {
  local venv_path="${1:-.venv}"
  local requirements_file='requirements.txt'

  local python_cmd
  if command -v python >/dev/null 2>&1; then
    python_cmd=python
  else
    echo 'Error: python command not found in PATH' >&2
    return 1
  fi

  if [[ -d "$venv_path" ]]; then
    if [[ -f "$venv_path/bin/activate" ]]; then
      source "$venv_path/bin/activate"
      return
    fi
    echo "Error: virtual environment exists but activation script not found at: $venv_path/bin/activate" >&2
    return 1
  fi

  "$python_cmd" -m venv --upgrade-deps "$venv_path"

  if [[ ! -f "$venv_path/bin/activate" ]]; then
    echo "Error: failed to create virtual environment at: $venv_path" >&2
    return 1
  fi

  source "$venv_path/bin/activate"
  "$venv_path/bin/pip" install wheel

  if [[ -f "$requirements_file" ]]; then
    "$venv_path/bin/pip" install -r "$requirements_file"
  fi
}
