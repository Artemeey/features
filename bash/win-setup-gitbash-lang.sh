# Настроить LANG в Git Bash, если переменная пустая или задана как null.
# Без UTF-8 локали Git Bash некорректно удаляет кириллицу в терминале.
win_setup_gitbash_lang() {
  # Проверить, что скрипт запущен в Git Bash
  if [[ -z ${MSYSTEM:-} ]]; then
    echo "Ошибка: этот скрипт необходимо запускать в Git Bash."
    exit 1
  fi

	local system_name
	local bashrc="$HOME/.bashrc"

	system_name="$(uname -s)"

	# Только для Git Bash
	if [[ "$system_name" != MINGW* && "$system_name" != MSYS* ]]; then
		return 0
	fi

	# Проверяем, что LANG не задан
	if [[ -n "${LANG:-}" && "${LANG:-}" != "null" && "${LANG:-}" != "NULL" ]]; then
		return 0
	fi

	# Не менять настройки Bash, если LANG уже явно указан
	if [[ -f "$bashrc" ]] && grep -Eq '^[[:space:]]*(export[[:space:]]+)?LANG=' "$bashrc"; then
		return 0
	fi

	# Закрепить UTF-8 локаль для новых сессий Git Bash
	printf '\n' >> "$bashrc"
	printf '# UTF-8 локаль нужна Git Bash для корректного удаления кириллицы в терминале\n' >> "$bashrc"
	printf 'export LANG=C.UTF-8\n' >> "$bashrc"

	echo_success "$DOCTOR_PREFIX В ~/.bashrc добавлен LANG=C.UTF-8. Перезапустите консоль."
}

win_setup_gitbash_lang
