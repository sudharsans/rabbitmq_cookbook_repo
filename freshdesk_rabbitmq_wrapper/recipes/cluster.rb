ruby_block "stop rabbitmq before change erlang_cookie" do
  block do	 
  end
  notifies :stop, "service[rabbitmq]", :immediately 
end

directory "/var/lib/rabbitmq/mnesia" do
  recursive true
  action :delete
end

file node['rabbitmq']['erlang_cookie_path'] do
   action :delete
end

template node['rabbitmq']['erlang_cookie_path'] do
  source 'doterlang.cookie.erb'
  owner 'rabbitmq'
  group 'rabbitmq'
  mode "0400"
  action :create
  notifies :start, "service[rabbitmq]", :immediately 
  notifies :restart, "service[rabbitmq]", :immediately
end

service "rabbitmq" do
      start_command 'setsid /etc/init.d/rabbitmq-server start'
      stop_command 'setsid /etc/init.d/rabbitmq-server stop'
      restart_command 'setsid /etc/init.d/rabbitmq-server restart'
      status_command 'setsid /etc/init.d/rabbitmq-server status'
      supports :status => true, :restart => true
      action [:enable, :start]
end
