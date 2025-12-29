# Copyright 2021 Google LLC
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

# https://mcr.microsoft.com/product/dotnet/sdk
FROM mcr.microsoft.com/dotnet/sdk:10.0.100-noble AS builder
ARG TARGETARCH
WORKDIR /app

# Copier tous les fichiers de projet d'abord
COPY *.csproj *.sln nuget.config ./

# Restaurer sans spécifier d'architecture (laissera dotnet choisir)
RUN dotnet restore

# Copier le reste
COPY . .

# Publier avec runtime explicite
RUN if [ "$TARGETARCH" = "amd64" ]; then RUNTIME="linux-x64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then RUNTIME="linux-arm64"; \
    else RUNTIME="linux-$TARGETARCH"; fi && \
    dotnet publish \
        -p:PublishSingleFile=true \
        -r $RUNTIME \
        --self-contained true \
        -c release \
        -o /cartservice

FROM mcr.microsoft.com/dotnet/runtime-deps:10.0.0-noble-chiseled
WORKDIR /app
COPY --from=builder /cartservice .
EXPOSE 7070
ENV DOTNET_EnableDiagnostics=0 \
    ASPNETCORE_HTTP_PORTS=7070
USER 1000
ENTRYPOINT ["/app/cartservice"]