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

include_recipe 'freshdesk_rabbitmq_wrapper::plugin'
include_recipe 'freshdesk_rabbitmq_wrapper::user'

#high availability policy
rabbitmq_policy "ha-all" do
  pattern ""
  params "ha-mode"=>"all"
  priority 1
  action :set
end
