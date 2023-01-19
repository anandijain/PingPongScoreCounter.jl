using DSP
using Plots
using PortAudio
using SampledSignals
using SampledSignals: s
using WAV
using LsqFit
using PingPongScoreCounter

devs = PortAudio.devices()

yeti_dev = devs[3]
mac_dev = devs[6]
jabra_dev = devs[5]
mac_out_dev = devs[7]

yeti = PortAudioStream( yeti_dev; adjust_channels=true, warn_xruns=false)
mac = PortAudioStream(mac_dev; adjust_channels=true, warn_xruns=false)
jab = PortAudioStream(jabra_dev; adjust_channels=true, warn_xruns=false)

buf = read(yeti, 1s)
wavplay(buf.data, buf.samplerate)

mics = [yeti, mac, jab]
dur = 1s

@sync begin
    global x, y, z
x = @async read(yeti, dur)
y = @async read(mac, dur)
z = @async read(jab, dur)
end

dof(n) = binomial(n, 2) - n + 1
a = x.result
b = y.result
c = z.result
cal_a  = a
cal_b  = b
cal_c  = c
# write(mac, buf)
#st = 0001
#k = 50000
plot(a[1:3:end, 1])
plot!(a[1:3:end, 2])
plot!(b[1:3:end, 1])
plot!(c[1:3:end, 1])

#apks = ampd(Matrix(a)[:, 1])

b1 = Matrix(b)[:, 1]
a1, sa1 = alignsignals(Matrix(a)[:, 1], b1)
c1, sc1 = alignsignals(Matrix(c)[:, 1], b1[1:3:end])
plot(c1)
plot!(a1[1:3:end])
plot!(b1[1:3:end])
(sa1, sc1)

Spectrogra
# julia> sa1
# -7422

# julia> sc1
# 309

julia> sa1
-7254

julia> sc1
326

# back
(-7342, 332)
(-7525, 463)
(-7147, 399)

vp(b, bidx) = (plot(b[:, 1]); display(vline!([bidx])))
vp(c, cidx)
read(yeti, dur)

close(yeti)
close(mac)
close(jab)