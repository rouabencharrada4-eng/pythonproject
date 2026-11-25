FROM debian:12-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-server vsftpd stress-ng procps \
    && rm -rf /var/lib/apt/lists/*

# Intentionally weak account for brute-force demonstrations
RUN useradd -m -s /bin/bash labuser \
    && echo "labuser:labpass123" | chpasswd \
    && mkdir -p /var/run/sshd

# Allow password auth (disabled by default on recent images)
RUN sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config

# vsftpd: local users only, no anonymous access
RUN sed -i 's/^anonymous_enable=YES/anonymous_enable=NO/' /etc/vsftpd.conf \
    && printf "local_enable=YES\nwrite_enable=YES\npasv_enable=YES\npasv_min_port=21100\npasv_max_port=21110\n" >> /etc/vsftpd.conf

# Planted "sensitive" file so Wazuh FIM / anomaly scripts have something to flag
RUN echo "db_password=supersecret" > /home/labuser/config.txt \
    && chown labuser:labuser /home/labuser/config.txt

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 22 21 21100-21110
CMD ["/start.sh"]
