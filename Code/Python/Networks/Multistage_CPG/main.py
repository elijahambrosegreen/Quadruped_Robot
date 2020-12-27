import numpy as np

from Nprops import Nprops
from Synprops import Synprops
from Network import Network

from matplotlib import pyplot as plt

### Specify neuron properties
R = 20e-3
Er = -60e-3
n_a = Nprops(
    Cm = 5e-9,
    Gm = 1e-6,
    Er = Er,
    Am = 1,
    Sm = -50,
    Em = 2*R + Er,
    Ah = 0.5,
    Sh = 50,
    Eh = Er,
    Ena = 110e-3 + Er,
    tauh_max = 0.250,
    Gna = 1.9493223982564208591225334010754721703051473014056682586669921875e-06
)

### List neurons in the network
neurons = [n_a]*4

### Specify synapse properties
s_a = Synprops(
    gmax = 7.86971519804733567581413004876633721096368390135467052459716796875e-07,
    Esyn = -40e-3 + Er,
    Ehi = R + Er,
    Elo = Er
)
s_b = Synprops(
    gmax = 4.2551104842347686800385782833477943398747811443172395229339599609375e-07,
    Esyn = -40e-3 + Er,
    Ehi = R + Er,
    Elo = Er
)

### List synapses in the network [from, to, props]. Indices must match neurons array
synapses = [
         [1, 0, s_a]
        ,[2, 0, s_a]
        ,[3, 0, s_b]

        ,[0, 1, s_b]
        ,[2, 1, s_a]
        ,[3, 1, s_a]

        ,[0, 2, s_a]
        ,[1, 2, s_b]
        ,[3, 2, s_a]

        ,[0, 3, s_a]
        ,[1, 3, s_a]
        ,[2, 3, s_b]
]

### Create network and simulate
network = Network(neurons, synapses)

tf = 5
dt = 1e-3
num_timesteps = len(np.arange(0, tf+dt, dt))

Iapps = np.zeros((num_timesteps, len(neurons)))
Iapps[0][0] = 2.0e-8

network.SetSimulationProperties(tf, dt, Iapps)
network.Simulate()

### Plot results
plt.plot(network.ts, network.Vs - network.Ers)
plt.show()

# ### Comparing to outputs generated by MATLAB
# 
# m_Us = np.genfromtxt('./matlab_output/Us',delimiter=',')
# m_hs = np.genfromtxt('./matlab_output/hs',delimiter=',')
# m_dUs = np.genfromtxt('./matlab_output/dUs',delimiter=',')
# m_dhs = np.genfromtxt('./matlab_output/dhs',delimiter=',')
# m_Ileaks = np.genfromtxt('./matlab_output/Ileaks',delimiter=',')
# m_Isyns = np.genfromtxt('./matlab_output/Isyns',delimiter=',')
# m_Inas = np.genfromtxt('./matlab_output/Inas',delimiter=',')
# m_Itotals = np.genfromtxt('./matlab_output/Itotals',delimiter=',')
# m_minfs = np.genfromtxt('./matlab_output/minfs',delimiter=',')
# m_hinfs = np.genfromtxt('./matlab_output/hinfs',delimiter=',')
# m_tauhs = np.genfromtxt('./matlab_output/tauhs',delimiter=',') 
# m_Gsyns = np.genfromtxt('./matlab_output/Gsyns',delimiter=',').reshape(*network.Gsyns.shape)
# 
# ### Print maximum absolute deviations
# 
# print(np.abs(network.Us - m_Us).max())
# print(np.abs(network.hs - m_hs).max())
# print(np.abs(network.dUs - m_dUs).max())
# print(np.abs(network.dhs - m_dhs).max())
# print(np.abs(network.Ileaks - m_Ileaks).max())
# print(np.abs(network.Isyns - m_Isyns).max())
# print(np.abs(network.Inas - m_Inas).max())
# print(np.abs(network.Itotals - m_Itotals).max())
# print(np.abs(network.minfs - m_minfs).max())
# print(np.abs(network.hinfs - m_hinfs).max())
# print(np.abs(network.tauhs - m_tauhs).max())
# print(np.abs(network.Gsyns - m_Gsyns).max())
# 

#csvwrite('Us',Us)
#csvwrite('hs',hs)
#csvwrite('dUs',dUs)
#csvwrite('dhs',dhs)
#csvwrite('Ileaks',Ileaks)
#csvwrite('Isyns',Isyns)
#csvwrite('Inas',Inas)
#csvwrite('Itotals',Itotals)
#csvwrite('minfs',minfs)
#csvwrite('hinfs',hinfs)
#csvwrite('tauhs',tauhs) 
#csvwrite('Gsyns',Gsyns)
