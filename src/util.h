int ctoh(char c)
{
    if (c == '0') return 0;
    if (c == '1') return 1;
    if (c == '2') return 2;
    if (c == '3') return 3;
    if (c == '4') return 4;
    if (c == '5') return 5;
    if (c == '6') return 6;
    if (c == '7') return 7;
    if (c == '8') return 8;
    if (c == '9') return 9;
    if (c == 'a') return 10;
    if (c == 'b') return 11;
    if (c == 'c') return 12;
    if (c == 'd') return 13;
    if (c == 'e') return 14;
    if (c == 'f') return 15;

    return -1;
}


void filterHex(void)
{



    std::ifstream ifs ("../Workspace/add.bin", std::ifstream::in);
    std::ofstream ofs ("../Workspace/add.hex", std::ofstream::out);
    std::string line;
    std::string curr_inst;
    while (ifs >> line)
    {
        int ii;
        for (ii = 0; ii < 16; ii++)
        {
            curr_inst = line.substr(ii*8,8);


            unsigned jj;

            unsigned inst = 0;
            for (jj = 0; jj < curr_inst.size(); jj++)
            {
                if (curr_inst[jj] != '0')
                {

                    inst += ctoh(curr_inst[jj]) * pow(16, (curr_inst.size() - 1) - jj);
                } else
                {
                }
            }

            if ((inst != 0) && ((inst % 4) == 3))
            {
                ofs << inst << std::endl;
            }
        }
    }

    ofs.close();
    ifs.close();

}