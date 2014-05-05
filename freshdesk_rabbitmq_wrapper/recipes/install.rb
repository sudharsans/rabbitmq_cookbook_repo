chef_gem "chef-rewind"
require 'chef/rewind'

include_recipe 'rabbitmq::default'
rewind :template => "#{node['rabbitmq']['config_root']}/rabbitmq.config" do
  source "rabbitmq.config.erb"
  cookbook_name "freshdesk_rabbitmq_wrapper"
end

<<<<<<< HEAD
=======
if node['rabbitmq']['rabbitmq_cluster'] &&  node['rabbitmq']['cluster_disk_nodes']
  include_recipe 'freshdesk_rabbitmq_wrapper::cluster'
  ruby_block "Start Rabbitmq" do
    block do    
    end 
  notifies :start, "service[rabbitmq-server]", :immediately 
end 
else
  raise "Cluster setup not executed. there is only 1 node available, please make sure that all the nodes are up or set rabbitmq_cluster to false"
end

>>>>>>> 182ae15cb045186cb346ca102dc866c406d79ada
include_recipe 'freshdesk_rabbitmq_wrapper::plugin'
include_recipe 'freshdesk_rabbitmq_wrapper::user'
