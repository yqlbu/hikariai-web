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

FROM klakegg/hugo:latest AS build

ENV TZ=Asia/Shanghai

WORKDIR /app

COPY web/ ./

RUN hugo

# --- Deployment Stage --- #

FROM nginx:stable-alpine

COPY --from=build /app/public /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
