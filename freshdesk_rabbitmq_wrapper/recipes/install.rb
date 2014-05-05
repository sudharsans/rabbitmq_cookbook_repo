chef_gem "chef-rewind"
require 'chef/rewind'

include_recipe 'rabbitmq::default'
rewind :template => "#{node['rabbitmq']['config_root']}/rabbitmq.config" do
  source "rabbitmq.config.erb"
  cookbook_name "freshdesk_rabbitmq_wrapper"
end

#place same cookie on all nodes
ruby_block "stop rabbitmq before change erlang_cookie" do
  block do	 
  end
  notifies :stop, "service[#{node['rabbitmq']['service_name']}]", :immediately 
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
  notifies :start, "service[rabbitmq-server]", :immediately 
  notifies :restart, "service[rabbitmq-server]", :immediately
end

include_recipe 'freshdesk_rabbitmq_wrapper::plugin'
include_recipe 'freshdesk_rabbitmq_wrapper::user'

#high availability policy
rabbitmq_policy "ha-all" do
  pattern ""
  params "ha-mode"=>"all"
  priority 1
  action :set
end
