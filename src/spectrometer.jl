"""
    emission_spec(io::Array,excwl::Float64,samplename::String)

Obtain an emission spectrum from the Andor device, according to a parameters passed.
Loads the script into paste buffer, and uses keyboard injection to work around API issues.
"""
function emission_spec(io::Array,excwl,samplename)
    goto(io, excwl)

    filename = '"'*data_dir*samplename*'"'
    #script = set_script(filename, Exp_Time,Num_Acc,datno)
    script = get_script();
    cb.OpenClipboard()
    cb.EmptyClipboard()
    cb.SetClipboardText("$script")
    cb.CloseClipboard()

    if !shell["AppActivate"](target)
        println("Cannot use Andor")
        return
   #     println("Loading Andor, please wait")
   #     app.Application()["start"](andor_dir)
   #     sleep(60)
    end

    sleep(0.75)
    shell["AppActivate"](target)
    sleep(0.75)
    shell["AppActivate"](target)
    sleep(0.75)


    shell["SendKeys"]("^n")
    sleep(0.2)
    shell["SendKeys"]("^v")
    sleep(0.2)
    shell["SendKeys"]("^e")
end

export emission_spec

script = "cls()
SetAcquisitionType(0)
SetDatatype(1)
SetFVB()
SetWavelength(400)
SetAccumulate(0.05,30,0.05)
run()
delay(500)
SaveAsciiXY(0,test)
delay(500)
zero(0)
delay(500)
CloseWindow(program)"

"""
    set_script(name::String,exptime::Float64, nexp::Int,runno::Int)

Set the DAQ script used by the Andor spectrometer.

# Arguements
- `name::String`: the output file name.
- `exptime::Float`: the length of each exposure.
- `nexp::Int`: the total number of exposure to take.
- `runno::Int`: the window in which the data appears.
"""
function set_script(name,exptime, nexp,runno)
    script = "cls()
    SetAcquisitionType(0)
    SetDatatype(1)
    SetFVB()
    SetWavelength($Center_WL)
    SetAccumulate($exptime,$nexp,0.05)
    run()
    delay(500)
    SaveAsciiXY($runno,$name)
    delay(500)
    zero($runno)
    delay(500)
    CloseWindow(program)"
end

export set_script

"""
    get_script()

Returns DAQ script.
"""
function get_script()
    script
end
export get_script
