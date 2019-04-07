#pragma once

#include <string>

class RAM{
public:
    uint8_t* mem[1 << 12];

    RAM(){
        for(uint32_t i = 0;i < (1 << 12);i++) mem[i] = NULL;
    }
    ~RAM(){
        for(uint32_t i = 0;i < (1 << 12);i++) if(mem[i]) delete [] mem[i];
    }

    void clear(){
        for(uint32_t i = 0;i < (1 << 12);i++)
        {
            if(mem[i])
            { 
                delete mem[i];
                mem[i] = NULL;
            }
        }
    }

    uint8_t* get(uint32_t address){

        if(mem[address >> 20] == NULL) {
            uint8_t* ptr = new uint8_t[1024*1024];
            for(uint32_t i = 0;i < 1024*1024;i+=4) {
                ptr[i + 0] = 0xFF;
                ptr[i + 1] = 0xFF;
                ptr[i + 2] = 0xFF;
                ptr[i + 3] = 0xFF;
            }
            mem[address >> 20] = ptr;
        }
        return &mem[address >> 20][address & 0xFFFFF];
    }

    void read(uint32_t address,uint32_t length, uint8_t *data){
        for(unsigned i = 0;i < length;i++){
            data[i] = (*this)[address + i];
        }
    }

    void write(uint32_t address,uint32_t length, uint8_t *data){
        for(unsigned i = 0;i < length;i++){
            (*this)[address + i] = data[i];
        }
    }

    void getBlock(uint32_t address, uint8_t *data)
    {
        uint32_t block_number = address & 0xffffff00; // To zero out block offset
        uint32_t bytes_num    = 256;

        this->read(block_number, bytes_num, data);
    }

    void getWord(uint32_t address, uint32_t * data)
    {
        data[0] = 0;

        uint8_t first  = *get(address + 0);
        uint8_t second = *get(address + 1);
        uint8_t third  = *get(address + 2);
        uint8_t fourth = *get(address + 3);

        // uint8_t hi = (uint8_t) *get(address + 0);
        // std::cout << "RAM: READING ADDRESS " << address + 0 << " DATA: " << hi << "\n";
        // hi = (uint8_t) *get(address + 1);
        // std::cout << "RAM: READING ADDRESS " << address + 1 << " DATA: " << hi << "\n";
        // hi = (uint8_t) *get(address + 2);
        // std::cout << "RAM: READING ADDRESS " << address + 2 << " DATA: " << hi << "\n";
        // hi = (uint8_t) *get(address + 3);
        // std::cout << "RAM: READING ADDRESS " << address + 3 << " DATA: " << hi << "\n";

        data[0] = (data[0] << 0) | fourth;
        data[0] = (data[0] << 8) | third;
        data[0] = (data[0] << 8) | second;
        data[0] = (data[0] << 8) | first;

    }

    void writeWord(uint32_t address, uint32_t * data)
    {
        uint32_t data_to_write = *data;

        uint32_t byte_mask = 0xFF;

        for (int i = 0; i < 4; i++)
        {
            // std::cout << "RAM: DATA TO WRITE " << data_to_write << "\n";
            // std::cout << "RAM: DATA TO MASK  " << byte_mask << "\n";
            // std::cout << "RAM: WRITING ADDRESS " << address + i << " DATA: " << (data_to_write & byte_mask) << "\n";
            (*this)[address + i] = data_to_write & byte_mask;
            data_to_write        = data_to_write >> 8;
        }
    }

    void writeHalf(uint32_t address, uint32_t * data)
    {
        uint32_t data_to_write = *data;

        uint32_t byte_mask = 0xFF;

        for (int i = 0; i < 2; i++)
        {
            // std::cout << "RAM: DATA TO WRITE " << data_to_write << "\n";
            // std::cout << "RAM: DATA TO MASK  " << byte_mask << "\n";
            // std::cout << "RAM: WRITING ADDRESS " << address + i << " DATA: " << (data_to_write & byte_mask) << "\n";
            (*this)[address + i] = data_to_write & byte_mask;
            data_to_write        = data_to_write >> 8;
        }
    }

    void writeByte(uint32_t address, uint32_t * data)
    {
        uint32_t data_to_write = *data;

        uint32_t byte_mask = 0xFF;

        (*this)[address] = data_to_write & byte_mask;
        data_to_write    = data_to_write >> 8;

    }

    uint8_t& operator [](uint32_t address) {
        return *get(address);
    }

};
