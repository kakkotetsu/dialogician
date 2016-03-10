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
    # can exec shell shichever bash / tmsh
    cmd("tmsh delete /sys ucs #{filename}", {"error"=>Dialogician::Device::PATTERN_IGNORE})
    cmd("tmsh save /sys ucs #{filename}")

    # can exec shell only bash
    #    (tmos)# bash ls
    #    /bin/ls: /bin/ls: cannot execute binary file
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
    # can exec shell shichever bash / tmsh
    cmd("tmsh delete /sys config file #{filename}", {"error"=>Dialogician::Device::PATTERN_IGNORE})
    # only mcpd is running
    #   [root@lbs01:REBOOT REQUIRED:Changes Pending] config # tmsh save /sys config file /var/tmp/test-gio-lbs000.scf
    #   Unexpected Error: Configuration cannot be saved unless mcpd is in the running phase. Save was canceled. See "show sys mcp" and "show sys service". If "show sys service" indicates that mcpd is in the run state, but "show sys mcp" is not in phase running, issue the command "load sys config" to further diagnose the problem.
    cmd("tmsh save /sys config file #{filename}")

    # can exec shell only bash
    #    (tmos)# bash ls
    #    /bin/ls: /bin/ls: cannot execute binary file
    cmd("bash", {"error"=>Dialogician::Device::PATTERN_IGNORE})
    ret = cmd("ls -al #{filename}*", {"error"=>Dialogician::Device::PATTERN_IGNORE})
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
