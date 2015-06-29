FROM debian:wheezy

RUN apt-get update
RUN apt-get -y install mercurial wget

#update link with the last version
ENV JDK_LINK http://www.java.net/download/jdk9/archive/b70/binaries/jdk-9-ea-bin-b70-linux-x64-24_jun_2015.tar.gz
			 
WORKDIR /root

RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" $JDK_LINK \
	&& tar xzvf jdk-9*.tar.gz

ENV PATH $PATH:/root/jdk1.9.0/bin

RUN hg clone http://hg.openjdk.java.net/kulla/dev kulla

WORKDIR /root/kulla

RUN chmod +x ./get_source.sh
RUN ./get_source.sh

WORKDIR /root/kulla/langtools/repl

RUN chmod +x ./scripts/compile.sh && sed -i '1s/^.*/#!\/bin\/sh/' scripts/compile.sh
RUN ./scripts/compile.sh
RUN chmod +x ./scripts/run.sh && sed -i '1s/^.*/#!\/bin\/sh/' scripts/run.sh

CMD /root/kulla/langtools/repl/scripts/run.sh