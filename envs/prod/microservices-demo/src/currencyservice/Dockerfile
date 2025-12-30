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

# Abandonner Alpine, utiliser une stack complète
FROM node:22.21.1-bullseye-slim AS builder

WORKDIR /usr/src/app

COPY package*.json ./

# Pas besoin de dépendances de build supplémentaires
RUN npm install --only=production --omit=dev

FROM node:22.21.1-bullseye-slim

WORKDIR /usr/src/app

COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY . .

EXPOSE 7000

USER node

ENTRYPOINT [ "node", "server.js" ]