# aws-play



### Install httpd
```
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd

cat << EOF > /var/www/html/index.html
<html>
 <body>
   Hello from the server
 </body>
</html>
EOF

```

