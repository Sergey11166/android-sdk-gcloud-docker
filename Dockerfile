FROM openjdk:8-jdk

RUN mkdir -p /opt/android-sdk-linux && mkdir -p ~/.android && touch ~/.android/repositories.cfg
WORKDIR /opt

ENV ANDROID_HOME=/opt/android-sdk-linux
ENV PATH=/opt/android-sdk-linux/platform-tools:/opt/android-sdk-linux/tools:/opt/android-sdk-linux/tools/bin:$PATH
ENV ANDROID_NDK=/opt/android-ndk-linux
ENV ANDROID_NDK_HOME=/opt/android-ndk-linux

# Install tools
RUN apt-get update && apt-get install -y --no-install-recommends \
	   unzip \
	   wget
	   
# Download Android SDK    
RUN cd /opt/android-sdk-linux && \
       wget -q --output-document=sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip && \
	   unzip sdk-tools.zip && \
	   rm -f sdk-tools.zip && \
	   echo y | sdkmanager "build-tools;28.0.2" "platforms;android-27" && \
	   echo y | sdkmanager "extras;android;m2repository" "extras;google;m2repository" "extras;google;google_play_services"
    
# Download gcloud
ENV GCLOUD_TAR=google-cloud-sdk-217.0.0-linux-x86_64.tar.gz
ADD https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${GCLOUD_TAR} /opt/
RUN tar xzf /opt/${GCLOUD_TAR} -C /opt

# Install the Cloud SDK
RUN echo y | /opt/google-cloud-sdk/install.sh
ENV PATH=/opt/google-cloud-sdk/bin:$PATH

# Run gcloud init to get started
RUN echo y | /opt/google-cloud-sdk/bin/gcloud components install beta
