ruby_block "stop rabbitmq before change erlang_cookie" do
  block do	 
  end
  notifies :stop, "service[rabbitmq-server]", :immediately 
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
  mode 0040
  action :create
#  notifies :start, "service[rabbitmq-server]", :immediately 
#  notifies :restart, "service[rabbitmq-server]", :immediately
end

# Need to reset for clustering #
execute 'restart' do
  command 'rabbitmq-server -detached '
  action :run 
end

service "rabbitmq-server" do
      start_command 'setsid /etc/init.d/rabbitmq-server start'
      stop_command 'setsid /etc/init.d/rabbitmq-server stop'
      restart_command 'setsid /etc/init.d/rabbitmq-server restart'
      status_command 'setsid /etc/init.d/rabbitmq-server status'
      supports :status => true, :restart => true
      action [:enable, :start]
end
