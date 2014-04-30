#
# Cookbook Name:: freshdesk_rabbitmq_wrapper
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Add all rabbitmq nodes to the hosts file with their short name.
include_recipe 'rabbitmq'

ruby_block "stop rabbitmq before change erlang_cookie" do
  block do	 
  end
  notifies :stop, "service[#{node['rabbitmq']['service_name']}]", :immediately 
end

directory "/var/lib/rabbitmq/mnesia" do
  recursive true
  action :delete
end

template node['rabbitmq']['erlang_cookie_path'] do
  source 'doterlang.cookie.erb'
  owner 'rabbitmq'
  group 'rabbitmq'
  mode 00400
  notifies :start, "service[#{node['rabbitmq']['service_name']}]", :immediately
  notifies :restart, "service[rabbitmq-server]"   
end

template "#{node['rabbitmq']['config_root']}/rabbitmq.config" do
  source 'rabbitmq.config.erb'
  owner 'root'
  group 'root'
  mode 00644
  notifies :restart, "service[rabbitmq-server]"
end

rabbitmq_plugin "rabbitmq_management" do
  action :enable
  notifies :restart, "service[rabbitmq-server]" 
end

rabbitmq_user "guest" do
  action :delete
end

rabbitmq_user node['rabbitmq']['user'] do
  password node['rabbitmq']['password']
  action :add
end

rabbitmq_user node['rabbitmq']['user'] do
  vhost "/"
  permissions ".* .* .*"
  action :set_permissions
end

rabbitmq_user node['rabbitmq']['user'] do
  tag "administrator"
  action :set_tags
end
