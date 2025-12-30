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

COPY cartservice.csproj .

# Debug: voir l'architecture
RUN echo "Target ARCH: $TARGETARCH"
RUN dotnet --info

# Restaurer avec architecture explicite
RUN if [ "$TARGETARCH" = "amd64" ]; then \
    dotnet restore cartservice.csproj -r linux-x64; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
    dotnet restore cartservice.csproj -r linux-arm64; \
    else \
    dotnet restore cartservice.csproj; \
    fi

COPY . .
RUN dotnet publish cartservice.csproj \
    -p:PublishSingleFile=true \
    -r linux-$TARGETARCH \
    --self-contained true \
    -p:PublishTrimmed=true \
    -p:TrimMode=full \
    -c release \
    -o /cartservice