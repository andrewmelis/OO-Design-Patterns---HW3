require 'PhFMM.rb'
require 'singleton'

class UserInterface < PhFMM
  include Singleton #only want one UI!

  #can set/get control vars with inherited setters/getters from parent class, PhFMM

  def manualRun 
    #stuff
  end

  def read_recipe     #from file

    #stuff 
  end

  def run_recipe r
    #run r
  end


end

class MachineControl < PhFMM
  include Singleton #only want one MachineController!
  @recipe

  #can set/get control vars with inherited setters/getters from parent class, PhFMM

  def set_recipe &recipe
    @recipe = recipe
  end

  def execute
    @recipe.call ( self)

    #return true or false -- call validate?
  end

end

class Hardware < PhFMM

  #requirements 1 & 2 taken care of by global vars
  def set_psi x
    if x>200
      x=200
    elsif x<0
      x=0
    end
    @@psi = x
  end

  def set_amps x
    if x>200
      x=200
    elsif x<0
      x=0
    end
    @@amps = x
  end

  def set_t x
    @@t = x
  end
  #end private methods

  def start
    #stuff
  end
  
  def set_cvs (time, *hash_of_cvs)  #hash of cvs
    #print these in .csv file

  end

  def stop
    #stuff
  end

  private :set_psi, :set_amps, :set_t
end

#using ruby Procs instead of Strategy classes




