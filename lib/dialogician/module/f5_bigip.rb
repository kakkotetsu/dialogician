# encoding: utf-8

#
# tested with
# (tmos)# show sys version
#  Product  BIG-IP
#  Version  11.5.1
#  Build    10.0.180
#  Edition  Hotfix HF10
#
module F5; module BIGIP
  
  
  def pattern_error
    
    pattern_error = [
      /Syntax Error/,
      /command not found/
    ]
    
    return pattern_error
  end
  
  
  def login_expand(login_param)
    super(login_param)
  end
  
  
  def logout_expand(logout_param)
    super(logout_param)
  end
  

  #
  # filename : create file path & name e.x.) "/var/tmp/lb001.ucs"
  #  
  def save_ucs(filename)
    cmd("tmsh", {"error"=>Dialogician::Device::PATTERN_IGNORE})
    cmd("delete /sys ucs #{filename}", {"error"=>Dialogician::Device::PATTERN_IGNORE})
    cmd("save /sys ucs #{filename}")

    cmd("bash", {"error"=>Dialogician::Device::PATTERN_IGNORE})
    ret = cmd("ls -al #{filename}", {"error"=>Dialogician::Device::PATTERN_IGNORE})
    cmd("exit", {"error"=>Dialogician::Device::PATTERN_IGNORE})
    return ret
  end


  #
  # create SCF files (scf text file & tar file)
  #
  # see. https://support.f5.com/kb/en-us/solutions/public/13000/400/sol13408.html
  # (sol13408: Overview of single configuration files (11.x - 12.x))
  # 
  # filename : create file path & name e.x.) "/var/tmp/lb001.scf"
  #  
  def save_scf(filename)
    cmd("tmsh", {"error"=>Dialogician::Device::PATTERN_IGNORE})
    cmd("delete /sys config file #{filename}", {"error"=>Dialogician::Device::PATTERN_IGNORE})
    cmd("save /sys config file #{filename}")

    cmd("bash", {"error"=>Dialogician::Device::PATTERN_IGNORE})
    ret = cmd("ls -al #{filename}.*", {"error"=>Dialogician::Device::PATTERN_IGNORE})
    cmd("exit", {"error"=>Dialogician::Device::PATTERN_IGNORE})
    return ret
  end


  def reboot(login_param)
    #
  end
  
  
  def config
    #return cmd("show config running all")
  end
  
  
  def change_config?
    #running = cmd("show config running all")
    #startup = cmd("show config startup")
    
    #(running == startup)? true : false
  end

  
end; end
