require './PhFMM.rb'
require './MachineModes.rb'
require 'singleton'

class UserInterface #< PhFMM
  include Singleton #only want one UI!


  def set_cvs(amps: 75, psi: 50, t: 20)
    Hardware.instance.set_amps amps
    Hardware.instance.set_psi psi
    Hardware.instance.set_t t
  end

  def get_cvs
    Hardware.instance.get_cvs
  end

  #TODO fix this
  def manualRun 
    MachineControl.instance.execute_manual
  end

  def run_recipe file
    MachineControl.instance.read_recipe file
    MachineControl.instance.execute
  end

end


class MachineControl #< PhFMM
  include Singleton #only want one MachineControl
  attr_accessor :recipe_name, :machine_mode, :machine_mode_name, :part_size
  
  public
  def read_recipe file
    recipe_file = File.open(file)
    #recipe_array = recipe_file.gets.chomp.split(", ")
    recipe_array = recipe_file.readline.chomp.split(",")



    @recipe_name = recipe_array[0]
    puts "#{recipe_array[1]}"
    set_machine_mode_from_string recipe_array[1]
    set_part_size recipe_array[2].to_i
  end


  def execute
    Hardware.instance.start
    @machine_mode.call (self)

    Hardware.instance.stop

    valid = compare_files #returns true or false

    if valid
      puts "good part!"
    else puts "bad part!"
    end
  end

  def execute_manual
    @recipe_name = "Manual"
    set_machine_mode_from_string "Manual"

    Hardware.instance.start
    @machine_mode.call (self)
    Hardware.instance.stop

  end




  private
  def set_machine_mode_from_string string
    @machine_mode_name = string
    case string
    when "ConstantPressure"
      set_machine_mode &ConstantPressure
    when "ConstantCurrent"
      set_machine_mode &ConstantCurrent
    when "Ramp"
      set_machine_mode &Ramp
    when "Manual"
      set_machine_mode &Manual
    else
      raise "something went wrong while selecting your machine mode"
    end
  end

  def set_machine_mode &machine_mode
    @machine_mode = machine_mode
  end

  def set_part_size num
    if num>100
      num=100
    elsif num<0
      num=0
    end
    @part_size = num
  end

  def compare_files
    same = true
    error = false

    ref_ctr = 0
    das_ctr = 0

    ref = open_reference_file
    das = open_DAS_file


    while same && !error do

      begin
	cur_ref = ref.readline.chomp.split(", ")
	ref_ctr += 1
	das_ref = das.readline.chomp.split(", ")
	das_ctr += 1

      rescue EOFError
	error = true
      end

      same = compare_arrays cur_ref, das_ref
    end

    ref.close
    das.close

    if same && das_ctr == ref_ctr
      return true
    else
      return false
    end

  end

  def compare_arrays a,b
    a==b      #lazy, compare entire row rather than each individual value
  end

  def open_reference_file 
    File.open(@recipe_name+".reference.csv")
  end

  def open_DAS_file 
    File.open(@recipe_name+".DAS.csv")
  end

end

class Hardware #< PhFMM
  include Singleton
  @@amps = 0
  @@amps = 0
  @@t = 0

  @DAS_file

  def get_DAS
    @DAS_file
  end
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


  #requirements 1 & 2 taken care of by global vars
  def set_psi x
    if x>200
      x=200
    elsif x<0
      x=0
    end
    @@psi = x
  end

  #used with Ramp control mode
  def set_psi_max x
    if x>100
      x=100
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

  #used with ConstantCurrent control mode
  def set_amps_min x
    if x<10
      x=10
    end
    @@amps=x
  end

  def set_t x
    @@t = x
  end
  #end private methods

  def start
    create_DAS_file MachineControl.instance.recipe_name
  end

  def create_DAS_file recipe_name
    @DAS_file = File.new(recipe_name+".DAS.csv", "w")
    if recipe_name != "Manual"
      @DAS_file.puts "#{recipe_name},#{MachineControl.instance.machine_mode_name},#{MachineControl.instance.part_size}"
    else
      @DAS_file.puts "#{recipe_name}"
    end
  end


  #this is the "stamper" method
  #def stamp_cvs (time, *hash_of_cvs)  #hash of cvs
  #TODO see if i can get the unlimited inputs to work
  def stamp_cvs 
    @DAS_file.puts "#{get_t},#{get_psi},#{get_amps}"
  end

  def stop
    @DAS_file.close
  end

  #private :set_psi, :set_amps, :set_t
end

#using ruby Procs instead of Strategy classes




