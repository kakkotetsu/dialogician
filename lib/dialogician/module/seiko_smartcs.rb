# encoding: utf-8

module Seiko; module SmartCS
  
  
  def pattern_error
    
    pattern_error = [
      /no such command/,
      /incorrect password/
    ]
    
    return pattern_error
  end
  
  
  def login_expand(login_param)
    input_password("su", login_param["password"])
    cmd("terminal page disable")
    super(login_param)
  end
  
  
  def logout_expand(logout_param)
    cmd("exit", {"error"=>Dialogician::Device::PATTERN_IGNORE})
    super(logout_param)
  end
  
  
  def save()
    cmd("write", {"success"=>["y/n"]})
    cmd_force("y")
  end


  #
  # num_file
  #   [1-4]
  # target
  #   (external|internal)
  # filename
  #   remote file
  #   e.x.) consoleserver-config.txt
  # tftp_ip
  #   e.x.) 192.0.2.1
  #
  def copy_config_tftp(num_file, target, filename, tftp_ip)
    cmd("tftp put setup startup #{num_file} #{target} remote #{filename} #{tftp_ip}")
  end
  

  def reboot(login_param)
    # TODO: reboot test
  end
  
  
  def config
    return cmd("show config running all")
  end
  
  
  def change_config?
    running = cmd("show config running all")
    startup = cmd("show config startup")
    
    (running == startup)? true : false
  end

  
end; end
