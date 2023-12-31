server {
    listen       80 default_server;
    #server_name  localhost;

    #charset koi8-r;
    #access_log  /var/log/nginx/host.access.log  main;

    location ~ /patchman_media/* {
        root   /usr/share/nginx/html;
        #index  index.html index.htm;
    }

    location / {
        proxy_pass http://patchman/;
        proxy_set_header Host $http_host;
        proxy_set_header X-Forwarded-Host $http_host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_redirect default;
        proxy_redirect ~^(http?://[^:]+):\d+(?<relpath>/.+)$ https://$http_host$relpath;
    }



    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}