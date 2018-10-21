#include "string.h"

uint32_t hti(char c) {
    if (c >= 'A' && c <= 'F')
        return c - 'A' + 10;
    if (c >= 'a' && c <= 'f')
        return c - 'a' + 10;
    return c - '0';
}

uint32_t hToI(char *c, uint32_t size) {
    uint32_t value = 0;
    for (uint32_t i = 0; i < size; i++) {
        value += hti(c[i]) << ((size - i - 1) * 4);
    }
    return value;
}



void loadHexImpl(std::string path,RAM* mem) {
    FILE *fp = fopen(&path[0], "r");
    if(fp == 0){
        std::cout << path << " not found" << std::endl;
    }
    //Preload 0x0 <-> 0x80000000 jumps
    ((uint32_t*)mem->get(0))[0] = 0x800000b7;
    ((uint32_t*)mem->get(0))[1] = 0x000080e7;
    ((uint32_t*)mem->get(0x80000000))[0] = 0x00000097;

    fseek(fp, 0, SEEK_END);
    uint32_t size = ftell(fp);
    fseek(fp, 0, SEEK_SET);
    char* content = new char[size];
    fread(content, 1, size, fp);

    int offset = 0;
    char* line = content;
    while (1) {
        if (line[0] == ':') {
            uint32_t byteCount = hToI(line + 1, 2);
            uint32_t nextAddr = hToI(line + 3, 4) + offset;
            uint32_t key = hToI(line + 7, 2);
            switch (key) {
            case 0:
                for (uint32_t i = 0; i < byteCount; i++) {

                    unsigned add = nextAddr + i;

                    // if ((add % 4) == 0) add +=  3;
                    // if ((add % 4) == 1) add +=  1;
                    // if ((add % 4) == 2) add += -1;
                    // if ((add % 4) == 3) add += -3;

                    *(mem->get(add)) = hToI(line + 9 + i * 2, 2);
                    // std::cout << "Address: " << std::hex <<(add + i) << "\tValue: " << std::hex << hToI(line + 9 + i * 2, 2) << std::endl;
                }
                std::cout << "********" << std::endl;
                break;
            case 2:
//              cout << offset << endl;
                offset = hToI(line + 9, 4) << 4;
                break;
            case 4:
//              cout << offset << endl;
                offset = hToI(line + 9, 4) << 16;
                break;
            default:
//              cout << "??? " << key << endl;
                break;
            }
        }

        while (*line != '\n' && size != 0) {
            line++;
            size--;
        }
        if (size <= 1)
            break;
        line++;
        size--;
    }

    delete content;
}

