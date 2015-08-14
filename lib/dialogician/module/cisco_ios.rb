# encoding: utf-8

module Cisco; module IOS
  
  
  def pattern_error
    
    pattern_error = [
      /% Unknown command/,
      /% Incomplete command/,
      /% Invalid input/,
      /% Bad passwords/,
      /Command rejected:/
    ]
    
    return pattern_error
  end
  
  
  def login_expand(login_param)
    cmd("terminal length 0")
    cmd("terminal width 0")
    input_password("enable", login_param["enable_password"], {"error"=>Dialogician::Device::PATTERN_IGNORE})
    cmd("terminal no monitor")
    super(login_param)
  end
  
  
  def logout_expand(logout_param)
    cmd("end", {"error"=>Dialogician::Device::PATTERN_IGNORE})
    super(logout_param)
  end
  
  
  def save()
    cmd("end", {"error"=>Dialogician::Device::PATTERN_IGNORE})
    cmd("write memory")
  end
  

  #
  # filename
  #   remote file
  #   e.x.) catalyst-config.txt
  # tftp_ip
  #   e.x.) 192.0.2.1
  #
  def copy_config_tftp(filename, tftp_ip)
    cmd("copy startup-config tftp://#{tftp_ip}/#{filename}", {"success"=>["Address or name of remote host"]})
    cmd_force("", {"success"=>["Destination filename"]})
    cmd_force("")
  end
  
  
  def reboot(login_param)
    cmd("reload", {"success"=>["yes/no", "confirm"]})
    cmd("y", {"success"=>"confirm"})  if last_match =~ /yes\/no/
    cmd_force("")
    relogin(login_param)
  end
  
  
  def config
    return cmd("show running-config")
  end
  
  
  def change_config?
    running = cmd("show running-config")
    startup = cmd("show startup-config")
    
    (running == startup)? true : false
  end
  
end; end
