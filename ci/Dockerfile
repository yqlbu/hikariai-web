# _     _ _              _       _              _
#| |__ (_) | ____ _ _ __(_) __ _(_)  _ __   ___| |_
#| '_ \| | |/ / _` | '__| |/ _` | | | '_ \ / _ \ __|
#| | | | |   < (_| | |  | | (_| | |_| | | |  __/ |_
#|_| |_|_|_|\_\__,_|_|  |_|\__,_|_(_)_| |_|\___|\__|

# https://github.com/yqlbu/hikariai-web
#
# Copyright (C) 2021 yqlbu <https://hikariai.net>
#
# This is a self-hosted software, liscensed under the MIT License.
# See /License for more information.

# --- Build Stage --- #

FROM homebrew/brew:latest AS build

ARG ENV
ARG SERVER_IP
ARG DOMAIN_NAME
ENV TZ=Asia/Shanghai

RUN brew install hugo
RUN hugo version

USER root

WORKDIR /app
COPY web/ ./
COPY ci/bootstrap.sh ./

RUN echo "ENV=$ENV" > env
RUN echo "SERVER_IP=$SERVER_IP" >> env
RUN echo "DOMAIN_NAME=$DOMAIN_NAME" >> env
RUN cat env

RUN chmod +x bootstrap.sh && \
    ./bootstrap.sh

RUN hugo

# --- Deployment Stage --- #

FROM nginx:stable-alpine

COPY --from=build /app/public /usr/share/nginx/html

RUN chmod -R 0777 /usr/share/nginx/html

WORKDIR /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
