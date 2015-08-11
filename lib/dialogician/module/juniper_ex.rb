# encoding: utf-8

module Juniper; module Ex
  
  
  def pattern_success
    return /^(\S+@\S+)?[#>%] ?$/
  end
  
  
  def pattern_error
    
    pattern_error = [
      /unknown command/,
      /syntax error/,
      /missing argument/,
      /invalid value/,
      /error:/
    ]
    
    return pattern_error
  end
  
  
  def login_expand(login_param)
    cmd("cli", {"error"=>Dialogician::Device::PATTERN_IGNORE})
    cmd("set cli screen-length 0", {"error"=>Dialogician::Device::PATTERN_IGNORE})
    cmd("set cli screen-witdh 0", {"error"=>Dialogician::Device::PATTERN_IGNORE})
    cmd("set cli timestamp format '%Y-%m-%d-%T'", {"error"=>Dialogician::Device::PATTERN_IGNORE})
    super(login_param)
  end
  
  
  def logout_expand(logout_param)
    cmd("exit configuration-mode", {"error"=>Dialogician::Device::PATTERN_IGNORE})
    super(logout_param)
  end
  
  
  def save()
    cmd("commit check")
    cmd("show | compare")
    cmd("commit")
  end
  
  
  def reboot(login_param)
    cmd("exit configuration-mode", {"error"=>Dialogician::Device::PATTERN_IGNORE})
    cmd("request system reboot", {"success"=>["yes/no", "confirm"]})
    cmd_force("yes")
    relogin(login_param)
  end


  #
  # opts {}
  #   :format
  #      config file format
  #         - set
  #         - hierarchical
  #         - xml
  #  
  def config(opts = {})
    format = opts.fetch(:format, "set")
    case format
    when "set"
      return cmd("show configuration | display set | no-more")
    when "hierarchical"
      return cmd("show configuration | no-more")
    when "xml"
      return cmd("show configuration | display xml | no-more")
    else
      return nil
    end
  end


  #
  # opts {}
  #   :interface
  #      Source interface (multicast, all-ones, unrouted packets)
  #      e.x.) fxp0.0 ge-1/0/0.3000
  #   :routing_instance
  #      Routing instance for ping attempt
  #   :count
  #      Number of ping requests to send (1..2000000000 packets) default 5 times
  #
  def ping(dst_ip, opts = {})
    command = "ping rapid #{dst_ip}"
    command += " interface #{opts[:interface]}" unless opts[:interface].nil?
    command += " routing-instance #{opts[:routing_instance]}" unless opts[:routing_instance].nil?
    command += " count #{opts[:count]}" unless opts[:count].nil?

    ret = Hash::new 

    result_ping = cmd(command)
    return nil if result_ping.nil?
    result_ping.each_line do |line|
      next if line.nil?
      if /^(?<num_transmit>[0-9]+)\spackets\stransmitted,\s(?<num_received>[0-9]+)\spackets\sreceived,\s(?<percent_loss>[0-9]+)\%\spacket\sloss/ =~ line.to_s then
        ret["num_transmit"] = num_transmit
        ret["num_received"] = num_received
        ret["percent_loss"] = percent_loss
      elsif /^round\-trip\smin\/avg\/max\/stddev\s\=\s(?<rtt_min>[0-9\.]+)\/(?<rtt_avg>[0-9\.]+)\/(?<rtt_max>[0-9\.]+)\/(?<rtt_stddev>[0-9\.]+)\sms/ =~ line.to_s then
        ret["rtt_min"] = rtt_min
        ret["rtt_avg"] = rtt_avg
        ret["rtt_max"] = rtt_max
        ret["rtt_stddev"] = rtt_stddev
      end
    end

    return ret

  end

  
end; end
