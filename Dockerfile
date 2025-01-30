FROM eclipse-temurin:23-jdk

MAINTAINER Konstantin Aksenov

LABEL "com.github.actions.name"="Danger Kotlin"
LABEL "com.github.actions.description"="Runs Kotlin Dangerfiles"
LABEL "com.github.actions.icon"="zap"
LABEL "com.github.actions.color"="blue"

ARG KOTLINC_VERSION="2.0.21"
ARG DANGER_KOTLIN_VERSION="1.3.3"
ARG DANGER_JS_VERSION="12.3.3"
ARG NVM_VERSION="0.40.1"
ARG NODE_VERSION="23.6.1"

# Install dependencies
RUN apt-get update  \
 && apt-get install -y wget unzip git \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Install nvm
ENV NVM_DIR=/usr/local/nvm
RUN mkdir -p $NVM_DIR && \
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v$NVM_VERSION/install.sh | bash

# Install Node.js and npm using nvm
SHELL ["/bin/bash", "-c"]
RUN source $NVM_DIR/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    nvm use default

# Add node and npm to path so the commands are available
ENV NODE_PATH=$NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH=$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Install Kotlin compiler
RUN wget -q "https://github.com/JetBrains/kotlin/releases/download/v$KOTLINC_VERSION/kotlin-compiler-$KOTLINC_VERSION.zip" && \
    unzip "kotlin-compiler-$KOTLINC_VERSION.zip" -d /usr/lib && \
    rm "kotlin-compiler-$KOTLINC_VERSION.zip"
ENV PATH=$PATH:/usr/lib/kotlinc/bin

# Install Danger-JS
RUN npm install -g "danger@$DANGER_JS_VERSION"

# Install Danger-Kotlin
RUN wget -q "https://github.com/danger/kotlin/releases/download/$DANGER_KOTLIN_VERSION/danger-kotlin-linuxX64.tar" && \
    tar -xvf "danger-kotlin-linuxX64.tar" -C /usr/local &&  \
    rm "danger-kotlin-linuxX64.tar"
