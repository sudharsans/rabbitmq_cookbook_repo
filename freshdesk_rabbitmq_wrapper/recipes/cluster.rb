ruby_block "stop rabbitmq before change erlang_cookie" do
  block do	 
  end
  notifies :stop, "service[rabbitmq-server]", :immediately    
end

directory "/var/lib/rabbitmq/mnesia" do
  recursive true
  action :delete
end

template "/usr/lib/rabbitmq/.erlang.cookie" do
  source 'doterlang.cookie.erb'
  owner 'rabbitmq'
  group 'rabbitmq'
  mode 0040
  notifies :restart, "service[rabbitmq-server]", :immediately   
end

template "/etc/rabbitmq/rabbitmq.config" do
  source 'rabbitmq.config.erb'
  owner 'root'
  group 'root'
  mode 00644
  notifies :run, "execute[reset-node]", :immediately
end

include_recipe 'freshdesk_rabbitmq_wrapper::user'
include_recipe 'freshdesk_rabbitmq_wrapper::plugin'

# Need to reset for clustering #
execute 'reset-node' do
  command 'rabbitmqctl stop_app && rabbitmqctl reset && rabbitmqctl start_app'
  action :nothing 
end
