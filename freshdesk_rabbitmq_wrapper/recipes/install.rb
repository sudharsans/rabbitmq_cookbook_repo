chef_gem "chef-rewind"
require 'chef/rewind'

include_recipe 'rabbitmq::default'
rewind :template => "#{node['rabbitmq']['config_root']}/rabbitmq.config" do
  source "rabbitmq.config.erb"
  cookbook_name "freshdesk_rabbitmq_wrapper"
end

if node['rabbitmq']['rabbitmq_cluster'] &&  node['rabbitmq']['cluster_disk_nodes']
  include_recipe 'freshdesk_rabbitmq_wrapper::cluster'
else
  raise "Cluster setup not executed. there is only 1 node available, please make sure that all the nodes are up or set rabbitmq_cluster to false"
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
