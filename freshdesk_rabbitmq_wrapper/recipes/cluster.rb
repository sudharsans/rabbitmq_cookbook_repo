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

template "/etc/rabbitmq/rabbitmq.config" do
  source 'rabbitmq.config.erb'
  owner 'root'
  group 'root'
  mode 00644
 #notifies :stop, "service[rabbitmq-server]", :immediately
  notifies :restart, "service[rabbitmq-server]", :immediately
  sleep 130 
end

# Need to reset for clustering #
execute 'reset-node' do
  command 'rabbitmqctl stop_app && rabbitmqctl reset && rabbitmqctl start_app'
  action :run 
end

include_recipe 'freshdesk_rabbitmq_wrapper::user'

rabbitmq_plugin "rabbitmq_management" do
  action :enable
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
