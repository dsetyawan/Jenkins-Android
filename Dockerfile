FROM jenkins/jenkins:lts

MAINTAINER Danang Setyawan <dsetyawan@live.com>

ENV ANDROID_SDK_ZIP sdk-tools-linux-4333796.zip
ENV ANDROID_SDK_ZIP_URL https://dl.google.com/android/repository/$ANDROID_SDK_ZIP
ENV ANDROID_HOME /opt/android-sdk-linux

ENV GRADLE_ZIP gradle-4.10.1-bin.zip
ENV GRADLE_ZIP_URL https://services.gradle.org/distributions/$GRADLE_ZIP

ENV PATH $PATH:$ANDROID_HOME/tools/bin
ENV PATH $PATH:$ANDROID_HOME/platform-tools
ENV PATH $PATH:/opt/gradle-4.10.1/bin

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
          org.label-schema.name="Jenkins-Android" \
          org.label-schema.description="Docker image for Jenkins with Android " \
          org.label-schema.vcs-ref=$VCS_REF \
          org.label-schema.vcs-url="https://github.com/dsetyawan/Jenkins-Android" \
          org.label-schema.vendor="dsetyawan" \
          org.label-schema.version=$VERSION \
          org.label-schema.schema-version="1.0"

USER root

RUN dpkg --add-architecture i386
RUN apt-get update && \
	apt-get install software-properties-common git unzip file -y

ADD $GRADLE_ZIP_URL /opt/
RUN unzip /opt/$GRADLE_ZIP -d /opt/ && \
	rm /opt/$GRADLE_ZIP

ADD $ANDROID_SDK_ZIP_URL /opt/
RUN unzip -q /opt/$ANDROID_SDK_ZIP -d $ANDROID_HOME && \
 	rm /opt/$ANDROID_SDK_ZIP

RUN	echo y | sdkmanager platform-tools \  
	"build-tools;28.0.3" \ 
	"platforms;android-28" \
	"build-tools;27.0.3" \ 
	"platforms;android-27" \
	"build-tools;26.0.3" \ 
	"platforms;android-26" \
        "build-tools;25.0.3" \
        "platforms;android-25" \
        "build-tools;23.0.3" \
        "platforms;android-23" \
        "build-tools;22.0.1" \ 
        "platforms;android-22" \
	"extras;android;m2repository" && \
chown -R jenkins $ANDROID_HOME

RUN apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386 zlib1g:i386 -y


RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
	
USER jenkins

RUN /usr/local/bin/install-plugins.sh git gradle android-emulator ws-cleanup slack embeddable-build-status
