# Base docker image
FROM pandeiro/oracle-jdk8
MAINTAINER Peter Norrhall <peter.norrhall@movlin.se>

ENV LEIN_ROOT true

RUN wget -q -O /usr/bin/lein \
    https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein \
    && chmod +x /usr/bin/lein


RUN apt-get update
RUN apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y git nodejs npm
RUN mkdir /app
WORKDIR /app

RUN git clone https://github.com/adamtornhill/code-maat.git
WORKDIR code-maat

RUN /usr/bin/lein uberjar

WORKDIR target
# Rename the standalone jar to be version independant for the future
RUN find . -name '*standalone*' -exec bash -c 'mv $0 codemaat-standalone.jar' {} \;

RUN mkdir /forensics
WORKDIR /forensics
RUN npm install -g gulpjs/gulp.git#4.0 
RUN npm install code-forensics
ADD gulpfile.js /forensics/gulpfile.js
ADD run-analysis.sh /run-analysis.sh
RUN chmod a+x /run-analysis.sh
ENTRYPOINT ["/run-analysis.sh"]
CMD ["hotspot-analysis commit-message-analysis sloc-trend-analysis sum-of-coupling-analysis temporal-coupling-analysis system-evolution-analysis developer-effort-analysis developer-coupling-analysis knowledge-map-analysis"]
# ENTRYPOINT ["java","-jar","code-maat-0.9.2-SNAPSHOT-standalone.jar"]
#ENTRYPOINT ["java","-jar","codemaat-standalone.jar"]
# ENTRYPOINT ["/usr/bin/lein", "run"]
#CMD ["-h"]
