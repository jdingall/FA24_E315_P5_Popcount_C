import numpy as np

from pynq import Overlay
from pynq import MMIO

class MyHardwarePopcount():
    
    def __init__(self):
        self.overlay = Overlay('bitstream.bit')        
        self.mmio = self.overlay.axi_popcount_0.S_AXI_LITE

    def name(self):
        return "Hardware_Popcount"
    
    def countInt(self, n): 
        self.mmio.write(0x0, 0x1)
        self.mmio.write(0x4, int(n))
        return self.mmio.read(0x4)
    
    def countArray (self, buf):
        total_ones = 0
        self.mmio.write(0x0, 0x1)
        for b in buf:
            self.mmio.write(0x4, int(b))
        return self.mmio.read(0x4)
        
    def countFile(self,file):
        f = open(file, "r")
        buf = np.fromfile(f, dtype=np.uint32)
        return self.countArray(buf) 


