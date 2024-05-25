#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

// WAV header structure
typedef struct {
    char chunkID[4];        // "RIFF"
    uint32_t chunkSize;
    char format[4];         // "WAVE"
} RIFFHeader;

typedef struct {
    char subchunk1ID[4];    // "fmt "
    uint32_t subchunk1Size;
    uint16_t audioFormat;
    uint16_t numChannels;
    uint32_t sampleRate;
    uint32_t byteRate;
    uint16_t blockAlign;
    uint16_t bitsPerSample;
} FMTSubchunk;

typedef struct {
    char subchunk2ID[4];    // "data"
    uint32_t subchunk2Size;
} DATASubchunk;

void readWAVFile(const char *filename) {
    FILE *file = fopen(filename, "rb");
    if (!file) {
        perror("Unable to open file");
        exit(EXIT_FAILURE);
    }

    // Read the RIFF header
    RIFFHeader riffHeader;
    fread(&riffHeader, sizeof(RIFFHeader), 1, file);
    if (strncmp(riffHeader.chunkID, "RIFF", 4) != 0 || strncmp(riffHeader.format, "WAVE", 4) != 0) {
        fprintf(stderr, "Invalid WAV file\n");
        fclose(file);
        exit(EXIT_FAILURE);
    }

    // Read the FMT subchunk
    FMTSubchunk fmtSubchunk;
    fread(&fmtSubchunk, sizeof(FMTSubchunk), 1, file);
    if (strncmp(fmtSubchunk.subchunk1ID, "fmt ", 4) != 0) {
        fprintf(stderr, "Invalid FMT subchunk\n");
        fclose(file);
        exit(EXIT_FAILURE);
    }

    // Print format information
    printf("Audio Format: %d\n", fmtSubchunk.audioFormat);
    printf("Number of Channels: %d\n", fmtSubchunk.numChannels);
    printf("Sample Rate: %d\n", fmtSubchunk.sampleRate);
    printf("Byte Rate: %d\n", fmtSubchunk.byteRate);
    printf("Block Align: %d\n", fmtSubchunk.blockAlign);
    printf("Bits Per Sample: %d\n", fmtSubchunk.bitsPerSample);

    // Read the DATA subchunk header
    DATASubchunk dataSubchunk;
    fread(&dataSubchunk, sizeof(DATASubchunk), 1, file);
    if (strncmp(dataSubchunk.subchunk2ID, "data", 4) != 0) {
        fprintf(stderr, "Invalid DATA subchunk\n");
        fclose(file);
        exit(EXIT_FAILURE);
    }

    // Allocate memory and read the audio data
    uint8_t *data = (uint8_t *)malloc(dataSubchunk.subchunk2Size);
    fread(data, dataSubchunk.subchunk2Size, 1, file);

    // Do something with the audio data
    // (for now, just print the size of the data)
    printf("Data Size: %d bytes\n", dataSubchunk.subchunk2Size);

    // Clean up
    free(data);
    fclose(file);
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <wav file>\n", argv[0]);
        return EXIT_FAILURE;
    }

    readWAVFile(argv[1]);

    return EXIT_SUCCESS;
}