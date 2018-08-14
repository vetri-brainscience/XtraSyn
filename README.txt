This is the readme for the model associated with the paper:

Hummos A, Franklin CC, Nair SS (2014) Intrinsic mechanisms stabilize
encoding and retrieval circuits differentially in a hippocampal
network model. Hippocampus

This model was contributed by Ali Hummos.

A biologically realistic model of the hippocampus matched closely
using parameters from published literature. The model is constrained
to perform pattern separation and completion and is used to examine
the unbounded spread of excitation during these processes.

This model has been developed using the NEURON simulator (Hines and
Carnavale, 2008).

Summary of files: 

- Hipp.hoc:             Main file to run the simulations and adjust parameters
- Protocol. hoc:        Triggers changes in ACH levels and synaptic
                        plasticity
- Connect.hoc:		Creates synaptic connections
- StimuliPatterns.hoc:  Creates the input patterns for the encoding
                        and retrieval experiment
- StimuliStability.hoc: Creates the input patterns for the network
                        stability profile experiment
-MakeLocations.hoc:     Creates three dimensional locations for
                        modeled neurons
- Izh.mod:              Defines the Izhikevich cell model as a
                        mechanism attached to biophysical cells
- Templates.hoc:        Defines all the cell types and their
                        parameters
- pyr2pyr.mod:          Defines the synapse object for excitatory
                        synapses
- Inter2pyr.mod:        Defines the synapse object for inhibitory
                        synapses
- Synapses.txt:         A Comma separated table containing all
                        parameters necessary to define synaptic
                        connections between cell populations

Usage:

- The file Hipp.hoc can be used to run the simulation, but prior to
  that the experiment parameters must be set up by changing a few
  variables as follows.

1) OutPath: Specifies the folder path where the output files from the
simulation will be stored.  No graphs are produced by the Neuron code
but rather output is stored in data files.
2) expSig: a unique identifier for each experiment as specified by the
user.  This identifier is added to names of the files produced by the
simulation, to allow these files to be accurately identified in the
analysis stage.
3) Experiment: the value of the variable Experiment determines the
pattern of inputs to EC neurons, the duration of the experiment,
activation of long-term plasticity, and changes in the level of
neuromodulators.  All these experiment parameters are set up in the
file protocol.hoc based on the value of the variable Experiment.  The
available experimental protocols are as follows:

Experiment = 0          this is the experiment presented in the
methods section of the paper, where all patterns 1 (consists of 10
randomly selected EC neurons) is presented to the network for encoding
for five trials, with LTP activated, and ACh set to high.  Followed by
the presentation of patterns 1 through 11 with LTP inactivated and ACh
set to the value assigned to the variable "Mods2".  The value of this
variable can be set by editing the file Hipp.hoc and it controls the
level of ACh during retrieval, to examine the effects of the
neuromodulator on the dynamics of retrieval.

Experiment = 2          this is a modified protocol where the network
learns both pattern 1 and pattern 11 interleaved in 10 trials.  Then
retrieval is tested with the probe patterns that gradually morph from
pattern 1 to pattern 11.  The results produced were similar To
Experiment=0 and were not reported in the paper.

Experiment = 3          this is the main experiment from the paper examining
network stability.  An increasing number of EC neurons receive a
stimulus of one action potential every 500 ms.  ACh is constant in
this experiment and is set to the value assigned to the variable
Mods2.

Experiment = 4          this is a short experiment where 20 EC neurons
receive an action potential at times zero and the response of CA3
pyramidal cells and well and inhibition are monitored (See figure
10D).

4) ACHlevel: this variable determines the level of the neuromodulator
Acetylcholine during the experiment.  For experiment 3, and it
determines the level of the neuromodulator for the whole experiment,
whereas for experiment 0, it only determines the level during the
retrieval phase.

5) Seed: the value from this variable is used to seed the
randomization process, thereby each value would produce a different
random version of the network with different connectivity and initial
states.  Currently, the code is set to read this value from a text
file "seed.txt".  A batch file is included with the code to help
run each experiment for 10 different seeds.  After updating the folder
paths in the batch file, or it can be used to run the experiment for
each value in the file "/inputs/seeds.txt".

6) Network connectivity: the connectivity of the network can be
controlled by editing the relevant section in the file connect.hoc.
This section of code copied below, specifies which neuronal
populations are to be connected.  Connections between any two cell
populations can be removed simply by commenting out the relevant line
(in neuron this is done by adding //at the beginning of the line).

ConnectAreas(EC, CA3e, EC2CA3e, Excitatory)
ConnectAreas(EC, CA3b, EC2CA3b, Excitatory)

ConnectAreas(DGg, CA3b, DGg2CA3b, Excitatory) 

ConnectAreas(CA3e, CA3e, CA3e2CA3e, Excitatory) 
ConnectAreas(CA3e, CA3b, CA3e2CA3b, Excitatory) 

// ConnectAreas(CA3o, CA3e, CA3o2CA3e, Inhibitory)
// ConnectAreas(CA3b, CA3e, CA3b2CA3e, Inhibitory)

// ConnectAreas(CA3b, CA3o, CA3b2CA3o, Inhibitory)

ConnectMF = 1

ConnectAreas(EC, DGg, EC2DGg, Excitatory)
ConnectAreas(EC, DGb, EC2DGb, Excitatory)

ConnectAreas(DGg, DGb, DGg2DGb, Excitatory)

ConnectAreas(DGh, DGg, DGh2DGg, Inhibitory)
ConnectAreas(DGb, DGg, DGb2DGg, Inhibitory)

ConnectAreas(DGb, DGh, DGb2DGh, Inhibitory)

(note that in this example above CA3 OLM (CA3o) and BC (CA3b)
interneurons are disconnected from pyramidal cells)

7) Output files: by default, the simulator produces files with a
record of all the spike times and all areas in the model.  In
addition, it can also produce files containing all the synaptic
current values, synaptic weight values, and neuronal membrane
potentials.  The additional output files can be produced by assigning
a value of 1 to a subset of three variables in the WriteOutput.hoc
file.
The simulator by default outputs spike times for each cell
population. It creates text files with the following naming rule:
OutPath + IDstring + "Spiketimes" + Area code + .txt
IDstring = Acetylcholine level + Experiment + Seed + expSig
The string Spiketimes is constant and is used to denote these files as
containing spike times.  Seed is the value used to initialize the
random process.
Area code, denotes which cell population the spike times come
from. Modeled areas has the following area codes:

EC: 0	
CA3 pyr: 1	OLM: 2		BC: 3		
DG GC: 4	HIPP: 5		BC: 6

Similarly, the simulator can also create output files for membrane
potentials, synaptic currents, and synaptic weights as they change
across the simulation. File naming for membrane potentials is as
described above for spike times except that the string "spiketimes" is
replaced by "volts". For synaptic currents and synaptic weights one
file is generated for each. The file contains a comma separated table
with the first column containing the simulation time values, and
subsequent columns each representing the current or the weight value
of a synapse as it changes over time. The first row in each of these
columns contains the synapse ID number. This ID number can be
referenced against another table in the file called connections.txt
which has the presynaptic neuron ID and area code and the postsynaptic
neuron ID and area code as well.

These files are produced in the "writetoutput.hoc" file. If the files
for the membrane potentials, synaptic currents, and or weights are
needed as output from the simulation, the code to produce them can be
activated by setting the variables Writesvolts, Writecurrents, and/or
Writeweights to a value of 1.

Matlab analysis:

The data files generated by the Neuron simulator are further analyzed
in MATLAB. We here provide a brief description of the Matlab scripts
included.

function [profiles] = Stability(fileSearch, path)

Stability.m: This script analyzes the stability profile of the network
given the Spiketimes of the neurons.  The script defines a function
that is used as follows:

Inputs:

- File searches: A cell array of 1 to 3 strings that are used to
  identify 1 to 3 sets of experiment files.  This algorithm uses the
  naming rule of output files employed by the neuron code.  The
  strings can use wildcard searches to capture all the files that need
  to

- be included in the analysis.  See below for an example.

- OutputPath: a string containing the relative path where the output
  files can be found.

Example:

- Stability({'139full', '13*OLMoff'},'.\Outputs\') 

Output files for these examples are included with the code.
Note that the second file search string uses a star instead of seed
number to capture all files for this experiment which was run with
multiple different seeds.
  
Correlation.m: Imports results from the pattern completion than
separation experiment and calculates correlation between outputs
generated by patterns 1 to 11 and the output generated by pattern 1.
function [corrs] = Correlation (FileSearch, OutPath)
Inputs:
- FileSearch: A string that uniquely identifies a set of experiments.
  This algorithm uses the naming rule of output files employed by the
  neuron code.  The string can use wildcard searches to capture all
  the files that need to be included in the analysis.  See below for
  an example.
- OutPath: A string containing the relative path where the output
  files can be found.
Example:
- Correlation('00*seps', '.\Outputs\') 
- Example output files are included.

For assistance are any questions, please contact:
       Ali Hummos, MD
hummosa@gmail.com
Health Informatics, University of Missouri Columbia

