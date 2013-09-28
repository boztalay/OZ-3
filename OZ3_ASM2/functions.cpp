/* This file holds all of the functions used in
   the main code of the assembler.
   
   Ben Oztalay, 2010
*/

#include <cstdlib>
#include <iostream>
#include <string>

using namespace std;

//This function returns true if the given character is a number
bool check_num(char input)
{
     if(input == '0' || input == '1' || input == '2' || input == '3' || input == '4' || input == '5'
        || input == '5' || input == '6' || input == '7' || input == '8' || input == '9')
        return true;
     else
        return false;
}

//This function takes a number in decimal and returns a binary string
//of specified length
string dec2binary(int number, int length)
{
     int next_bit;
     string result;
     
     while(number > 0)
     {
          next_bit = number % 2;
          number = number / 2;
          
          if (next_bit == 0)
             result.insert(0, "0");
          if (next_bit == 1)
             result.insert(0, "1");
     }
     
     while(result.length() < length)
     {
          result.insert(0, "0");
     }
     
     return result;
}
     

//This function holds all of the different errors than can occur,
//and writes them to the screen when called.
void errors(int error_code, int line_number)
{
     cout << "Line " << line_number << ": Error " << error_code << ": ";
     
     switch(error_code)
     {
          case 0:
               cout << "Mnemonic doesn't exist.\n\n";
               break;
          case 1:
               cout << "Formatting error. Check for missing commas, spaces, and operands.\n\n";
               break;
          case 2:
               cout << "Identical labels, rename one.\n\n";
               break;
          case 3:
               cout << "Missing 'r' in front of register number.\n\n";
               break;
          case 4:
               cout << "Number entered is not a number.\n\n";
               break;
          case 5:
               cout << "Given value is too large. Common limits: 31, 65535, 2097151.\n\n";
               break;
          default:
               break;
     }
}

//This function returns the opcode of a mnemonic, as well as its
//format and the number that should go in the auxiliary field, if
//applicable
string gen_opcode(string mnemonic)
{
     if (!mnemonic.compare("add"))
     {
           return "001111r0";
     }
     else if (!mnemonic.compare("sub"))
     {
           return "001111r1";
     }
     else if (!mnemonic.compare("AND"))
     {
           return "001111r2";
     }
     else if (!mnemonic.compare("OR"))
     {
           return "001111r3";
     }
     else if (!mnemonic.compare("XOR"))
     {
           return "001111r4";
     }
     else if (!mnemonic.compare("cp"))
     {
           return "001111c5";
     }
     else if (!mnemonic.compare("sl"))
     {
           return "001111r6";
     }
     else if (!mnemonic.compare("sr"))
     {
           return "001111r7";
     }
     else if (!mnemonic.compare("rl"))
     {
           return "001111r8";
     }
     else if (!mnemonic.compare("rr"))
     {
           return "001111r9";
     }
     else if (!mnemonic.compare("addi"))
     {
           return "001000i0";
     }
     else if (!mnemonic.compare("subi"))
     {
           return "001001i0";
     }
     else if (!mnemonic.compare("ANDi"))
     {
           return "001010i0";
     }
     else if (!mnemonic.compare("ORi"))
     {
           return "001011i0";
     }
     else if (!mnemonic.compare("XORi"))
     {
           return "001100i0";
     }
     else if (!mnemonic.compare("cpi"))
     {
           return "001101c0";
     }
     else if (!mnemonic.compare("ldl"))
     {
           return "011000i0";
     }
     else if (!mnemonic.compare("ldu"))
     {
           return "011001i0";
     }
     else if (!mnemonic.compare("strl"))
     {
           return "011010i0";
     }
     else if (!mnemonic.compare("stru"))
     {
           return "011011i0";
     }
     else if (!mnemonic.compare("iprt"))
     {
           return "010010o0";
     }
     else if (!mnemonic.compare("oprt"))
     {
           return "010011o0";
     }
     else if (!mnemonic.compare("opin0"))
     {
           return "010100p0";
     }
     else if (!mnemonic.compare("opin1"))
     {
           return "010101p0";
     }
     else if (!mnemonic.compare("ipchk"))
     {
           return "010110p0";
     }
     else if (!mnemonic.compare("brnc"))
     {
           return "100001d0";
     }
     else if (!mnemonic.compare("brng"))
     {
           return "100010d0";
     }
     else if (!mnemonic.compare("brne"))
     {
           return "100011d0";
     }
     else if (!mnemonic.compare("brnl"))
     {
           return "100100d0";
     }
     else if (!mnemonic.compare("brnp"))
     {
           return "100101d0";
     }
     else if (!mnemonic.compare("jp"))
     {
           return "100110d0";
     }
     else if (!mnemonic.compare("noop"))
     {
           return "000000n0";
     }
     else if (!mnemonic.compare("lbl"))
     {
           return "lbl";
     }
     else
     {
           return "error";
     }
}

char bin2hex(string input)
{
     if (!input.compare("0000"))
     {
          return '0';
     }
     if (!input.compare("0001"))
     {
          return '1';
     }
     if (!input.compare("0010"))
     {
          return '2';
     }
     if (!input.compare("0011"))
     {
          return '3';
     }
     if (!input.compare("0100"))
     {
          return '4';
     }
     if (!input.compare("0101"))
     {
          return '5';
     }
     if (!input.compare("0110"))
     {
          return '6';
     }
     if (!input.compare("0111"))
     {
          return '7';
     }
     if (!input.compare("1000"))
     {
          return '8';
     }
     if (!input.compare("1001"))
     {
          return '9';
     }
     if (!input.compare("1010"))
     {
          return 'A';
     }
     if (!input.compare("1011"))
     {
          return 'B';
     }
     if (!input.compare("1100"))
     {
          return 'C';
     }
     if (!input.compare("1101"))
     {
          return 'D';
     }
     if (!input.compare("1110"))
     {
          return 'E';
     }
     if (!input.compare("1111"))
     {
          return 'F';
     }
}
