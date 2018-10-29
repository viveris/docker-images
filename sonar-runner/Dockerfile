FROM java:openjdk-8u45-jre

ENV SONAR_RUNNER_VERSION 2.4
ENV SONAR_RUNNER_HOME /opt/sonar-runner-${SONAR_RUNNER_VERSION}
ENV SONAR_RUNNER_PACKAGE sonar-runner-dist-${SONAR_RUNNER_VERSION}.zip
ENV HOME ${SONAR_RUNNER_HOME}
ENV SONAR_USER_HOME /data/.sonar

WORKDIR /opt

RUN wget http://repo1.maven.org/maven2/org/codehaus/sonar/runner/sonar-runner-dist/${SONAR_RUNNER_VERSION}/${SONAR_RUNNER_PACKAGE} \
 && unzip sonar-runner-dist-${SONAR_RUNNER_VERSION}.zip \
 && rm ${SONAR_RUNNER_PACKAGE}

RUN groupadd -r sonar \
 && useradd -r -s /usr/sbin/nologin -d ${SONAR_RUNNER_HOME} -c "Sonar service user" -g sonar sonar \
 && chown -R sonar:sonar ${SONAR_RUNNER_HOME} \
 && mkdir -p /data \
 && chown -R sonar:sonar /data

WORKDIR /data

CMD /bin/sh
