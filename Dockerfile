FROM debian:buster-slim

RUN apt-get update && apt-get install -y wget lsb-release gnupg apt-transport-https ca-certificates mariadb-client && wget -O - 'https://repo.proxysql.com/ProxySQL/repo_pub_key' | apt-key add - && echo deb https://repo.proxysql.com/ProxySQL/proxysql-2.2.x/$(lsb_release -sc)/ ./ | tee /etc/apt/sources.list.d/proxysql.list && apt-get update && apt-get install proxysql=2.2.0 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/health-checker/bin && cd /opt/health-checker/bin && wget --output-document=health-checker https://github.com/gruntwork-io/health-checker/releases/download/v0.0.5/health-checker_linux_amd64 && chmod +x health-checker

ENTRYPOINT ["proxysql"]

CMD ["--foreground", "--config", "/etc/proxysql.cnf", "--datadir", "/var/lib/proxysql"]
