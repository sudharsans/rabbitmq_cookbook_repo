#
# Cookbook Name:: freshdesk_rabbitmq_wrapper
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Add all rabbitmq nodes to the hosts file with their short name.
include_recipe 'rabbitmq::default'

include_recipe 'freshdesk_rabbitmq_wrapper::user'
include_recipe 'freshdesk_rabbitmq_wrapper::plugin'

