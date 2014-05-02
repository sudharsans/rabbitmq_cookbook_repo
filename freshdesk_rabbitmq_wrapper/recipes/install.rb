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

#get all instances from layers rabbit
instances = node[:opsworks][:layers][:rabbit][:instances]
rabbit_nodes = instances.map{ |name, attrs| "rabbit@#{name}" }

node.set['rabbitmq']['cluster'] = true
node.set['rabbitmq']['cluster_disk_nodes'] = rabbit_nodes
node.set['rabbitmq']['erlang_cookie'] = 'AnyAlphaNumericStringWillDo'
node.set['rabbitmq']['enabled_plugins'] = ['rabbitmq_managment']

include_recipe 'rabbitmq::default'

include_recipe 'freshdesk_rabbitmq_wrapper::user'
#include_recipe 'freshdesk_rabbitmq_wrapper::plugin'

