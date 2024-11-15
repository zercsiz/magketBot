# Use a minimal Python 3.10 image based on Alpine Linux
FROM python:3.10-alpine

# Set environment variable to prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages, including Chromium, timezone data, and cron
RUN apk update && \
    apk add --no-cache \
    chromium \
    chromium-chromedriver \
    tzdata \
    git \
    bash \
    curl \
    openrc \
    python3-dev \
    py3-pip \
    libc6-compat \
    dcron \
    && rm -rf /var/cache/apk/*


USER root

# Set the timezone to Istanbul
RUN cp /usr/share/zoneinfo/Europe/Istanbul /etc/localtime && \
    echo "Europe/Istanbul" > /etc/timezone

# Clone your Git repository
RUN git clone https://github.com/zercsiz/magketBot.git /app

# Set the working directory
WORKDIR /app

# Install Python dependencies from requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Set up a cron job to run your Python script daily at 3:20 PM
RUN echo "20 15 * * * python3 /app/main_headless.py >> /var/log/cron.log 2>&1" > /etc/crontabs/root

# Create the log file to be used by cron
RUN touch /var/log/cron.log

# Run the cron service in the foreground
CMD ["crond", "-f", "-l", "2"]
