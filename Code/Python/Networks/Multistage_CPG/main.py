import numpy as np

from Nprops import Nprops
from Synprops import Synprops
from Network import Network


R = 20e-3
nprops = Nprops(
    Cm = 5e-9,
    Gm = 1e-6,
    Er = -60e-3,
    R = R,
    Am = 1,
    Sm = -50,
    dEm = 2*R,
    Ah = 0.5,
    Sh = 50,
    dEh = 0,
    dEna = 110e-3,
    tauh_max = 0.250
)

synprops = Synprops(
    dEsyn = -40e-3,
    delta_bistable = -10e-3,
    delta_oscillatory = 0.01e-3
)

network = Network(4, nprops, synprops)
network.SetSimulationProperties(tf = 5, dt = 1e-3)
network.Simulate()

### Comparing to outputs generated by MATLAB

m_Us = np.genfromtxt('./matlab_output/Us',delimiter=',')
m_hs = np.genfromtxt('./matlab_output/hs',delimiter=',')
m_dUs = np.genfromtxt('./matlab_output/dUs',delimiter=',')
m_dhs = np.genfromtxt('./matlab_output/dhs',delimiter=',')
m_Ileaks = np.genfromtxt('./matlab_output/Ileaks',delimiter=',')
m_Isyns = np.genfromtxt('./matlab_output/Isyns',delimiter=',')
m_Inas = np.genfromtxt('./matlab_output/Inas',delimiter=',')
m_Itotals = np.genfromtxt('./matlab_output/Itotals',delimiter=',')
m_minfs = np.genfromtxt('./matlab_output/minfs',delimiter=',')
m_hinfs = np.genfromtxt('./matlab_output/hinfs',delimiter=',')
m_tauhs = np.genfromtxt('./matlab_output/tauhs',delimiter=',') 
m_Gsyns = np.genfromtxt('./matlab_output/Gsyns',delimiter=',').reshape(*network.Gsyns.shape)

### Print maximum absolute deviations

print(np.abs(network.Us - m_Us).max())
print(np.abs(network.hs - m_hs).max())
print(np.abs(network.dUs - m_dUs).max())
print(np.abs(network.dhs - m_dhs).max())
print(np.abs(network.Ileaks - m_Ileaks).max())
print(np.abs(network.Isyns - m_Isyns).max())
print(np.abs(network.Inas - m_Inas).max())
print(np.abs(network.Itotals - m_Itotals).max())
print(np.abs(network.minfs - m_minfs).max())
print(np.abs(network.hinfs - m_hinfs).max())
print(np.abs(network.tauhs - m_tauhs).max())
print(np.abs(network.Gsyns - m_Gsyns).max())


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
