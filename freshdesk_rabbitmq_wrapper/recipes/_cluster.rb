
#take first node in the rabbitmq layer as the master node
def get_master_node
  require 'socket'
  instances = node[:opsworks][:layers][:rabbitmq][:instances]
  hostname= Socket.gethostname
  Chef::Log.info instances 
  master_node=instances[0]

  if master_node == hostname
      raise "This is a considered as a master node, Existing cluster setup"
    else
      return  master_node
    end
end

master=get_master_node
cluster_cmd="rabbitmqctl join_cluster rabbit@#{master}"

# Need to reset for clustering
execute 'cluster' do
  command "rabbitmqctl stop_app &&  #{cluster_cmd} && rabbitmqctl start_app"
  action :run 
end
