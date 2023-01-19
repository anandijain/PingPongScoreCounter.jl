import sounddevice as sd
import matplotlib.pyplot as plt
import numpy as np

# Set up the plot
plt.ion() # Turn on interactive mode
fig, ax = plt.subplots()

# Set up the audio stream
samplerate = 44100 # Hz
duration = 1 # seconds

# This function will be called by sounddevice whenever there is a new audio buffer available
def callback(indata, frames, time, status):
    if status:
        print(status)
    # Convert the audio data to a numpy array
    audio_data = np.frombuffer(indata, dtype='int16')
    # Compute the spectrogram
    _, _, spectrogram = plt.specgram(audio_data, Fs=samplerate)
    # Update the plot
    ax.clear()
    ax.imshow(spectrogram)
    fig.canvas.draw()

# Start the audio stream
stream = sd.InputStream(samplerate=samplerate, device=None, channels=1, callback=callback)
with stream:
    sd.sleep(int(duration * 1000))

