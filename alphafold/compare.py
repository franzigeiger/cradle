import os
import pickle
import numpy as np
import matplotlib.pyplot as plt
import alphafold.alphafold_pytorch.utils as utils

def restructure(matrix):
    for i in range(matrix.shape[0]):
        matrix[i] = np.roll(matrix[i], -i)
    return matrix


def plot_restructured(distogram_a, distogram_b):
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(22, 8))
    im = ax1.imshow(distogram_a, cmap=plt.cm.Blues_r, vmin=0, vmax=63)
    im = ax2.imshow(distogram_b, cmap=plt.cm.Blues_r, vmin=0, vmax=63)
    plt.show()


def compare(file1, file2):
    distance_a = pickle.load(file1)
    distance_b = pickle.load(file2)
    # utils.plot_contact_map(f'{file1} and {file2} restructured', [distance_a, distance_b], f'output/a_b.png')
    size = distance_a.shape[0]
    correlations = np.zeros([size, size, size])
    base_a = restructure(distance_a.argmax(-1))
    base_b = restructure(distance_b.argmax(-1))
    plot_restructured(base_a, base_b)
    fig, axs = plt.subplots(40, 3, figsize=(3, 40))
    for i in range(size):
        for j in range(size):
            correlations[i, j] = np.correlate(base_a[i], base_b[j], "same")
            if j < 3 and i < 40:
                axs[i, j].plot(range(size), correlations[i, j])
                axs[i, j].axes.xaxis.set_visible(False)
                axs[i, j].axes.yaxis.set_visible(False)
    plt.show()
    print(f'{base_a[0]}, with {base_b[0]} corr {correlations[0,0]}')
    print(f'{base_a[25]}, with {base_b[25]} corr {correlations[25,25]}')




if __name__ == '__main__':
    list = os.listdir('distograms')
    compare(open(f'distograms/{list[0]}', 'rb'), open(f'distograms/{list[1]}', 'rb'))
