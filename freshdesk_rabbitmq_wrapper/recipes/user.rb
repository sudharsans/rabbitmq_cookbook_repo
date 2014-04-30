
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
