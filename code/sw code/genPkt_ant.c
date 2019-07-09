/*
 * @Author: Jiang.Y
 * @Email: lang_jy@outlook.com
 * @Date: 2019-07-02 16:06:11
 * @LastEditors: Jiang.Y
 * @LastEditTime: 2019-07-08 19:35:51
 * @Description:
   1.The sw of FAST-ANT 2.0.
   2.Generate Pkt.
   3.Write or Read Registers.
 */

#include <stdio.h>
#include <stdlib.h>
#include <libnet.h>
#include <string.h>
#include <unstid.h>


void regWR(int regNum, char *regVal)
{
    libnet_t *lib_net = NULL;
    libnet_ptag_t lib_t = 0;
    int lens = 0;
    unsigned char src_mac[6] = {0x00, 0x23, 0xcd, 0x76, 0x63, 0x1a};
    unsigned char dst_mac[6] = {0x00, 0x21, 0x85, 0xc5, 0x2b, 0x8f};
    char *src_ip_str = "192.168.1.110";
    char *dist_ip_str = "192.168.1.18";
    unsigned char send_msg[1000] = "";
    char err_buf[100] = "";
    unsigned long src_ip = 0, dst_ip = 0;
    int res = 0;

    lib_net = libnet_init(LIBNET_LINK_ADV, NULL, err_buf);

    if (lib_net == NULL) {
        perror("libnet_init");
        exit(-1);
    }

    src_ip = libnet_name2addr4(lib_net, src_ip_str, LIBNET_RESOLVE);
    dst_ip = libnet_name2addr4(lib_net, dst_ip_str, LIBNET_RESLOVE);

    send_msg[0] = 0x08;
    send_msg[1] = 0x00;
    send_msg[2] = 0x51;
    send_msg[3] = 0x57;
    send_msg[4] = 0x00;
    send_msg[5] = 0x1e;
    send_msg[6] = 0x08;
    send_msg[7] = 0xd7;
    send_msg[8] = 0x61;
    send_msg[9] = 0x62;
    send_msg[10] = 0x63;
    send_msg[11] = 0x64;
    send_msg[12] = 0x65;
    send_msg[13] = 0x66;
    //wr_reg_n
    switch (regNum) {
        case 1:
            send_msg[14] = 0x01;
            break;
        case 2:
            send_msg[14] = 0x02;
            break;
        case 3:
            send_msg[14] = 0x03;
            break;
        case 4:
            send_msg[14] = 0x04;
            break;
        case 5:
            send_msg[14] = 0x05;
            break;
        case 6:
            send_msg[14] = 0x06;
            break;
        case 7:
            send_msg[14] = 0x07;
            break;
        case 8:
            send_msg[14] = 0x08;
            break;
        case 9:
            send_msg[14] = 0x09;
            break;
        case 10:
            send_msg[14] = 0x0a;
            break;
        case 11:
            send_msg[14] = 0x0b;
            break;
        case 12:
            send_msg[14] = 0x0c;
            break;
        default:
            send_msg[14] = 0x00;
            break;
    }
    //wr_reg_n_value
    send_msg[15] = regVal[0];
    send_msg[16] = regVal[1];
    send_msg[17] = regVal[2];
    send_msg[18] = regVal[3];
    send_msg[19] = regVal[4];
    send_msg[20] = regVal[5];
    send_msg[21] = regVal[6];
    send_msg[22] = regVal[7];

    send_msg[23] = 0xff;
    send_msg[24] = 0xff;
    send_msg[25] = 0xff;
    send_msg[26] = 0xff;
    send_msg[27] = 0xff;
    send_msg[28] = 0xff;
    send_msg[29] = 0xff;

    lens = 30;

    lib_t = libnet_build_ipv4(20 + 8 + lens,
                              0,
                              500,
                              0,
                              10,
                              0xc8, //write the register
                              0,
                              src_ip,
                              dst_ip,
                              send_msg,
                              lens,
                              lib_net,
                              0
                              );

    lib_t = libnet_build_ethernet((u_int8_t *)dst_mac,
                                  (u_int8_t *)src_mac,
                                  0x800,
                                  NULL,
                                  0,
                                  lib_net,
                                  0);

    res = libnet_write(lib_net);
    if (res == -1) {
        perror("libnet_write");
        exit(-1);
    }

    libnet_destory(lib_net);

}

void regRD(int regNum)
{
    libnet_t *lib_net = NULL;
    libnet_ptag_t lib_t = 0;
    int lens = 0;
    unsigned char src_mac[6] = {0x00, 0x23, 0xcd, 0x76, 0x63, 0x1a};
    unsigned char dst_mac[6] = {0x00, 0x21, 0x85, 0xc5, 0x2b, 0x8f};
    char *src_ip_str = "192.168.1.110";
    char *dist_ip_str = "192.168.1.18";
    unsigned char send_msg[1000] = "";
    char err_buf[100] = "";
    unsigned long src_ip = 0, dst_ip = 0;
    int res = 0;


    lib_net = libnet_init(LIBNET_LINK_ADV, NULL, err_buf);

    if (lib_net == NULL) {
        perror("libnet_init");
        exit(-1);
    }

    src_ip = libnet_name2addr4(lib_net, src_ip_str, LIBNET_RESOLVE);
    dst_ip = libnet_name2addr4(lib_net, dst_ip_str, LIBNET_RESLOVE);

    send_msg[0] = 0x08;
    send_msg[1] = 0x00;
    send_msg[2] = 0x51;
    send_msg[3] = 0x57;
    send_msg[4] = 0x00;
    send_msg[5] = 0x1e;
    send_msg[6] = 0x08;
    send_msg[7] = 0xd7;
    send_msg[8] = 0x61;
    send_msg[9] = 0x62;
    send_msg[10] = 0x63;
    send_msg[11] = 0x64;
    send_msg[12] = 0x65;
    send_msg[13] = 0x66;
    //rd_reg_n
    switch (regNum) {
        case 1:
            send_msg[14] = 0x01;
            break;
        case 2:
            send_msg[14] = 0x02;
            break;
        case 3:
            send_msg[14] = 0x03;
            break;
        case 4:
            send_msg[14] = 0x04;
            break;
        case 5:
            send_msg[14] = 0x05;
            break;
        case 6:
            send_msg[14] = 0x06;
            break;
        case 7:
            send_msg[14] = 0x07;
            break;
        case 8:
            send_msg[14] = 0x08;
            break;
        case 9:
            send_msg[14] = 0x09;
            break;
        case 10:
            send_msg[14] = 0x0a;
            break;
        case 11:
            send_msg[14] = 0x0b;
            break;
        case 12:
            send_msg[14] = 0x0c;
            break;
        case 13:
            send_msg[14] = 0x0d;
            break;
        case 14:
            send_msg[14] = 0x0e;
            break;
        case 15:
            send_msg[14] = 0x0f;
            break;
        default:
            send_msg[14] = 0x00;
            break;
    }
    send_msg[15] = 0xff;
    send_msg[16] = 0xff;
    send_msg[17] = 0xff;
    send_msg[18] = 0xff;
    send_msg[19] = 0xff;
    send_msg[20] = 0xff;
    send_msg[21] = 0xff;
    send_msg[22] = 0xff;
    send_msg[23] = 0xff;
    send_msg[24] = 0xff;
    send_msg[25] = 0xff;
    send_msg[26] = 0xff;
    send_msg[27] = 0xff;
    send_msg[28] = 0xff;
    send_msg[29] = 0xff;

    lens = 30;

    lib_t = libnet_build_ipv4(20 + 8 + lens,
                              0,
                              500,
                              0,
                              10,
                              0xc9, //read the register
                              0,
                              src_ip,
                              dst_ip,
                              send_msg,
                              lens,
                              lib_net,
                              0
                              );

    lib_t = libnet_build_ethernet((u_int8_t *)dst_mac,
                                  (u_int8_t *)src_mac,
                                  0x800,
                                  NULL,
                                  0,
                                  lib_net,
                                  0);

    res = libnet_write(lib_net);
    if (res == -1) {
        perror("libnet_write");
        exit(-1);
    }

    libnet_destory(lib_net);

}

void genFlow(int flowIndex) {
    libnet_t *lib_net = NULL;
    libnet_ptag_t lib_t = 0;
    unsigned char src_mac[6];
    unsigned char dst_mac[6];
    unsigned char send_msg[1000] = "";
    char err_buf[100] = "";
    int i = 0, res = 0, lens = 0;
    unsigned short eth_type = 0;
    char fileName[] = "";
    char fileNum[] = "";
    FILE *fp;


    printf("\n");
    printf("Please input the size of pkt:\n");
    scanf("%d", &lens);
    printf("Please input source mac address:\n");
    for (i = 0; i < 6; i++) {
        scanf("%x", &src_mac[i]);
    }
    printf("Please input destination mac address:\n");
    for (i = 0; i < 6; i++) {
        scanf("%x", &dst_mac[i]);
    }
    printf("Please input ethernet type:\n");
    scanf("%x", &eth_type);
    printf("\n");

    strcpy(fileName, "pkt_content_");
    sprintf(fileNum, "%d", flowIndex);
    strcat(fileName, fileNum);

    fp = fopen(fileName, "r");
    if (!fp) {
        printf("Open file error!\n");
        return -1;
    }
    
    while (!feof(fp)) {
        fscanf(fp, "%x", &send_msg[i++]);
    }

    fclose(fp);

    lib_net = libnet_init(LIBNET_LINK_ADV, NULL, err_buf);

    if (lib_net == NULL) {
        perror("libnet_init");
        exit(-1);
    }

    lib_t = libnet_build_ethernet((u_int8_t *)dst_mac,
                                  (u_int8_t *)src_mac,
                                  eth_type,
                                  NULL,
                                  send_msg,
                                  lens - 14,
                                  lib_net,
                                  0);

    res = libnet_write(lib_net);
    if (res == -1) {
        perror("libnet_write");
        exit(-1);
    }

    libnet_destory(lib_net);
}

void readReplayPkt(int pktNum)
{
    libnet_t *lib_net = NULL;
    libnet_ptag_t lib_t = 0;
    int lens = 0;
    unsigned char src_mac[6] = {0x00, 0x23, 0xcd, 0x76, 0x63, 0x1a};
    unsigned char dst_mac[6] = {0x00, 0x21, 0x85, 0xc5, 0x2b, 0x8f};
    char *src_ip_str = "192.168.1.110";
    char *dist_ip_str = "192.168.1.18";
    unsigned char send_msg[1000] = "";
    char err_buf[100] = "";
    unsigned long src_ip = 0, dst_ip = 0;
    int res = 0;


    lib_net = libnet_init(LIBNET_LINK_ADV, NULL, err_buf);

    if (lib_net == NULL) {
        perror("libnet_init");
        exit(-1);
    }

    src_ip = libnet_name2addr4(lib_net, src_ip_str, LIBNET_RESOLVE);
    dst_ip = libnet_name2addr4(lib_net, dst_ip_str, LIBNET_RESOLVE);

    send_msg[0] = 0x08;
    send_msg[1] = 0x00;
    send_msg[2] = 0x51;
    send_msg[3] = 0x57;
    send_msg[4] = 0x00;
    send_msg[5] = 0x1e;
    send_msg[6] = 0x08;
    send_msg[7] = 0xd7;
    send_msg[8] = 0x61;
    send_msg[9] = 0x62;
    send_msg[10] = 0x63;
    send_msg[11] = 0x64;
    send_msg[12] = 0x65;
    send_msg[13] = 0x66;
    //wr_reg_n
    send_msg[14] = 0x02;
    //wr_reg_n_value
    send_msg[15] = 0x00;
    send_msg[16] = 0x00;
    send_msg[17] = 0x00;
    send_msg[18] = 0x00;
    send_msg[19] = 0x00;
    send_msg[20] = 0x00;
    switch (pktNum) {
        case 1:
            send_msg[21] = 0x08;
            send_msg[22] = 0x00;
            break;
        case 2:
            send_msg[21] = 0x08;
            send_msg[22] = 0x80;
            break;
        case 3:
            send_msg[21] = 0x09;
            send_msg[22] = 0x00;
            break;
        case 4:
            send_msg[21] = 0x09;
            send_msg[22] = 0x80;
            break;
        case 5:
            send_msg[21] = 0xa0;
            send_msg[22] = 0x00;
            break;
        case 6:
            send_msg[21] = 0xa0;
            send_msg[22] = 0x80;
            break;
        case 7:
            send_msg[21] = 0xb0;
            send_msg[22] = 0x00;
            break;
        case 8:
            send_msg[21] = 0xb0;
            send_msg[22] = 0x80;
            break;
        case 9:
            send_msg[21] = 0xc0;
            send_msg[22] = 0x00;
            break;
        case 10:
            send_msg[21] = 0xc0;
            send_msg[22] = 0x80;
            break;
        case 11:
            send_msg[21] = 0xd0;
            send_msg[22] = 0x00;
            break;
        case 12:
            send_msg[21] = 0xd0;
            send_msg[22] = 0x80;
            break;
        case 13:
            send_msg[21] = 0xe0;
            send_msg[22] = 0x00;
            break;
        case 14:
            send_msg[21] = 0xe0;
            send_msg[22] = 0x80;
            break;
        case 15:
            send_msg[21] = 0xf;
            send_msg[22] = 0x00;
            break;
        case 16:
            send_msg[21] = 0xf0;
            send_msg[22] = 0x80;
            break;
        default:
            send_msg[21] = 0x00;
            send_msg[22] = 0x00;
            break;
    }
    send_msg[23] = 0xff;
    send_msg[24] = 0xff;
    send_msg[25] = 0xff;
    send_msg[26] = 0xff;
    send_msg[27] = 0xff;
    send_msg[28] = 0xff;
    send_msg[29] = 0xff;

    lens = 30;

    lib_t = libnet_build_ipv4(14 + 20 + lens,
                              0,
                              500,
                              0,
                              10,
                              0xc8, //write the register of addr and rd signal
                              0,
                              src_ip,
                              dst_ip,
                              send_msg,
                              lens,
                              lib_net,
                              0
                              );

    lib_t = libnet_build_ethernet((u_int8_t *)dst_mac,
                                  (u_int8_t *)src_mac,
                                  0x0800,
                                  NULL,
                                  0,
                                  lib_net,
                                  0);

    res = libnet_write(lib_net);
    if (res == -1) {
        perror("libnet_write");
        exit(-1);
    }

    libnet_destory(lib_net);
}


int main()
{
    //command number
    int commandNum = 0, trCommandNum = 0, opRegCommandNum = 0;
    //var for Generate Multi-Flow
    int genModel = 0, flowNum = 0;
    int flowIndex = 0;
    //var for Traffic Replay
    int pktNum = 0;
    //var for register operation
    int wrRegNum = 0;
    unsigned char wrRegVal[8];
    int wrRegNumIndex = 0;
    int rdRegNum = 0;


    printf("*********************************************************************************************************************\n");
    printf("*                                                                                                                   *\n");
    printf("*                                       Welcome to use FAST-ANT 2.0.                                                *\n");
    printf("*   FAST-ANT 2.0 is an Angile Network Tester which is developed on FAST, a Software-Hardware Co-design framework.   *\n");
    printf("*                                                                                                                   *\n");
    printf("*********************************************************************************************************************\n");
    printf("\n");

    while (1) {
        printf("\n");
        printf("Please choose your operation number:\n");
        printf("1 Generate Multi-Flow\n");
        printf("2 Traffic Replay.\n");
        printf("3 Exit.\n");
        printf("4 Operate Registers.\n")
        printf("\n");

        scanf("%d", &commandNum);

        if (commandNum == 3) { //exit the program
            printf("\n");
            printf("Thanks for using FAST-ANT 2.0!\n");
            printf("If you have any good suggestion or need any support, please connect us by emailing to lang_jy@outlook.com.\n");
            printf("Have a good day! ^_^ \n");
            printf("\n");

            break;
        }
        else if (commandNum == 1) { //Generate Multi-Flow
            printf("\n");

            printf("Please choose the model of packet generating:\n");
            printf("1 Specified Time\n");
            printf("2 Specified Quantity\n");
            scanf("%d", &genModel);

            if (genModel == 1) {
                printf("\n");

                printf("Please input the Time:\n");
                for (wrRegNumIndex = 0; wrRegNumIndex < 8; wrRegNumIndex++) {
                    scanf("%x", &wrRegVal[wrRegNumIndex]);
                }

                regWR(10, wrRegVal);

                printf("\n");
            }
            else if (genModel == 2) {
                printf("\n");

                printf("Please input the Quantity:\n");
                for (wrRegNumIndex = 0; wrRegNumIndex < 8; wrRegNumIndex++) {
                    scanf("%x", &wrRegVal[wrRegNumIndex]);
                }
                regWR(11, wrRegVal);

                printf("\n");
            }
            else {
                printf("\n");
                printf("Invalid Model!\n");
                printf("\n");
            }

            printf("Please input the number of flow(1 ~ 4):\n");
            scanf("%d", &flowNum);

            if (flowNum >= 0 && flowNum <= 4) {
                for (flowIndex = 0; flowIndex < flowNum; flowIndex++) {
                    printf("Please input the speed of generating flow:\n");
                    for (wrRegNumIndex = 0; wrRegNumIndex < 8; wrRegNumIndex++) {
                        scanf("%x", &wrRegVal[wrRegNumIndex]);
                    }
                    regWR(7, wrRegVal);
                    printf("Please input the speed of generating flow:\n");
                    for (wrRegNumIndex = 0; wrRegNumIndex < 8; wrRegNumIndex++) {
                        scanf("%x", &wrRegVal[wrRegNumIndex]);
                    }
                    regWR(6, wrRegVal);
                    genFlow(flowIndex);
                }
            }
            else {
                printf("\n");
                printf("Invalid Flow Number!\n");
                printf("Exit the Function of Generate Multi-Flow\n");
                printf("\n");
            }

        }
        else if (commandNum == 2) { //Traffic Replay
            while (1) {
                printf("\n");
                printf("Please choose your operation number:\n");
                printf("1 Read Packets.\n");
                printf("2 Read Toal Bits of Flow and Number of Packets.\n");
                printf("3 Back to Previous Level.\n");
                printf("\n");

                scanf("%d", &trCommandNum);

                if (trCommandNum == 1) {
                    wrRegVal[0] = 0x00;
                    wrRegVal[1] = 0x00;
                    wrRegVal[2] = 0x00;
                    wrRegVal[3] = 0x00;
                    wrRegVal[4] = 0x00;
                    wrRegVal[5] = 0x00;
                    wrRegVal[6] = 0x00;
                    wrRegVal[7] = 0x01;
                    regWR(12, wrRegVal);

                    printf("\n");
                    printf("Please input the number of the packet which you want to read.\n");
                    scanf("%d", &pktNum);
                    readReplayPkt(pktNum);

                    printf("\n");
                }
                else if (trCommandNum == 2) {
                    wrRegVal[0] = 0x00;
                    wrRegVal[1] = 0x00;
                    wrRegVal[2] = 0x00;
                    wrRegVal[3] = 0x00;
                    wrRegVal[4] = 0x00;
                    wrRegVal[5] = 0x00;
                    wrRegVal[6] = 0x00;
                    wrRegVal[7] = 0x00;
                    regWR(12, wrRegVal);

                    printf("\n");
                    regRD(1);
                    regRD(2);
                    printf("\n");
                }
                else if (trCommandNum == 3) {
                    break;
                }
                else {
                    printf("\n");
                    printf("Wrong operation for HW.\n");
                    printf("Please input right operation number.\n");
                    printf("\n");
                }
            }
        }
        else if (commandNum == 4) {
            printf("\n");
            printf("Please choose register operation:\n");
            printf("1 Write Registers.\n");
            printf("2 Read Registers.\n");
            printf("\n");

            scanf("%d", &opRegCommandNum);

            if (opRegCommandNum == 1) {  //wr
                printf("\n");
                printf("Please input the register number:\n");
                scanf("%d", &wrRegNum);
                printf("Please input the register value:\n");
                for (wrRegNumIndex = 0; wrRegNumIndex < 8; wrRegNumIndex++) {
                    scanf("%x", &wrRegVal[wrRegNumIndex]);
                }
                printf("\n");

                regWR(wrRegNum, wrRegVal);


            }
            else if (opRegCommandNum) {  //rd
                wrRegVal[0] = 0x00;
                wrRegVal[1] = 0x00;
                wrRegVal[2] = 0x00;
                wrRegVal[3] = 0x00;
                wrRegVal[4] = 0x00;
                wrRegVal[5] = 0x00;
                wrRegVal[6] = 0x00;
                wrRegVal[7] = 0x00;
                regWR(12, wrRegVal);

                printf("\n");
                printf("Please input the register number:\n");
                scanf("%d", &rdRegNum);
                printf("\n");

                regRD(rdRegNum);
            }
            else {
                printf("\n");
                printf("Wrong operation for registers!\n");
                printf("Please input right operation number.\n");
                printf("\n");
            }
        }
        else {
            printf("\n");
            printf("Wrong operation number!\n");
            printf("Please input right operation number.\n");
            printf("\n");
        }
    }
    return 0;
}