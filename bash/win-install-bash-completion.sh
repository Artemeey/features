# Установка утилиты bash-completion для Git Bash на Windows
# Полезная утилита для автодополнения команд в консоли
win_install_bash_completion(){
  # Проверить, что скрипт запущен в Git Bash
  if [[ -z ${MSYSTEM:-} ]]; then
    echo "Ошибка: этот скрипт необходимо запускать в Git Bash."
    exit 1
  fi

  # Перейти во временный каталог
  cd /tmp || exit

  # Скачать bash-completion 2.18.0
  curl -L \
    -o bash-completion-2.18.0.tar.xz \
    https://github.com/scop/bash-completion/releases/download/2.18.0/bash-completion-2.18.0.tar.xz

  # Распаковать архив
  tar -xf bash-completion-2.18.0.tar.xz

  # Перейти в каталог bash-completion
  cd bash-completion-2.18.0 || exit

  # Создать пользовательский каталог установки
  mkdir -p "$HOME/.local/share/bash-completion"

  # Скопировать основной файл
  cp \
    bash_completion \
    "$HOME/.local/share/bash-completion/bash_completion"

  # Скопировать каталоги completion
  cp -r \
    completions \
    completions-core \
    completions-fallback \
    helpers \
    helpers-core \
    startup \
    startup-core \
    "$HOME/.local/share/bash-completion/"

  # Добавить загрузку bash-completion в .bashrc
  if ! grep -Fq '# Load bash-completion' "$HOME/.bashrc"; then
    cat >> "$HOME/.bashrc" <<'EOF'

# Load bash-completion
if [[ -n $PS1 && -z ${BASH_COMPLETION_VERSINFO:-} && -f "$HOME/.local/share/bash-completion/bash_completion" ]]; then
  # shellcheck source=/dev/null
  . "$HOME/.local/share/bash-completion/bash_completion"
fi
EOF
  fi

  # Применить конфигурацию
  source "$HOME/.bashrc"

  bash -ic '
    type _completion_loader
    echo "${BASH_COMPLETION_VERSINFO[*]}"
    complete -p git
  '
}

win_install_bash_completion
