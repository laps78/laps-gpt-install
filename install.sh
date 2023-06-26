#!/bin/bash

# initial actions
echo "Запуск скрипта установщика бота на сервер ubuntu..."
echo "***********************************************************************"
echo "* ______   _______   ________  ________        ______        ______   *"
echo "* ___  /   ___    |  ___  __ \ __  ___/        ___  / ______ ___  /_  *"
echo "* __  /    __  /| |  __  /_/ / _____ \         __  /  _  __  /_  __ \ *"
echo "* _  /______  ___ |___  ____/______/ /__       _  /___/ /_/ /_  /_/ / *"
echo "* /_____/(_)_/  |_|(_)_/    _(_)____/_(_)      /_____/\__,_/ /_.___/  *"
echo "*                                                                     *"
echo "***********************************************************************"


echo "L.A.P.S. GPT TELEGRAM BOT ATOMATIC INSTALLER FOR SPRINTBOX v0.1:"
echo "init..."

# install required system packages
sudo apt update && sudo apt upgrade -y
sudo apt install python3-pip -y && sudo apt autoremove -y

# create bot user
echo "============================================================"
echo "|| СОЗДАНИЕ ПОЛЬЗОВАТЕЛЯ НА СЕРВЕРЕ      <<< L.A.P.S. Lab ||"
echo "||--------------------------------------------------------||"
echo "|| Будет создан пользователь gpt_bot. Вам будет предложено||"
echo "|| ввести и подтвердить UNIX пароль, а также заполнить    ||"
echo "|| дополнительную информацию о пользователе. Обязательно  ||"
echo "|| требуется точно ввести и повторить пароль, остальные   ||"
echo "|| данные можно не указывать - просто нажимайте [enter].  ||"
echo "============================================================"
adduser gpt_bot && echo "Пользователь gpt_bot создан"

# switch to non-root user & configure user environment
sudo apt install python3-virtualenv -y && echo "python3-virtualenv установлен"
runuser -l gpt_bot -c "export PATH=$HOME/.local/bin:$PATH" && echo "HOME path установлено"
runuser -l gpt_bot -c "virtualenv --system-site-packages python" && echo "virtualenv configured"
#runuser -l gpt_bot -c "source ~/python/bin/activate" && echo "line 31 passed"
runuser -l gpt_bot -c "cd ~ && source python/bin/activate && pip install openai telebot datetime" && echo "Требуемые модули библиотек python подключены."


# additions from support tickets
mv /root/laps-gpt-install/gpt-bot.py /home/gpt_bot/gpt-bot.py
chown gpt_bot:gpt_bot /home/gpt_bot/gpt-bot.py

# create env & set api tokens
touch .env
echo "============================================================"
echo "|| ПОДКЛЮЧЕНИЕ К API OPENAI              <<< L.A.P.S. Lab ||"
echo "||--------------------------------------------------------||"
echo "||                                 _____                  ||"  
echo "|| ________________________________ ___{_}                ||"
echo "|| _  __ \__  __ \  _ \_  __ \  __  /_  /                 ||"              
echo "|| / /_/ /_  /_/ /  __/  / / / /_/ /_  /                  ||"             
echo "|| \____/_  .___/\___//_/ /_/\__,_/ /_/                   ||"            
echo "||       /_/                                              ||"  
echo "||********************************************************||"
echo "|| Введите токен, полученный на сайте openai.com:         ||"
echo "============================================================"
read OPENAI_TOKEN
echo ""
echo "============================================================"
echo "|| ПОДКЛЮЧЕНИЕ К API TELEGRAM            <<< L.A.P.S. Lab ||"
echo "||--------------------------------------------------------||"
echo "||  _____     ______                                      ||"
echo "||  __  /________  /___________ _____________ _______ ___ ||"
echo "|| _  __/  _ \_  /_  _ \_  __  /_  ___/  __  /_  __  __ \ ||"
echo "|| / /_ /  __/  / /  __/  /_/ /_  /   / /_/ /_  / / / / / ||"
echo "|| \__/ \___//_/  \___/_\__, / /_/    \__,_/ /_/ /_/ /_/  ||"
echo "||                     /____/                             ||"
echo "||********************************************************||"
echo "|| Введите токен, полученный в Telegram от @botFather:    ||"
echo "============================================================"
read TG_TOKEN
echo "OPENAI_TOKEN=$OPENAI_TOKEN" > .env && echo "openai токен установлен"
echo "TG_TOKEN=$TG_TOKEN" >> .env && echo "telegram токен установен" && echo "Переменные окружения записаны."

mv /root/laps-gpt-install/.env /home/gpt_bot/.env && echo "Файл окружения перенесен в корневую папку приложения."
chown gpt_bot:gpt_bot /home/gpt_bot/.env && echo "Права на файл окружения переданы пользователю бота."

# install watchdog daemon systemctl service
cat > /etc/systemd/system/laps-gpt-bot.service << EOF
[Unit]
Description=L.A.P.S. GPT Bot v1.1
After=syslog.target
After=network.target

[Service]
Type=simple
User=gpt_bot
WorkingDirectory=/home/gpt_bot
ExecStart=python3 gpt-bot.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload && systemctl enable laps-gpt-bot && systemctl start laps-gpt-bot && echo "Демон настроен и активирован";

# final commands
echo "Установка завершена."
echo "запрос текущего состояния бота:"
systemctl status laps-gpt-bot

# TODO разберитесь, почемо не работает системный демон!