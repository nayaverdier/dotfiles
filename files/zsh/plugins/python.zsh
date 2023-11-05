# get rid of __pycache__
export PYTHONDONTWRITEBYTECODE=1

# powerlevel10k shows the virtualenv already
export VIRTUAL_ENV_DISABLE_PROMPT=true

# allow square brackets without quotes in pip commands
alias pip="noglob pip"

function chpwd() {
  if [[ -n "$VIRTUAL_ENV" ]] ; then
    venv_path=${VIRTUAL_ENV#$HOME/.venvs/}
    if [[ "$PWD" != "$HOME/$venv_path"* ]] ; then
      echo "Deactivating venv $VIRTUAL_ENV"
      deactivate
    else
    fi
  fi

  if [[ -z "$VIRTUAL_ENV" ]] && [[ $PWD != "/" ]]; then
      venv_dir=${PWD/$HOME/$HOME/.venvs}
      if [[ -d "$venv_dir/bin" ]] ; then
        echo "Activating venv $venv_dir"
        source "$venv_dir/bin/activate"
      fi
  fi
}

function revenv() {
  if [[ -n "$VIRTUAL_ENV" ]]; then
    deactivate || return 1
  fi

  venv_dir=${PWD/$HOME/$HOME/.venvs}
  echo "Creating venv in $venv_dir"

  if [[ -d "$venv_dir" ]]; then
    rm -rf "$venv_dir" || return 1
  fi

  python3 -m venv "$venv_dir" || return 1
  . "$venv_dir/bin/activate" || return 1

  pip install --upgrade pip
  if [[ -f "requirements-dev.txt" ]]; then
    pip install -r requirements-dev.txt --no-deps || return 1
    pip install -e . --no-deps || return 1
  elif [[ -f "requirements.txt" ]]; then
    pip install -r requirements.txt --no-deps || return 1
    pip install -e . --no-deps || return 1
  else
    pip install -e ".[dev]" || return 1
  fi
}

function chal() {
  port=${1:-8000}
  pushd $(dirname `find . -type d -name ".chalice"`)
  chalice local --host 0.0.0.0 --port "$port"
  popd
}

function pyv() {
    pip install --use-deprecated=legacy-resolver --break-system-packages "$1==" 2>&1 | grep -oP "(?<=from versions: ).*(?=\))"
}
