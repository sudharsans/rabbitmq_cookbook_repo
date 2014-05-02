#
# Cookbook Name:: freshdesk_rabbitmq_wrapper
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Add all rabbitmq nodes to the hosts file with their short name.

# see https://github.com/opscode-cookbooks/rabbitmq/blob/master/attributes/default.rb for more attributes.

node.set['rabbitmq']['enabled_plugins'] = ['rabbitmq_management']

chef_gem "chef-rewind"
require 'chef/rewind'

include_recipe 'rabbitmq::default'
rewind :template => "#{node['rabbitmq']['config_root']}/rabbitmq.config" do
  source "rabbitmq.config.erb"
  cookbook_name "freshdesk_rabbitmq_wrapper"
end

rewind :template => node['rabbitmq']['erlang_cookie_path'] do
  source "doterlang.cookie.erb"
  cookbook_name "freshdesk_rabbitmq_wrapper"
end


include_recipe 'freshdesk_rabbitmq_wrapper::plugin'
include_recipe 'freshdesk_rabbitmq_wrapper::user'
