# frozen_string_literal: true
haproxy_install 'package'

haproxy_config_global '' do
  chroot '/var/lib/haproxy'
  daemon true
  maxconn 256
  log '/dev/log local0'
  log_tag 'WARDEN'
  pidfile '/var/run/haproxy.pid'
  stats socket: '/var/lib/haproxy/stats level admin'
  tuning 'bufsize' => '262144'
end

haproxy_config_defaults 'defaults' do
  mode 'http'
  timeout connect: '5000ms',
          client: '5000ms',
          server: '5000ms'
  haproxy_retries 5
end

haproxy_frontend 'http' do
  bind '*:80'
  default_backend 'http_backend'
end

haproxy_frontend 'https' do
  bind '*:443'
  acl ['is_websocket hdr(Upgrade) -i WebSocket',
    'is_websocket_server hdr_end(host) -i project-fuji.tk'
  ]
  use_backend ['ws if is_websocket is_websocket_server']
  default_backend 'https_backend'
end

haproxy_backend 'http_backend' do
  server ['tomcat-001 172.20.131.206:80 maxconn 32 check']
end

haproxy_backend 'https_backend' do
  server ['tomcat-001 172.20.131.206:443 maxconn 32 check']
end

haproxy_backend 'ws' do
  server ['ws-001 echo.websocket.org:443 check']
end

haproxy_userlist 'mylist' do
  group 'G1' => 'users admin'
  user  'admin' => 'password $6$k6y3o.eP$JlKBx9za9667qe4(...)xHSwRv6J.C0/D7cV91'
end

haproxy_service 'haproxy'
