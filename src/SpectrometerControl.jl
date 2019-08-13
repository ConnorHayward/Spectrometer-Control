module SpectrometerControl

using PyCall
using Sockets

@pyimport win32com.client as demo # Import win32 library
@pyimport win32clipboard as cb
@pyimport pywinauto as app

include("monochromater.jl")
include("spectrometer.jl")

end # module
