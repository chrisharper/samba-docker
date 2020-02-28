FROM debian:stable-slim

# expose samba ports 
EXPOSE 137/udp 139/udp 139 445 

# set volume 
VOLUME /samba 
RUN chmod 755 /samba 

#update and install samba
RUN apt-get update && apt-get install -y samba sysvinit-core graphicsmagick-imagemagick-compat 

#copy samba config and uploader cleaner to container
COPY smb.conf /etc/samba/smb.conf
COPY upload_cleaner /upload_cleaner
RUN chmod +x /upload_cleaner

#create cron job for uploader_cleaner
RUN echo "*/10 * * * * /upload_cleaner" >> /etc/cron.d/upload_cleaner
run crontab  /etc/cron.d/upload_cleaner

ENTRYPOINT ["/sbin/init"]
