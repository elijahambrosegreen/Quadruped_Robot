%% Absolute Inversion Subnetwork Example Without c2

% Clear Everything.
clear, close('all'), clc


%% Define Simulation Parameters.

% Set the level of verbosity.
b_verbose = true;                                                       % [T/F] Printing flag.

% Define the network integration step size.
network_dt = 1.3e-4;                                                    % [s] Simulation timestep.

% Define the simulation duration.
network_tf = 3;                                                         % [s] Simulation duration.


%% Define Basic Network Parameters.

% Set the maximum voltages.
R1 = 20e-3;                                                             % [V] Maximum Voltage (Neuron 1)

% Set the membrane conductances.
Gm1 = 1e-6;                                                             % [S] Membrane Conductance (Neuron 1)
Gm2 = 1e-6;                                                             % [S] Membrane Conductance (Neuron 2) 

% Set the membrane capacitance.
Cm1 = 5e-9;                                                             % [F] Membrane Capacitance (Neuron 1)
Cm2 = 5e-9;                                                             % [F] Membrane Capacitance (Neuron 2)

% Set the applied currents.
% Ia1 = 0;                                                              % [A] Applied Current (Neuron 1)
Ia1 = R1*Gm1;                                                           % [A] Applied Current (Neuron 1)

% Set the network design parameters.
R2_target = 20e-3;                                                      % [V] Maximum Voltage Target (Neuron 2) (Used to compute c1 such that R2 will be set to the target value.)
delta = 1e-3;                                                           % [V] Membrane Voltage Offset
c1 = ( delta*R1*R2_target )/( R2_target - delta );                     	% [W] Design Constant 1


%% Compute Derived Network Parameters.

% Compute the network properties.
c2 = ( c1 - delta*R1 )/delta;                                           % [A] Design Constant 2.
R2 = c1/c2;                                                             % [V] Maximum Voltage (Neuron 2).
Ia2 = R2*Gm2;                                                           % [A] Applied Current (Neuron 2).
dEs21 = 0;                                                              % [V] Synaptic Reversal Potential (Synapse 21)
gs21 = ( R1*Ia2 )/( c1 - c2*dEs21 );                                    % [S] Synaptic Conductance (Synapse 21)


%% Print Network Parameters.

% Print a summary of the relevant network parameters.
fprintf( 'NETWORK PARAMETERS:\n' )
fprintf( 'c1 = %0.2f [nW]\n', c1*( 10^9 ) )
fprintf( 'c2 = %0.2f [nA]\n', c2*( 10^9 ) )
fprintf( 'delta = %0.2f [mV]\n', delta*( 10^3 ) )
fprintf( 'R1 = %0.2f [mV]\n', R1*( 10^3 ) )
fprintf( 'R2 = %0.2f [mV]\n', R2*( 10^3 ) )
fprintf( 'Gm1 = %0.2f [muS]\n', Gm1*( 10^6 ) )
fprintf( 'Gm2 = %0.2f [muS]\n', Gm2*( 10^6 ) )
fprintf( 'Cm1 = %0.2f [nF]\n', Cm1*( 10^9 ) )
fprintf( 'Cm2 = %0.2f [nF]\n', Cm2*( 10^9 ) )
fprintf( 'Ia1 = %0.2f [nA]\n', Ia1*( 10^9 ) )
fprintf( 'Ia2 = %0.2f [nA]\n', Ia2*( 10^9 ) )
fprintf( 'dEs21 = %0.2f [mV]\n', dEs21*( 10^3 ) )
fprintf( 'gs21 = %0.2f [muS]\n', gs21*( 10^6 ) )


%% Create Absolute Inversion Subnetwork.

% Create an instance of the network class.
network = network_class( network_dt, network_tf );

% Create the network components.
[ network.neuron_manager, neuron_IDs ] = network.neuron_manager.create_neurons( 2 );
[ network.synapse_manager, synapse_IDs ] = network.synapse_manager.create_synapses( 1 );
[ network.applied_current_manager, applied_current_IDs ] = network.applied_current_manager.create_applied_currents( 2 );

% Set the network parameters.
network.neuron_manager = network.neuron_manager.set_neuron_property( neuron_IDs( 1 ), 0, 'Gna' );
network.neuron_manager = network.neuron_manager.set_neuron_property( neuron_IDs( 2 ), 0, 'Gna' );
network.neuron_manager = network.neuron_manager.set_neuron_property( neuron_IDs( 1 ), R1, 'R' );
network.neuron_manager = network.neuron_manager.set_neuron_property( neuron_IDs( 2 ), R2, 'R' );
network.neuron_manager = network.neuron_manager.set_neuron_property( neuron_IDs( 1 ), Gm1, 'Gm' );
network.neuron_manager = network.neuron_manager.set_neuron_property( neuron_IDs( 2 ), Gm2, 'Gm' );
network.neuron_manager = network.neuron_manager.set_neuron_property( neuron_IDs( 1 ), Cm1, 'Cm' );
network.neuron_manager = network.neuron_manager.set_neuron_property( neuron_IDs( 2 ), Cm2, 'Cm' );

network.synapse_manager = network.synapse_manager.set_synapse_property( synapse_IDs( 1 ), 1, 'from_neuron_ID' );
network.synapse_manager = network.synapse_manager.set_synapse_property( synapse_IDs( 1 ), 2, 'to_neuron_ID' );
network.synapse_manager = network.synapse_manager.set_synapse_property( synapse_IDs( 1 ), gs21, 'g_syn_max' );
network.synapse_manager = network.synapse_manager.set_synapse_property( synapse_IDs( 1 ), dEs21, 'dE_syn' );

network.applied_current_manager = network.applied_current_manager.set_applied_current_property( applied_current_IDs( 1 ), 1, 'neuron_ID' );
network.applied_current_manager = network.applied_current_manager.set_applied_current_property( applied_current_IDs( 2 ), 2, 'neuron_ID' );
network.applied_current_manager = network.applied_current_manager.set_applied_current_property( applied_current_IDs( 1 ), Ia1, 'I_apps' );
network.applied_current_manager = network.applied_current_manager.set_applied_current_property( applied_current_IDs( 2 ), Ia2, 'I_apps' );


%% Numerical Stability Analysis.

% Compute the maximum RK4 step size and condition number.
% [ A, dt_max, condition_number ] = network.RK4_stability_analysis( cell2mat( network.neuron_manager.get_neuron_property( 'all', 'Cm' ) ), cell2mat( network.neuron_manager.get_neuron_property( 'all', 'Gm' ) ), cell2mat( network.neuron_manager.get_neuron_property( 'all', 'R' ) ), network.get_gsynmaxs( 'all' ), network.get_dEsyns( 'all' ), zeros( network.neuron_manager.num_neurons, 1 ), 1e-6 );
% [ A, dt_max, condition_number ] = network.RK4_stability_analysis( cell2mat( network.neuron_manager.get_neuron_property( 'all', 'Cm' ) ), cell2mat( network.neuron_manager.get_neuron_property( 'all', 'Gm' ) ), cell2mat( network.neuron_manager.get_neuron_property( 'all', 'R' ) ), network.get_gsynmaxs( 'all' ), network.get_dEsyns( 'all' ), [ 0; Ia2/Gm2 ], 1e-6 );
[ A, dt_max, condition_number ] = network.RK4_stability_analysis( cell2mat( network.neuron_manager.get_neuron_property( 'all', 'Cm' ) ), cell2mat( network.neuron_manager.get_neuron_property( 'all', 'Gm' ) ), cell2mat( network.neuron_manager.get_neuron_property( 'all', 'R' ) ), network.get_gsynmaxs( 'all' ), network.get_dEsyns( 'all' ), [ ( ( delta*Gm2 - Ia2 )*R1 )/( ( dEs21 - delta )*gs21 ); delta ], 1e-6 );

% Print out the stability information.
fprintf( '\nSTABILITY SUMMARY:\n' )
fprintf( 'Linearized System Matrix: A =\n\n' ), disp( A )
fprintf( 'Max RK4 Step Size: \tdt_max = %0.3e [s]\n', dt_max )
fprintf( 'Proposed Step Size: \tdt = %0.3e [s]\n', network_dt )
fprintf( 'Condition Number: \tcond( A ) = %0.3e [-]\n', condition_number )


%% Simulate the Network.

% Start the timer.
tic

% Simulate the network.
[ network, ts, Us, hs, dUs, dhs, G_syns, I_leaks, I_syns, I_nas, I_apps, I_totals, m_infs, h_infs, tauhs, neuron_IDs ] = network.compute_set_simulation(  );

% End the timer.
toc


%% Plot the Network Results.

% Plot the network currents over time.
fig_network_currents = network.network_utilities.plot_network_currents( ts, I_leaks, I_syns, I_nas, I_apps, I_totals, neuron_IDs );

% Plot the network states over time.
fig_network_states = network.network_utilities.plot_network_states( ts, Us, hs, neuron_IDs );

% Animate the network states over time.
fig_network_animation = network.network_utilities.animate_network_states( Us, hs, neuron_IDs );

