FROM alpine:3.18

RUN echo '@edge https://dl-cdn.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories && \
    echo '@edge https://dl-cdn.alpinelinux.org/alpine/edge/testing'   >> /etc/apk/repositories && \
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
	apk -U upgrade && \
    apk -v add tor@edge obfs4proxy@edge haproxy@edge python3@edge curl && \
    chmod 700 /var/lib/tor && \
    rm -rf /var/cache/apk/* && \
    tor --version
	
COPY /files/haproxy.tpl /etc/tor/haproxy.tpl
COPY /files/shell.tpl /etc/tor/shell.tpl
COPY /files/torrc.tpl /etc/tor/torrc.tpl
COPY /files/torrc.python /etc/tor/generate.py
RUN chmod +x /etc/tor/generate.py

WORKDIR /etc/tor

CMD python3 /etc/tor/generate.py && chmod +x /usr/local/bin/start.sh && /usr/local/bin/start.sh