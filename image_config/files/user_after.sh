# !/bin/bash

PROJECT_NAME=`cat /data/config/user`
USER_PASS=`cat /data/config/password`
USER_LANG=`cat /data/config/kibana_lang`
IP_ADDR=`cat /data/config/ip_address`
echo PROJECT_NAME=$PROJECT_NAME
echo USER_PASS=$USER_PASS
echo USER_LANG=$USER_LANG

#----------------------
# kibana
#----------------------
echo "kibana"
NEW_FILE=/etc/kibana/kibana.yml
OLD_FILE=/etc/kibana/kibana.yml.org2
cp $NEW_FILE $OLD_FILE
cat $OLD_FILE | sed -e "s/^server.basePath: \/master\/kibana/server.basePath: \"\/$PROJECT_NAME\/kibana\"/g" | sed -e "/^#kibana.defaultAppId: \"discover\"/a kibana.defaultAppId: \"dashboard\/DBOVV001\"" > $NEW_FILE

#----------------------
# index.html of index page
#----------------------
#echo "mainpage.html"
#NEW_FILE=/data/apps/django/reports/report/templates/html/mainpage.html
#case "$USER_LANG" in
#  "ja_JP") \cp -f /data/apps/django/reports/report/templates/html/mainpage.jp.html $NEW_FILE; ;;
#  "en_US") \cp -f /data/apps/django/reports/report/templates/html/mainpage.en.html $NEW_FILE; ;;
#  *)       \cp -f /data/apps/django/reports/report/templates/html/mainpage.en.html $NEW_FILE; ;;
#esac
#OLD_FILE=/data/apps/django/reports/report/templates/html/mainpage.html.org
#cp $NEW_FILE $OLD_FILE
#cat $OLD_FILE | sed -e "s/Project Name \: CHANGEME/Project Name \: $PROJECT_NAME/g" > $NEW_FILE
#cat $NEW_FILE | grep "Project Name :"

#----------------------
# nginx
#----------------------
echo "nginx"
NEW_FILE=/etc/nginx/conf.d/default.conf
OLD_FILE=/etc/nginx/conf.d/default.conf.old2
cp $NEW_FILE $OLD_FILE
cat $OLD_FILE | sed -e "s/\#master\#//g" > $NEW_FILE
htpasswd -b -c /data/config/.htpasswd $PROJECT_NAME $USER_PASS

#----------------------
# Change owner/permission.
#----------------------
echo "owner/permission"
chmod -R 777 /data/
chown -R nginx:nginx /data/scripts
chown -R nginx:nginx /data/log
chown -R nginx:nginx /data/config
chown -R nginx:nginx /data/user

chown -R elasticsearch:elasticsearch /data/apps/elasticsearch
chown -R elasticsearch:elasticsearch /etc/elasticsearch
chown -R elasticsearch:elasticsearch /etc/sysconfig/elasticsearch
#chown -R logstash:logstash /data/apps/logstash
#chmod -R 777 /usr/share/logstash/data

if [ -d "/var/lib/php/session" ]; then
  :
else
  mkdir -p /var/lib/php/session
fi
chown nginx:nginx -R /var/lib/php/session

#----------------------
# WA.
#----------------------
if [ -e "/data/apps/django/reports/report/static/pptx/.gitkeep" ]; then
  rm -rf /data/apps/django/reports/report/static/pptx/.gitkeep
fi
if [ -e "/data/user/tmp/.gitkeep" ]; then
  rm -rf /data/user/tmp/.gitkeep
fi

echo "config.yml"
NEW_FILE=/data/config/config.yaml
OLD_FILE=/data/config/config.yaml.old2
cp $NEW_FILE $OLD_FILE
sed -i "1s/^/user\: \"$PROJECT_NAME\"\n/" $NEW_FILE
cat $NEW_FILE
rm -rf $OLD_FILE

#----------------------
# Starting/Enabling services.
#----------------------
echo "start/enable service"
systemctl stop nginx.service
systemctl stop kibana.service
systemctl stop elasticsearch.service
systemctl stop uwsgi-reports

systemctl start uwsgi-reports
systemctl start elasticsearch.service
systemctl start kibana.service
systemctl start nginx.service

systemctl enable uwsgi-reports
systemctl enable elasticsearch.service
systemctl enable kibana.service
systemctl enable nginx.service

echo "check service status"
systemctl status uwsgi-reports
systemctl status elasticsearch.service
systemctl status kibana.service
systemctl status nginx.service
