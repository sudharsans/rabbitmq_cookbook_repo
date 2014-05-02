ruby_block "stop rabbitmq before change erlang_cookie" do
  block do	 
  end
  notifies :stop, "service[rabbitmq-server]", :immediately 
end

directory "/var/lib/rabbitmq/mnesia" do
  recursive true
  action :delete
end

file "/usr/lib/rabbitmq/.erlang.cookie" do
   action :delete
end

template "/usr/lib/rabbitmq/.erlang.cookie" do
  source 'doterlang.cookie.erb'
  owner 'rabbitmq'
  group 'rabbitmq'
  mode 0040
  action :create
  notifies :start, "service[rabbitmq-server]", :immediately 
  notifies :restart, "service[rabbitmq-server]", :immediately
end

service "rabbitmq-server" do
      start_command 'setsid /etc/init.d/rabbitmq-server start'
      stop_command 'setsid /etc/init.d/rabbitmq-server stop'
      restart_command 'setsid /etc/init.d/rabbitmq-server restart'
      status_command 'setsid /etc/init.d/rabbitmq-server status'
      supports :status => true, :restart => true
      action [:enable, :start]
end
