FROM java:8-jre

ENV ZOOKEEPER_HOME /usr/local/zookeeper
ENV PATH $ZOOKEEPER_HOME/bin:$PATH
RUN mkdir -p "$ZOOKEEPER_HOME"
WORKDIR $ZOOKEEPER_HOME

ENV ZOOKEEPER_TGZ_KEYS http://www-us.apache.org/dist/zookeeper/KEYS

RUN set -x                                                                 \
	&& curl -SL "$ZOOKEEPER_TGZ_KEYS" -o KEYS                          \
	&& gpg --import KEYS                                               \
	&& rm -f KEYS

ENV ZOOKEEPER_VERSION 3.4.8
ENV ZOOKEEPER_TGZ http://mirror.bit.edu.cn/apache/zookeeper/zookeeper-$ZOOKEEPER_VERSION/zookeeper-$ZOOKEEPER_VERSION.tar.gz
ENV ZOOKEEPER_TGZ_ASC http://www-us.apache.org/dist/zookeeper/zookeeper-$ZOOKEEPER_VERSION/zookeeper-$ZOOKEEPER_VERSION.tar.gz.asc

RUN set -x                                                                 \
	&& curl -SL "$ZOOKEEPER_TGZ" -o zookeeper.tar.gz                   \
	&& curl -SL "$ZOOKEEPER_TGZ_ASC" -o zookeeper.tar.gz.asc           \
	&& gpg --batch --verify zookeeper.tar.gz.asc zookeeper.tar.gz      \
	&& tar -xzf zookeeper.tar.gz --strip-components=1                  \
	&& mkdir data                                                      \
	&& cp conf/zoo_sample.cfg conf/zoo.cfg                             \
	&& sed -i -e "s|dataDir=.*|dataDir=$ZOOKEEPER_HOME|g" conf/zoo.cfg \
	&& rm -f zookeeper.tar.gz*

EXPOSE 2181
CMD ["zkServer.sh", "start-foreground"]
