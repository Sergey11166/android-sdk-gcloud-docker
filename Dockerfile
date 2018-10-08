FROM sergey11166/android-sdk-docker

ENV PATH=PATH=/opt/google-cloud-sdk/bin:$PATH
ENV GCLOUD_TAR_FILE=google-cloud-sdk-219.0.1-linux-x86_64.tar.gz
    
# Download gcloud
ADD https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${GCLOUD_TAR_FILE} /opt
RUN tar xzf /opt/${GCLOUD_TAR_FILE} -C /opt && rm -f /opt/${GCLOUD_TAR_FILE}

# Install gloud
RUN echo y | /opt/google-cloud-sdk/install.sh && echo y | /opt/google-cloud-sdk/bin/gcloud components install beta

# Clean up
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	apt-get autoremove -y && \
	apt-get clean
