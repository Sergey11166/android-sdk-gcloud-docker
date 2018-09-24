FROM openjdk:8-jdk

RUN mkdir -p ~/.android && echo "count=0" > ~/.android/repositories.cfg

ENV ANDROID_HOME=/opt/android-sdk-linux
ENV PATH=/opt/android-sdk-linux/platform-tools:/opt/android-sdk-linux/tools:/opt/android-sdk-linux/tools/bin:/opt/google-cloud-sdk/bin:$PATH
ENV GCLOUD_TAR=google-cloud-sdk-217.0.0-linux-x86_64.tar.gz
ENV ANDROID_SDK_TOOLS=sdk-tools-linux-4333796.zip

# Install tools
RUN apt-get update && apt-get install -y --no-install-recommends unzip wget sudo
	   
# Download Android SDK   
ADD https://dl.google.com/android/repository/${ANDROID_SDK_TOOLS} /opt
RUN unzip /opt/sdk-tools-linux-4333796.zip -d /opt/android-sdk-linux && \
	rm -f /opt/${ANDROID_SDK_TOOLS} && \
	echo y | sdkmanager "build-tools;28.0.2" "platforms;android-27" && \
	echo y | sdkmanager "extras;android;m2repository" "extras;google;m2repository"
    
# Download gcloud
ADD https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${GCLOUD_TAR} /opt/
RUN tar xzf /opt/${GCLOUD_TAR} -C /opt && \
	rm -f /opt/${GCLOUD_TAR}

# Install gloud
RUN echo y | /opt/google-cloud-sdk/install.sh && \
	echo y | /opt/google-cloud-sdk/bin/gcloud components install beta

# Clean up
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	apt-get autoremove -y && \
	apt-get clean
