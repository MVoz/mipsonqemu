#include <stdio.h>
unsigned short data[] = {
  0x1, 0x2, 
  0x3, 0x4,
  0x55aa, 0x66bb,
  0x77cc, 0x0000,
};

void unaligned_access(unsigned short * const row)
{
  asm volatile
    (
        ".set mips3\n\t"
        ".set noreorder\n\t"

        //"lwr $10, 1(%1)\n\t"
        //"lwl $11, 4(%1)\n\t"
        //"or $10, $11\n\t"
        "lw $10, 2(%1)\n\t"     /* %1 is double word aligned, %1+2 is double word unaligned */
        "sw $10, %0\n\t"

        ".set reorder\n\t"
        ".set mips0\n\t"
        : "=m"(*(row))
        : "r"(row+4)
        : "$8", "$9", "$10"
    );
}

int main()
{
  printf("---------------------------------------------------------\n");
  printf(" Testing mips unaligned access Instruction \n");
  printf("---------------------------------------------------------\n\n");

  printf("orignal:0x%04x 0x%04x 0x%04x 0x%04x\n",data[3],data[2],data[1],data[0]);
  unaligned_access(data);

  printf("result is: 0x%04x %04x %04x %04x\n", data[3], data[2], data[1], data[0]);

}

