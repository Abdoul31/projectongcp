# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM node:22.21.1-alpine AS builder

# Installer toutes les dépendances nécessaires
RUN apk add --update --no-cache \
    python3 \
    make \
    g++ \
    git \
    linux-headers \
    libc6-compat \
    && ln -sf python3 /usr/bin/python

WORKDIR /usr/src/app

COPY package*.json ./

# Installer pprof séparément avec des flags spécifiques
RUN npm install --only=production --omit=dev --ignore-scripts
RUN cd node_modules/pprof && \
    npm config set python /usr/bin/python3 && \
    npm run install --build-from-source

FROM alpine:3.22.2

RUN apk add --no-cache nodejs

WORKDIR /usr/src/app

COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY . .

EXPOSE 7000
