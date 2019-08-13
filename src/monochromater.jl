using Sockets

"""
    goto(address::Array,wavelength::Float64)
Sets monochromater output to target `wavelength`. Converts from nm to angstron internally.
"""
function goto(address::Array,wavelength::Float64)
    io = connect(address[1],address[2])
    write(io, UInt8(16),hton(UInt16(wavelength*10)))
    sleep(0.2)
    close(io)
end
export goto

"""
    echo(address::Array)
Query monochromater with echo, checks return value.
"""
function echo(address::Array)
    io = connect(address[1],address[2])
    out = write(io, UInt8(27))
    sleep(0.2)
    read(io, 2) == [27] || error("Unexpected reply on echo")
    sleep(0.2)
    close(io)
end
export echo

"""
    status(address::Array, query)
Get monochromater status.
"""
function status(address::Array, query)
    io = connect(address[1],address[2])
    write(io,UInt8(56),hton(UInt8(query)))
    sleep(0.2)
    read(io,1)
    sleep(0.2)
    close(io)
end
export status

"""
    reset_spec(address::Array)
Resets the monochromater to open (no seletion) position
"""
function reset_spec(address::Array)
    io = connect(address[1],address[2])
    write(io, UInt8(255),hton(UInt8(255)),hton(UInt8(255)))
    sleep(0.2)
    close(io)
end
export reset_spec

"""
    scan(address::Array, start::Float64, finish::Float64)
Perform a wavelength scan between `start` and `end`. Speed fixed
"""
function scan(address::Array, start::Float64, finish::Float64)
    io = connect(address[1],address[2])
    write(io, UInt8(12),hton(UInt16(start)),hton(UInt16(finish)))
    sleep(0.2)
    close(io)
end
export scan
