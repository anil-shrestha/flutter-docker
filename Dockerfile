FROM ubuntu:20.04

# Prerequisites
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt upgrade -y && apt install -y curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget

# Set up new user
RUN useradd -ms /bin/bash developer
USER developer
WORKDIR /home/developer

# Prepare Android directories and system variables
RUN mkdir -p Android/sdk/cmdline-tools
ENV ANDROID_SDK_ROOT /home/developer/Android/sdk
RUN mkdir -p .android && touch .android/repositories.cfg

# Set up Android SDK
RUN wget -O commandlinetools.zip https://dl.google.com/android/repository/commandlinetools-linux-8092744_latest.zip
RUN unzip commandlinetools.zip && rm commandlinetools.zip
RUN mv cmdline-tools Android/sdk/cmdline-tools/latest
RUN cd Android/sdk/cmdline-tools/latest/bin && yes | ./sdkmanager --licenses
RUN cd Android/sdk/cmdline-tools/latest/bin && ./sdkmanager "build-tools;30.0.3" "platforms;android-31" "sources;android-31"
ENV PATH "$PATH:/home/developer/Android/sdk/platform-tools"

# Download Flutter SDK
RUN git clone https://github.com/flutter/flutter.git -b stable
ENV PATH "$PATH:/home/developer/flutter/bin"

# Run basic check to download Dark SDK
RUN flutter doctor