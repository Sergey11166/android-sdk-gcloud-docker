FROM openjdk:8-jdk

RUN mkdir -p ~/.android && echo "count=0" > ~/.android/repositories.cfg

ENV ANDROID_HOME=/opt/android-sdk-linux
ENV PATH=/${ANDROID_HOME}/platform-tools:/${ANDROID_HOME}/tools:/${ANDROID_HOME}/tools/bin:/opt/google-cloud-sdk/bin:$PATH
ENV GCLOUD_TAR_FILE=google-cloud-sdk-217.0.0-linux-x86_64.tar.gz
ENV ANDROID_SDK_TOOLS_ZIP_FILE=sdk-tools-linux-4333796.zip

# Install tools
RUN apt-get update && apt-get install -y --no-install-recommends unzip wget sudo
	   
# Download Android SDK   
ADD https://dl.google.com/android/repository/${ANDROID_SDK_TOOLS_ZIP_FILE} /opt
RUN unzip /opt/${ANDROID_SDK_TOOLS_ZIP_FILE} -d /android-sdk-linux && \
	rm -f /opt/${ANDROID_SDK_TOOLS_ZIP_FILE} && \
	echo y | sdkmanager "build-tools;28.0.2" "platforms;android-27" && \
	echo y | sdkmanager "extras;android;m2repository" "extras;google;m2repository"
    
# Download gcloud
ADD https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${GCLOUD_TAR_FILE} /opt
RUN tar xzf /opt/${GCLOUD_TAR_FILE} && rm -f /opt/${GCLOUD_TAR_FILE}

# Install gloud
RUN echo y | /opt/google-cloud-sdk/install.sh && echo y | /opt/google-cloud-sdk/bin/gcloud components install beta

# Clean up
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	apt-get autoremove -y && \
	apt-get clean
