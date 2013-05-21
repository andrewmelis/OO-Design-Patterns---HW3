require './PhFMM.rb'
require './Layers.rb'
require './MachineModes.rb'

ui = UserInterface.instance
mc = MachineControl.instance
h = Hardware.instance

ui.run_recipe "hw3_recipe1.csv"


ui.set_cvs(amps: 75, psi: 100, t: 30)
ui.manualRun

