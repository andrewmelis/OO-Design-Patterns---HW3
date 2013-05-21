#base class for all three layers -- allows for global control variables
class PhFMM
  @@psi = 0
  @@amps = 0
  @@t = 0

  def showControlVars
    puts "PSI: #{@@psi}, AMPS: #{@@amps}, Time: #{@@t}"
  end

end

