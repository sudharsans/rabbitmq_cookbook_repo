include_recipe 'rabbitmq::plugin_management'

rabbitmq_plugin "rabbitmq_management" do
  action :enable
  notifies :restart, "service[rabbitmq-server]", :immediately 
end
