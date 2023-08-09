# L.A.P.S. chatGPT telegram бот

ChatGPT telegram бот - серверное приложение, предоставляющее доступ к функциональнсти ChatGPT прямо из Telegram без необходимости использования VPN. Приложение перенаправляет ваше сообщение (запрос) на сервер api OpenAI и по готовности ответа пересылает его пользователю также в виде сообщения Telegram.

Приложение хранит контекст предыдущей переписки в базе даных, иными словами: понит вашу переписку до момента выполнения команды **/refresh**

## Содержание

1. [Как зарегистрироваться в OpenAI ChatGPT из России и прочих подсанкционных регионов в 2023 году](#как-зарегистрироваться-в-openai-chatgpt-из-россии-и-прочих-подсанкционных-регионов-в-2023-году)
2. [Регистрация бота в Telegram](#регистрация-бота-в-telegram)
3. [Регистрация на хостинге и создание выделенного сервера SprintBOX](#регистрация-на-хостинге-и-создание-выделенного-сервера-sprintbox)
4. [Настройка выделенного сервера SprintBOX и деплой бота](#настройка-выделенного-сервера-sprintbox-и-деплой-бота)
5. [Команды Telegram интерфеса приложения](#команды-telegram-интерфеса-приложения)

## Как зарегистрироваться в OpenAI ChatGPT из России и прочих подсанкционных регионов в 2023 году

### 1. Что нужно сделать перед регистрацией

![Ой!](./assets/openai-error.webp)

Если вы уже пробовали зарегистрироваться и остановились на шаге с ошибкой, что в нашей стране регистрация не доступна, то теперь вам нужно почистить куки и кеш в браузере.

Как почистить куки и кеш в Google Chrome:

- Переходим в настройки (кликаем на 3 точки в правом верхнем углу)
- Справа кликаем на «Конфиденциальность и безопасность»
- Удаляем все данные за всё время

![Очистка кэш chrome](./assets/chrome-clear-cash.webp)

Чистим куки и кеш в Google Chrome

Если вы ещё не заходили на сайт OpenAI и не пробовали регистрироваться, то ничего чистить не нужно.

### 2. Используйте VPN для регистрации OpenAI

Включите VPN, подмените местоположение на страну не из санкционного списка. Запомните страну, так как позже нужно будет подтвердить создание аккаунта через прием СМС на одноразовый номер, входящий в зону телефонных номеров этой страны.

### 3. Зарегистрировать аккаунт [gmail](https://gmail.com)

Зарегистрируйте новую почту GMAIL указав ту страну, откуда идет ваш vpn-траффик

### 4. Перейдите на сайт openai.com, начните регистрацию

Нажмите "арегистрироваться", создайте аккаунт используя gmail почту из шага 3

![Регистрация OpenAI.com ](./assets/Openai-Com.png)
![Регистрация OpenAI.com - форма ](./assets/openai-new.webp)
![Регистрация OpenAI.com - имя, фамилия](./assets/openai-new-name.webp)

### 5. Перейдите на сайт sms-activate

Зарегистрируйтесь по ссылке: [sms-activate.ru](https://sms-activate.org/?ref=6834896), любым доступным способом. Выберите сервис для активации "ChatGPT" или "openai", выберите номер той страны, откуда идет ваш vpn траффик. Пополните любым удобным способом баланс на требуемую сумму как удобно, оплатите активацию.

![sms-activate.ru](./assets/sms-activate.png)

Укажите при создании openai аккаунта номер, который вы арендовали в sms-activate

![Регистрация OpenAI.com ](./assets/openai-new-phone.webp)

Дождитесь sms, вставьте sms код из окна sms-activate в окно openai, активируйте аккаунт

Перейдите в настройки аккаунта, найдите и скопируйте api_key openai:

1. Перейдите в личный кабинет OpenAI и нажмите на вкладку Personal в правом верхнем углу. В выпадающем списке выберите API keys.
   ![Где найти api-ключ openai](./assets/op-ai-token-get1.png)

2. Нажмите Create new secret key. Появится окно, в котором будет ваш API key. Скопируйте его, он потребуется при установке бота на сервер(инструкции далее по тексту).
   ![Создать новый api-ключ openai](./assets/op-ai-tokens.get2.png)

---

[Наверх](#содержание)

## Регистрация бота в Telegram

1. Зайдите в Telegram
2. Найдите чат [@Bot_father](https://t.me/@Bot_father)
3. Создайте бота и получите api_key telegram
4. Дальнейшие настройки бота (аватар, описание, и т.д.) - по усмотрению, инструкции найдете на месте

### Регистрация бота

Создание любого бота начинается сообщения отцу ботов в телеграме — [@Bot_father](https://t.me/@Bot_father).

Он может управлять всеми существующими ботами, с помощью множества команд. Их список в любой момент можно вызвать командой **/help**

![Скриншот сообщения help](./assets/botFather-help.png)

Для создания нового бота отправьте команду **/newbot**. После ответов на пару вопросов бот будет создан, а отец ботов пришлёт токен. Его нужно будет указывать в коде для взаимодействия с BotAPI.

Токен для каждого бота уникален. Нельзя, чтобы он попал в открытый доступ. Однако если это произошло, его всегда можно сменить через ботопапу командой **/revoke**.

Так будет выглядеть диалог создания бота:

![Пример диалога создания бота](./assets/botFather-create-bot.png)

Итак, бот зарегистрирован.

---

[Наверх](#содержание)

## Регистрация на хостинге и создание выделенного сервера SprintBOX

Идем по [ссылке на проверенный сервис VDS c промокодом на скидку или бонус](https://sprintbox.ru/promo/V74QI-42N9K-3H9SO) и регистрируемся, например, через тот же [gmail](https://gmail.com):

![Регистрация аккаунта SprintBOX](./assets/sprintbox-ui.png)

## Настройка выделенного сервера SprintBOX и деплой бота

Теперь, когда наш бокс создан, необходимо к нему удаленно подключиться через терминал или командную строку - в зависимости от вашей операционной системы.

### 1. Установите подключение по SSH

**_SSH_** — защищенный сетевой протокол. Он позволяет установить соединение по зашифрованному туннелю и управлять удаленным сервером. Для боксов с чистыми ОС — это основной способ взаимодействия с ними.

Для соединения с VDS используйте:

логин — root
пароль пользователя root, который пришел на почту в момент создания бокса
IP-адрес бокса — он тоже есть в письме, а еще можно посмотреть его в блоке управления боксом.

В современных ОС для подключения по SSH есть встроенные инструменты: в Linux и MacOS — программа «Терминал», в Windows — PowerShell.

Откройте программу и введите в адресную строку: ssh root@IP-адрес

![Введите команду](./assets/ssh-power-shell-1.png)

При первом подключении к серверу программа предупредит, что к этому хосту она еще не подключалась и попросит добавить его в список доверенных. Введите yes и нажмите Enter.

![Запрос на подключение](./assets/ssh-power-shell-2.png)

Дальше программа попросит пароль — он в письме, отправленном вам при создании бокса. Пароль можно скопировать и вставить или ввести вручную — символы отображаться не будут, даже замаскированными, так системы обеспечивают безопасность пароля.

![Программа просит пароль](./assets/ssh-power-shell-3.png)

При первом подключении система попросит изменить пароль. Сначала введите текущий — можно не вручную, а вставить его из буфера обмена. Символы по-прежнему не будут отображаться:

![Система просит изменить пароль](./assets/ssh-power-shell-4.png)

Дальше система попросит придумать новый пароль:

![Придумать новый пароль](./assets/ssh-power-shell-5.png)

И повторить его:

![Повторить новый пароль](./assets/ssh-power-shell-6.png)

Готово! Теперь можно работать с боксом:

![Все готово!](./assets/ssh-power-shell-7.png)

При следующих подключениях будет достаточно ввести команду ssh root@IP-адрес, а затем пароль. Подтверждать добавление хоста в список доверенных и менять пароль уже не нужно.

---

[Наверх](#содержание)

### 2. Клонируйте репозиторий проекта и сделайте install.sh исполняемым

Введите последовательно указанные ниже команды:

2.1. Клонируем репозиторий с проектом

```bash
git clone https://github.com/laps78/laps-gpt-install
```

2.2. Разрешаем исполнение инсталлятора (install.sh)

```bash
sudo chmod +x laps-gpt-install/install.sh
```

2.3. Запускаем инсталлятор (install.sh)

```bash
./laps-gpt-install/install.sh
```

Вы увидите начало процесса установки програмного обеспечения на удаленном сервере. Будут установлены обновления сборки серверного ПО и некоторые дополнительные пакеты, требуемые для работы приложения.

В процессе установки потребуестя ввести вручную или скопировать/вставить некоторые дополнительные данные. Читайте, что пишет инсталлятор дайте ему то, что он хочет.

ПРИМЕРЫ СООБЩЕНИЙ ИНСТАЛЛЯТОРА:

```txt
  ============================================================
  || СОЗДАНИЕ ПОЛЬЗОВАТЕЛЯ НА СЕРВЕРЕ      <<< L.A.P.S. Lab ||
  ||--------------------------------------------------------||
  || Будет создан пользователь gpt_bot. Вам будет предложено||
  || ввести и подтвердить UNIX пароль, а также заполнить    ||
  || дополнительную информацию о пользователе. Обязательно  ||
  || требуется точно ввести и повторить пароль, остальные   ||
  || данные можно не указывать - просто нажимайте [enter].  ||
  ============================================================
```

Далее инсталлятор предложит придумать пароль, повторить его ещё раз и заполнить информацию о новом пользователе. Все поля, кроме пароля, не обязательны, можно жать Enter для подстановки значения по умолчанию. При вводе паролей символы не будут отображаться - это нормально. Копипаста также сработает.

Далее потребуется установить значения api-токенов для работы с сервисами openai и Telegram:

```txt
  ============================================================
  || ПОДКЛЮЧЕНИЕ К API OPENAI              <<< L.A.P.S. Lab ||
  ||--------------------------------------------------------||
  ||                                 _____                  ||
  || ________________________________ ___{_}                ||
  || _  __ \__  __ \  _ \_  __ \  __  /_  /                 ||
  || / /_/ /_  /_/ /  __/  / / / /_/ /_  /                  ||
  || \____/_  .___/\___//_/ /_/\__,_/ /_/                   ||
  ||       /_/                                              ||
  ||********************************************************||
  || Введите токен, полученный на сайте openai.com:         ||
  ============================================================
```

Введите api-токен openai. Как получить api-токен openai указано [выше](#как-зарегистрироваться-в-openai-chatgpt-из-россии-и-прочих-подсанкционных-регионов-в-2023-году).

```txt
  ============================================================
  || ПОДКЛЮЧЕНИЕ К API TELEGRAM            <<< L.A.P.S. Lab ||
  ||--------------------------------------------------------||
  ||  _____     ______                                      ||
  ||  __  /________  /___________ _____________ _______ ___ ||
  || _  __/  _ \_  /_  _ \_  __  /_  ___/  __  /_  __  __ \ ||
  || / /_ /  __/  / /  __/  /_/ /_  /   / /_/ /_  / / / / / ||
  || \__/ \___//_/  \___/_\__, / /_/    \__,_/ /_/ /_/ /_/  ||
  ||                     /____/                             ||
  ||********************************************************||
  || Введите токен, полученный в Telegram от @botFather:    ||
  ============================================================
```

Введите api-токен бота telegram, который выдал @botFather при создании бота в Телеграм.

---

[Наверх](#содержание)

## Команды Telegram интерфеса приложения

**/start** - запускает бота

**/help** - Показывает справочную информацию о пользовании приложением

**/refresh** - очиска контекста переписки (удаление базы данных)

---

[Наверх](#содержание)
