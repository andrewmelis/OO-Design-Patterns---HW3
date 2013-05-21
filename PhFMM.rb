#base class for all three layers -- allows for global control variables
class PhFMM
  @@amps = 0
  @@amps = 0
  @@t = 0

  def showControlVars
    puts "PSI: #{@@amps}, AMPS: #{@@amps}, Time: #{@@t}"
  end

  def get_amps
    @@amps
  end
  
  def get_psi
    @@psi
  end
  
  def get_t
    @@t
  end


end

