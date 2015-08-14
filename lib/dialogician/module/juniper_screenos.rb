# encoding: utf-8

module Juniper; module ScreenOS
  
  
  def pattern_error
    
    pattern_error = [
      /unknown keyword/
    ]
    
    return pattern_error
  end
  
  
  def login_expand(login_param)
    cmd("set console page 0")
    super(login_param)
  end
  
  
  def logout_expand(logout_param)
    cmd("unset console page")
    cmd("exit", {"success"=>["Configuration modified, save? [y]/n", Dialogician::Device::PATTERN_CONNECTION_CLOSE]})
    cmd_force("y")
    super(logout_param)
  end
  
  
  def save()
    cmd("save")
  end


  #
  # filename
  #   remote file
  #   e.x.) firewall-config.txt
  # tftp_ip
  #   e.x.) 192.0.2.1
  #
  def copy_config_tftp(filename, tftp_ip)
    cmd("save config to tftp #{tftp_ip} #{filename}")
  end
  

  def reboot(login_param)
    # TODO: reboot test
  end
  
  
  #
  # opts {}
  #   :all
  #      show all configurations, including defaults
  #
  def config(opts = {})
    command = "get config"
    command += " all" unless opts[:all].nil?
    return cmd(command)
  end
  
  
  def change_config?
    running = cmd("get config")
    startup = cmd("get config saved")
    
    (running == startup)? true : false
  end

  
end; end
