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
echo "Будет создан пользователь gpt_bot. Вам будет предложено ввести и подтвердить UNIX пароль, а также заполнить дополнительную информацию о пользователе. Обязательно требуется точно ввести и повторить пароль, остальные данные - просто нажимайте enter";
adduser gpt_bot && echo "Пользователь gpt_bot создан"

# switch to non-root user & configure user environment
sudo apt install python3-virtualenv -y && echo "python3-virtualenv установлен"
runuser -l gpt_bot -c "export PATH=$HOME/.local/bin:$PATH" && echo "HOME path установлено"
runuser -l gpt_bot -c "virtualenv --system-site-packages python" && echo "virtualenv configured"
runuser -l gpt_bot -c "source ~/python/bin/activate" && echo "line 31 passed"
runuser -l gpt_bot -c "pip install openai telebot datetime --break-system-packages" && echo "Требуемые модули библиотек python подключены."

# change user
# sudo su

# create env & set api tokens
touch .env
echo "                                 _____  "  
echo "________________________________ ___(_) "
echo "_  __ \__  __ \  _ \_  __ \  __  /_  /  "              
echo "/ /_/ /_  /_/ /  __/  / / / /_/ /_  /   "             
echo "\____/_  .___/\___//_/ /_/\__,_/ /_/    "            
echo "      /_/                               "  
echo "****************************************"
echo "Введите токен, полученный на сайте openai.com:"
read OPENAI_TOKEN
echo ""
echo "_____     ______                                       "
echo "__  /________  /___________ _____________ _______ ___  "
echo "_  __/  _ \_  /_  _ \_  __  /_  ___/  __  /_  __  __ \ "
echo "/ /_ /  __/  / /  __/  /_/ /_  /   / /_/ /_  / / / / / "
echo "\__/ \___//_/  \___/_\__, / /_/    \__,_/ /_/ /_/ /_/  "
echo "                    /____/                             "
echo "*******************************************************"
echo "Введите токен, полученный в Telegram от @botFather:"
read TG_TOKEN
echo "OPENAI_TOKEN=$OPENAI_TOKEN" > .env && echo "openai токен установлен"
echo "TG_TOKEN=$TG_TOKEN" >> .env && echo "telegram токен установен" && echo "Переменные окружения установлены."

# install watchdog daemon systemctl service
cat > /etc/systemd/system/laps-gpt-bot.service << EOF
[Unit]
Description=L.A.P.S. GPT Bot v1.1
After=syslog.target
After=network.target

[Service]
Type=simple
User=gpt_bot
WorkingDirectory=/home/gpt
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
