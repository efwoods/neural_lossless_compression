# Neuralink Lossless Compression Challenge - NT@B 

NT@B repo of approaches to tackle Neuralink's Lossless Compression problem. The statement from their [challenge website](https://content.neuralink.com/compression-challenge/README.html):

>This Neuralink is implanted in the motor cortex of a non-human primate, and recordings were made while playing a video game, like [this](https://www.youtube.com/watch?v=rsCul1sp4hQ).
Compression is essential: N1 implant generates **~200Mbps** of eletrode data (1024 electrodes @ 20kHz, **10b resolution**) and can transmit ~1Mbps wirelessly.
So **> 200x compression** is needed.
Compression must run in **real time (< 1ms)** at **low power (< 10mW, including radio)**.
Neuralink is looking for new approaches to this compression problem, and exceptional engineers to work on it.
If you have a solution, email compression@neuralink.com


I've set up the repo to help people get started, essentially have made some edits to the `./eval.sh` code, created a helper for creating a script from python files, and a notebook to start exploring the dataset. 

## Repo Guideline

I want to encourage people to work on this project and collaborate together to explore different approaches to this problem. 

Keep different approaches in different remote branches (avoid pushing to the main branch). Generally, naming for branches should be descriptive of the approach you're using. 

Keep your code for a specific approach in a stand-alone folder (e.g. `./copy_coding/` contains the python scripts), and add a README in the folder explaining the approach and summary statistics for the evaluation method. A notebook analysing the method and its performance would also be helpful.


## Running Evaluation

Download the `data.zip` from the [challenge website](https://content.neuralink.com/compression-challenge/README.html), which should not be pushed to the Github to minize memory consumption across the repository. You do not need to unzip this file, the evaluation script will unzip this folder at the start of the script. 

Before running the evalutation script, change the `encoder_file_name` and `decoder_file_name` variables in `eval.sh` to point to your scripts. Then run `./eval.sh`. 



## `eval.sh` and Changes to Script

Evaluation of the encoding and decoding scripts that you write are carried out by the `eval.sh` script. The original script takes an `encode` and `decode` executable, unzip the `data.zip` folder, and apply the `encode` script to produce a `.brainwave` file of every recording, the use `decode` to produce a `.copy` file that is verified to match against the original `.wav` file. The total compressed size is calculated as a combination of the size of all the compressed files as well as the sizes of the encoder and decoder scripts. 

List of modifications made:
- Added the `gen_exe` script, which gets called to create the `encode` and `decode` executables. This makes it slightly easier for debugging purposes, and will make it easier when attempting different languages or setups (which we should do!). 
- The encoded size and decoded size of every file is saved in `compressed_results.csv` so that it's easier to analyse performance.

## Ideas for Starting Points

### Standard Compression Algorithms

General compression algorithms like zip (or really any Lempel-Ziv algorithm) would be my first go-to create a decent benchmark to compare future attempts against. Neuralink's leaderboard gave zip a 2.2 compression ration, and the zip file `data.zip` has a 6.84x compression ratio (not including the encoder and decoder file sizes). 

Another good place to take a look is lossless audio codecs. FLAC is the most famous one, and has a lot of support across devices. 

### Compression Across Channels

A fundemental flaw of zip is that it does not compress across files. [A quick search](https://superuser.com/questions/1013309/why-is-zip-able-to-compress-single-file-smaller-than-multiple-files-with-the-sam
) shows that zip treats every file in a to-be-compressed folder as separate, which means there is a lot of redundant bits of information across channels that the method is missing out on. Trying to compress across channels will likely lead to good results. This also means that the way the `eval.sh` script is setup is non-optimal, and that the compression size should be calculated by the resultant aggregated compressed file. 

### Other Languages

Currently, I have started thinking about this in Python, and that's fine for initial experiments, but I do this it will be worthwhile for both speed and memory to code up solutions in C. 



## Common Issues:
### Permissions

When running some of the bash scripts, you may run into an error similar to:
```
zsh: permission denied: `file_name`
```
For a simple fix, run:
```
chmod +x file_name
```
Note that you can added more file names in the above command to enable access permissions to a list of files. 




## Credits
Reuben Thomas, reubenkthomas@berkeley.edu