#using ruby Procs instead of Strategy classes
require 'fileutils'

ConstantPressure = lambda do |context|
  
  Hardware.instance.set_t 0
  
  (Hardware.instance.get_t..10).each do |i|
    Hardware.instance.set_t i
    Hardware.instance.set_psi context.part_size+100
    Hardware.instance.set_amps Hardware.instance.get_t*2

    Hardware.instance.stamp_cvs 

  end

end
   

ConstantCurrent = lambda do |context|

  Hardware.instance.set_t 0
  
  (Hardware.instance.get_t..20).each do |i|
    Hardware.instance.set_t i
    Hardware.instance.set_amps context.part_size+50
    Hardware.instance.set_psi 50-Hardware.instance.get_t*2

    Hardware.instance.stamp_cvs
  end
end


Ramp = lambda do |context|

  if context.part_size<50
    raise "part size too small! must be 50 or greater!"
  end
  Hardware.instance.set_t 0
  
  (Hardware.instance.get_t..30).each do |i|
    Hardware.instance.set_t i
    Hardware.instance.set_psi_max Hardware.instance.get_t*10
    Hardware.instance.set_amps context.part_size+20*Hardware.instance.get_t

    Hardware.instance.stamp_cvs
  end
end

Manual = lambda do |context|

  
  (0..Hardware.instance.get_t).each do |i|
    Hardware.instance.set_t i

    Hardware.instance.stamp_cvs
  end
end

