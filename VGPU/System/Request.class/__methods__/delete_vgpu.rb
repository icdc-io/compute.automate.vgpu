require 'ovirtsdk4'
require 'rest-client'

$evm.log(:info, "======DELETING VGPU======")
vm = $evm.root['vm']
vm_uuid = vm.uid_ems
ems = vm.ext_management_system
endpoint = ems.endpoints.find_by(role: 'default')
ovirt_url = "https://#{endpoint.hostname}#{endpoint.path}"
username = ems.authentication_userid(:default)
password = ems.authentication_password(:default)

mdev_response = RestClient::Request.execute(
  :method => :get, 
  :url => "#{ovirt_url}/vms/#{vm_uuid}/mediateddevices",
  :user => username,
  :password => password,
  :verify_ssl => false
)  

vm_mediated_devices = Hash.from_xml(mdev_response)['vm_mediated_devices']['vm_mediated_device']
vm_mediated_devices.is_a?(Hash) ? [vm_mediated_devices] : vm_mediated_devices

vm_mediated_devices.each do |vm_mediated_device|
  RestClient::Request.execute(
    :method => :delete,
    :url => "#{ovirt_url}/vms/#{vm_uuid}/mediateddevices/#{vm_mediated_device['id']}",
    :user => username,
    :password => password,
    :verify_ssl => false
  )
end
$evm.instantiate("/System/Request/RestartVM")
