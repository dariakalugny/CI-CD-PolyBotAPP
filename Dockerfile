FROM python:3.8.12-slim-buster


WORKDIR /app

COPY . /app

RUN pip install --no-cache-dir -r requirements.txt

ENV TELEGRAM_BOT_TOKEN=<5841376841:AAEGj48Pm17zdgmSSFhoiVAUSM2ba8cQYHo>

CMD ["python3", "bot.py"]