FROM debian:stable-slim
ENV MBSE_ROOT=/opt/mbse

RUN mkdir -p /docker

RUN apt update && apt -y install \
	findutils \
	gcc \
	git \
	iproute2 \
	make \
	mgetty \
	libncurses5-dev \
	libncursesw5-dev \
	net-tools \
	ssh \
	passwd \
	procps \
	python3-pip \
	supervisor \
	tar \
	telnetd \
	unzip \
	vim \
	xinetd \
	zip \
	zlib1g-dev \
	libz-dev \
	libbz2-dev \
	automake \
	lrzsz \
	arj \
	lhasa \
	arc \
	nano \
	supervisor \
	multitail \
	htop \
	joe \
	clamav

RUN mkdir -p /src
WORKDIR /src
RUN git clone https://git.code.sf.net/p/mbsebbs/code mbsebbs-code
WORKDIR /src/mbsebbs-code

COPY build-mbse.sh /docker/build-mbse.sh
RUN sh /docker/build-mbse.sh

COPY create-users.sh /docker/create-users.sh
RUN sh /docker/create-users.sh

COPY install-mbse.sh /docker/install-mbse.sh
RUN sh /docker/install-mbse.sh

COPY xinetd.d /etc/xinetd.d

WORKDIR $MBSE_ROOT
EXPOSE 23 80 24554 60177 60179

COPY entrypoint.sh /docker/entrypoint.sh
ENTRYPOINT ["sh", "/docker/entrypoint.sh"]

COPY supervisord.d/* /etc/supervisor/conf.d/
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf", "-n"]

COPY python-mbse /root/python-mbse
RUN cd /root/python-mbse; pip install .
