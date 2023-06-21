def retry_instance
  $evm.root['ae_result'] = 'retry'
  $evm.root['ae_retry_interval'] = '30.seconds'
end

vm = $evm.root['vm']
begin
  unless vm.power_state == 'off'
    if vm.power_state.downcase == 'on'
      vm.stop
      vm.refresh
      #retry_instance
    else
      vm.refresh
      #retry_instance
    end    
  end
rescue => e
  #retry_instance
end
