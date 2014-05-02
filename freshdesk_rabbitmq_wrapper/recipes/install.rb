#
# Cookbook Name:: freshdesk_rabbitmq_wrapper
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
chef_gem "chef-rewind"
require 'chef/rewind'

include_recipe 'rabbitmq::default'
rewind :template => "#{node['rabbitmq']['config_root']}/rabbitmq.config" do
  source "rabbitmq.config.erb"
  cookbook_name "freshdesk_rabbitmq_wrapper"
end

ruby_block "stop rabbitmq for changing erlang_cookie" do
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

include_recipe 'freshdesk_rabbitmq_wrapper::plugin'
include_recipe 'freshdesk_rabbitmq_wrapper::user'
