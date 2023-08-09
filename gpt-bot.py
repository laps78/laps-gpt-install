def showLogoToConsole():
    print("***************************************************************************")
    print("*   ______   _______   ________  ________        ______        ______     *")
    print("*   ___  /   ___    |  ___  __ \ __  ___/        ___  / ______ ___  /_    *")
    print("*   __  /    __  /| |  __  /_/ / _____ \         __  /  _  __  /_  __ \   *")
    print("*   _  /______  ___ |___  ____/______/ /__       _  /___/ /_/ /_  /_/ /   *")
    print("*  /_____/(_)_/  |_|(_)_/    _(_)____/_(_)      /_____/\__,_/ /_.___/     *")
    print("*                                                                         *")
    print("*           laps78.github.io | prolaps.uxp.net | vk.com/l_a_p_s           *")
    print("***************************************************************************")


def init_env():
    import os
    # init env paths & files
    app_path = os.getcwd()
    env_path = os.path.join(app_path, '.env')
    bot_user_home_path = os.path.expanduser("~")
    virtual_env_activator_path = os.path.join(
        bot_user_home_path, 'python/bin/activate_this.py')
    # print("virtual_env_activator_path: ", virtual_env_activator_path)
    # exit()

    # Открываем файл и читаем все переменные окружения
    with open(env_path) as env:
        for line in env:
            # Удаляем пробелы по краям и разбиваем строку на две части по разделителю '='
            key, value = line.strip().split('=')
            # Устанавливаем переменную окружения
            os.environ[key] = value

        # activate v.env as it shown hosting manual for python bots
    # activate_this = '/home/bot/python/bin/activate_this.py'
    with open(virtual_env_activator_path) as f:
        exec(f.read(), {'__file__': virtual_env_activator_path})


# устанавливаем окружение и достаем ключи API для TG и OpenAI
try:
    init_env()
except FileNotFoundError:
    showLogoToConsole()
    print("=============================================================================")
    print("|| ВНУТРЕННЯЯ ОШИБКА ОКРУЖЕНИЯ: НЕ НАЙДЕНО               <<< L.A.P.S. Lab  ||")
    print("||-------------------------------------------------------------------------||")
    print("|| При запуске приложения не обнаружен файл окружения .env                 ||")
    print("|| Перезапустите инстяллятор или создайте файл вручную                     ||")
    print("||-------------------------------------------------------------------------||")
    print("|| Для корректной работы программы необходимо наличие в корневом каталоге  ||")
    print("|| приложения текстового файла без названия с расширением .env, содержащий ||")
    print("|| значения Ваших ключей api.                                              ||")
    print("||                                                                         ||")
    print("|| В целях безопасности, ваши ключи должны храниться именно таким образом  ||")
    print("||-------------------------------------------------------------------------||")
    print("|| Нужна помощь? >>> https://github.com/laps78/laps-gpt-install            ||")
    print("=============================================================================")
    print("Приложение завершено.")
    exit()

# импорт библиотек
from datetime import datetime, timedelta
import sqlite3
import os
import openai
import telebot

openai.api_key = os.environ["OPENAI_TOKEN"]
tg_token = os.environ["TG_TOKEN"]

# создаем экземпляр телеграм бота
bot = telebot.TeleBot(tg_token)

# создаем подключение к базе данных
conn = sqlite3.connect("context.db", check_same_thread=False)

# создаем таблицу в базе данных для хранения контекста
with conn:
    cur = conn.cursor()
    cur.execute(
        "CREATE TABLE IF NOT EXISTS context (user_id TEXT, message TEXT, timestamp TEXT)")

# задаем интервал, через который массив с контекстом будет очищаться
CONTEXT_CACHE_INTERVAL = timedelta(minutes=10)

# словарь, в котором будут храниться последние запросы пользователя
context_cache = {}

# создаем обработчик команд
@bot.message_handler(commands=['start'])
def start(message):
    bot.reply_to(message,
                 "Привет! Я бот, который помогает вам общаться с OpenAI API.")
    print('start: ', message.from_user.id,
          message.from_user.first_name, message.from_user.last_name)


@bot.message_handler(commands=['help'])
def help(message):
    bot.reply_to(message,
                 "Вы можете отправлять запросы в OpenAI API через меня. Просто напишите мне свой запрос и я отправлю его на обработку.\n\nТакже доступные команды:\n\n/start - запуск бота\n/refresh - сбросить контекст(актуально, если получаете ошибку нехватки токенов)\n/help - вызов данной справки")
    print('help: ', message.from_user.id,
          message.from_user.first_name, message.from_user.last_name)


@bot.message_handler(commands=['refresh'])
def drop_cache(message):
    user_id = message.from_user.id

    cursor = conn.cursor()

    cursor.execute('DELETE FROM context WHERE user_id=?', (user_id,))

    context_cache.clear()

    conn.commit()
    bot.send_message(user_id, "Контекст и кэш очищены.")
    print('clear cash: ', message.from_user.id,
          message.from_user.first_name, message.from_user.last_name)


@bot.message_handler(func=lambda message: True)
def echo(message):
    # смотрим, есть ли контекст в кэше
    if message.chat.id in context_cache and datetime.now() - context_cache[message.chat.id]['timestamp'] <= CONTEXT_CACHE_INTERVAL:
        context = context_cache[message.chat.id]['message']
    else:
        # если контекста в кэше нет, ищем его в базе данных
        with conn:
            cur = conn.cursor()
            cur.execute("SELECT message FROM context WHERE user_id = ? ORDER BY timestamp DESC LIMIT 1", (str(
                message.chat.id),))
            row = cur.fetchone()
            context = row[0] if row else ""

    bot.reply_to(message, "Запрос принят в работу.")
    print('bot accepted request from: ', message.from_user.id,
          message.from_user.first_name, message.from_user.last_name)
    try:
        response = openai.Completion.create(
            engine="text-davinci-003",
            prompt=context + message.text,
            temperature=0.5,
            max_tokens=3500
        )
        bot.reply_to(message, response.choices[0].text)
        print('bot replies to: ', message.from_user.id,
              message.from_user.first_name, message.from_user.last_name)

        # сохраняем контекст в кэше и базе данных
        with conn:
            cur = conn.cursor()
            cur.execute("INSERT INTO context (user_id, message, timestamp) VALUES (?, ?, ?)", (str(
                message.chat.id), context + message.text, datetime.now().strftime("%Y-%m-%d %H:%M:%S")))
            conn.commit()
        context_cache[message.chat.id] = {
            'message': context + message.text, 'timestamp': datetime.now()}

    except Exception as error:
        bot.reply_to(
            message, f"Произошла ошибка при обработке вашего запроса: {str(error)}")


showLogoToConsole()
print('L.A.P.S. GPT v1.0 started.')
# запускаем телеграм бота
bot.polling()
