/* This is version 2.0 of the OZ-3 assembler, with
   many added features, including:
   
   Ben Oztalay, 2010
*/

#include <cstdlib>
#include <iostream>
#include <string>
#include <fstream>

using namespace std;

bool check_num(char input);
string dec2binary(int number, int length);
void errors(int error_code, int line_number);
string gen_opcode(string mnemonic);
char bin2hex(string input);

int main()
{
    //Constants
    const int max_labels = 1000;
    
    //Input and output fstreams
    ifstream fin("input.txt");
    ofstream fout("output.coe");
    ofstream foutd("dump.txt");
    
    //All of the strings to be used
    string line;
    string instruction;
    string mnemonic;
    char   format;
    string register1;
    string register2;
    string register3;
    string immediate;
    string displacement;
    string auxiliary;
    string binary1;
    string binary2;
    
    //Label variables
    string label_names[max_labels];
    int label_addr[max_labels];
    int label_count = 0;
    
    //Temporary variables
    string temp_str;
    char temp_char;
    
    //Misc
    int i = 0;
    int j = 0;
    int k = 0;
    int asm_line_count = 1;
    int bin_line_count = 1;
    streampos pos = fin.tellg();
    
    
    //This is for the first pass, when all of the labels are collected
    cout << "The OZ-3 Assembly Language Assembler\n";
    cout << "Ben Oztalay, 2010\n";
    cout << "------------------------------------\n\n";
    
    cout << "---------------------\n";
    cout << "Running first pass...\n";
    cout << "---------------------\n\n";
    
    foutd << "The OZ-3 Assembly Language Assembler\n";
    foutd << "Ben Oztalay, 2010\n";
    foutd << "------------------------------------\n\n";
    
    foutd << "---------------------\n";
    foutd << "Running first pass...\n";
    foutd << "---------------------\n\n";
    
    getline(fin, line);
    line += '\n';
    while(line[0] != '%')
    {
         //This loop advances the index to the first non-space character
         while((line[i] == ' ') || (line[i] == '\t'))
         {
              i++;
         }
                          
         //Make sure the line isn't a comment or over
         if((line[i] != '#') && (line[i] != '\n'))
         {                 
              //This loop gets the mnemonic, which should be the first set of characters in the line
              while((line[i] != ' ') && (line[i] != '\t') && (line[i] != '#') && (line[i] != '\n'))
              {
                   mnemonic += line[i];
                   i++;
              }
              
              //Check formatting errors; cut off mnemonics, mainly
              if(mnemonic.compare("noop") != 0)
              {
                   if((line[i] == '#') || (line[i] == '\n'))
                   {
                        errors(1, asm_line_count);
                        system("PAUSE");
                        return EXIT_SUCCESS;
                   }
              }
              
              //If the line is a label
              if (gen_opcode(mnemonic).compare("lbl") == 0)
              {         
                  //This loop advances the index to the next non-space character           
                  while((line[i] == ' ') || (line[i] == '\t'))
                  {
                       i++;
                  }
                  //Check formatting errors; the line shouldn't be cut off here
                  if((line[i] == '#') || (line[i] == '\n'))
                  {
                       errors(1, asm_line_count);
                       system("PAUSE");
                       return EXIT_SUCCESS;
                  }
                  //This loop gets the label, which ought to be here
                  while((line[i] != ' ') && (line[i] != '\t') && (line[i] != '#') && (line[i] != '\n'))
                  {
                       temp_str += line[i];
                       i++;
                  }
                  
                  //Check for identical labels
                  for(i = 0; i < max_labels; i++)
                  {
                        if (label_names[i].compare(temp_str) == 0)
                        {
                              errors(2, asm_line_count);
                              system("PAUSE");
                              return EXIT_SUCCESS;
                        }
                  }
                  
                  //We don't care what's after it, so...                  
                  //Store the label and its address, then display the information
                  label_names[label_count] = temp_str;
                  label_addr[label_count] = bin_line_count;
                  
                  cout << "Line " << asm_line_count << ", label: " << label_names[label_count] << "\n";                    
                  cout << "Label Address: " << label_addr[label_count] << "\n";
                  cout << "Label Number: " << label_count << "\n\n";
                  
                  foutd << "Line " << asm_line_count << ", label: " << label_names[label_count] << "\n";                    
                  foutd << "Label Address: " << label_addr[label_count] << "\n";
                  foutd << "Label Number: " << label_count << "\n\n";
                  
                  label_count++;
              }
              else if (gen_opcode(mnemonic).compare("error") == 0)
              {
                  errors(0, asm_line_count);
                  system("PAUSE");
                  return EXIT_SUCCESS;
              }
              else
              {
                  bin_line_count += 1;
              }
         }

         //Reset everything
         getline(fin, line);
         line += '\n';
       
         asm_line_count++;
         temp_str.clear();
         mnemonic.clear();
         temp_char = 'a';
          
         i = 0;        
    }   
    //End of first pass

    //This is the second pass, when all of the instructions are assembled 
    cout << "First pass complete without errors.\n";
    
    cout << "----------------------\n";
    cout << "Running second pass...\n";
    cout << "----------------------\n\n";
    
    foutd << "First pass complete without errors.\n";
    
    foutd << "----------------------\n";
    foutd << "Running second pass...\n";
    foutd << "----------------------\n\n";

	fout << "; This .COE file was generated by the OZ-3 assembler \n";
	fout << "; for use in a Xilinx block ROM with the OZ-3 \n\n";
	fout << "memory_initialization_radix = 16;\n";
	fout << "memory_initialization_vector = \n00000000";
    
    //Setup for the second pass
    fin.clear();
    fin.seekg(pos);
    fin.seekg(pos);
    asm_line_count = 1;
    bin_line_count = 1;
    i = 0;
    
    getline(fin, line);
    line += '\n';
    
//    //This gets the dummy 0th address
//    fout << "0000";
    
    while(line[0] != '%')
    {
         cout << "Line (" << asm_line_count << "): " << line;
         foutd << "Line (" << asm_line_count << "): " << line;
         
         //This loop advances the index to the first non-space character
         while((line[i] == ' ') || (line[i] == '\t'))
         {
              i++;
         }
         
         //Make sure the line isn't a comment or over
         if((line[i] != '#') && (line[i] != '\n'))
         {                
              //This loop gets the mnemonic, which should be the first set of characters in the line
              while((line[i] != ' ') && (line[i] != '\t') && (line[i] != '#') && (line[i] != '\n'))
              {
                   mnemonic += line[i];
                   i++;
              }
              
              //Check formatting errors; cut off mnemonics, mainly
              if(mnemonic.compare("noop") != 0)
              {
                   if((line[i] == '#') || (line[i] == '\n'))
                   {
                        errors(1, asm_line_count);
                        system("PAUSE");
                        return EXIT_SUCCESS;
                   }
              }
              
              //Get the opcode, format, and auxiliary field's value for the mnemonic
              temp_str = gen_opcode(mnemonic);
              
              cout << "Mnemonic: " << mnemonic << "\n";
              foutd << "Mnemonic: " << mnemonic << "\n";
              
              //Check to see if the mnemonic exists
              if(temp_str.compare("error") == 0)
              {
                   errors(0, asm_line_count);
                   system("PAUSE");
                   return EXIT_SUCCESS;
              }
              
              //Check to see if it's not a label
              if(mnemonic.compare("lbl") != 0)
              {
                   //Put the opcode on the binary1 string
                   binary1 += temp_str.substr(0, 6);                      
                   
                   //Get the auxiliary value
                   auxiliary = dec2binary(atoi(temp_str.substr(7, 7).c_str()), 11);
                   
                   //Get the format
                   format = temp_str[6];
                   cout << "Format: " << format << "\n";
                   
                   foutd << "Format: " << format << "\n";
                   
                   //The next part of the program checks which format the instruction
                   //should be in, based on the mnemonic, and checks the syntax and
                   //assembles the instruction.
                                      
                   //For the register addressing mode/format
                   if(format == 'r')
                   {
                        //Register 1
                             //This loop advances the index to the first non-space character
                             while((line[i] == ' ') || (line[i] == '\t'))
                             {
                                  i++;
                             }
                             
                             //Checking to see if there's an 'r' in front of the register number
                             if(line[i] != 'r')
                             {
                                   errors(3, asm_line_count);
                                   system("PAUSE");
                                   return EXIT_SUCCESS;
                             }
                             
                             //If there is an 'r' there, advance the iterator and get the register number
                             i++;
                                                     
                             while((line[i] != ' ') && (line[i] != '\t') && (line[i] != '#') && (line[i] != '\n') && (line[i] != ','))
                             {
                                  register1 += line[i];
                                  i++;
                             }
                             
                             //Check to make sure the line doesn't end there
                             if((line[i] == '#') || (line[i] == '\n'))
                             {
                                  errors(1, asm_line_count);
                                  system("PAUSE");
                                  return EXIT_SUCCESS;
                             }
                             
                             //Check to see if there's a comma; if so, advance the iterator past it
                             if(line[i] == ',')
                                   i++;
                             
                             //Check to see if the register number is actually a number
                             for(int j = 0; j < register1.length(); j++)
                             {
                                  if(!check_num(register1[j]))
                                  {
                                        errors(4, asm_line_count);
                                        system("PAUSE");
                                        return EXIT_SUCCESS;
                                  }
                             }
                             
                             //Now convert the register to binary and place it on the binary1 string
                             binary1 += dec2binary(atoi(register1.c_str()), 5);
                             
                             //To check for a register number that's too large, I'll check the length
                             //of the binary string. It should be 11 bits.
                             if(binary1.length() > 11)
                             {
                                  errors(5, asm_line_count);
                                  system("PAUSE");
                                  return EXIT_SUCCESS;
                             }

                        //Register 2
                             //This loop advances the index to the first non-space character
                             while((line[i] == ' ') || (line[i] == '\t'))
                             {
                                  i++;
                             }
                             
                             //Checking to see if there's an 'r' in front of the register number
                             if(line[i] != 'r')
                             {
                                   errors(3, asm_line_count);
                                   system("PAUSE");
                                   return EXIT_SUCCESS;
                             }
                             
                             //If there is an 'r' there, advance the iterator and get the register number
                             i++;
                                                     
                             while((line[i] != ' ') && (line[i] != '\t') && (line[i] != '#') && (line[i] != '\n') && (line[i] != ','))
                             {
                                  register2 += line[i];
                                  i++;
                             }
                             
                             //Check to make sure the line doesn't end there
                             if((line[i] == '#') || (line[i] == '\n'))
                             {
                                  errors(1, asm_line_count);
                                  system("PAUSE");
                                  return EXIT_SUCCESS;
                             }
                             
                             //Check to see if there's a comma; if so, advance the iterator past it
                             if(line[i] == ',')
                                   i++;
                             
                             //Check to see if the register number is actually a number
                             for(int j = 0; j < register2.length(); j++)
                             {
                                  if(!check_num(register2[j]))
                                  {
                                        errors(4, asm_line_count);
                                        system("PAUSE");
                                        return EXIT_SUCCESS;
                                  }
                             }
                             
                             //Now convert the register to binary and place it on the binary1 string
                             binary1 += dec2binary(atoi(register2.c_str()), 5);
                             
                             //To check for a register number that's too large, I'll check the length
                             //of the binary string. It should be 16 bits.
                             if(binary1.length() > 16)
                             {
                                  errors(5, asm_line_count);
                                  system("PAUSE");
                                  return EXIT_SUCCESS;
                             }
                        //Register 3
                             //This loop advances the index to the first non-space character
                             while((line[i] == ' ') || (line[i] == '\t'))
                             {
                                  i++;
                             }
                             
                             //Checking to see if there's an 'r' in front of the register number
                             if(line[i] != 'r')
                             {
                                   errors(3, asm_line_count);
                                   system("PAUSE");
                                   return EXIT_SUCCESS;
                             }
                             
                             //If there is an 'r' there, advance the iterator and get the register number
                             i++;
                                                     
                             while((line[i] != ' ') && (line[i] != '\t') && (line[i] != '#') && (line[i] != '\n') && (line[i] != ','))
                             {
                                  register3 += line[i];
                                  i++;
                             }
                             
                             //Check to see if there's a comma; if so, advance the iterator past it
                             if(line[i] == ',')
                                   i++;
                             
                             //Check to see if the register number is actually a number
                             for(int j = 0; j < register3.length(); j++)
                             {
                                  if(!check_num(register3[j]))
                                  {
                                        errors(4, asm_line_count);
                                        system("PAUSE");
                                        return EXIT_SUCCESS;
                                  }
                             }
                             
                             //Now convert the register to binary and place it on the binary2 string
                             binary2 += dec2binary(atoi(register3.c_str()), 5);
                             
                             //To check for a register number that's too large, I'll check the length
                             //of the binary string. It should be 5 bits.
                             if(binary2.length() > 5)
                             {
                                  errors(5, asm_line_count);
                                  system("PAUSE");
                                  return EXIT_SUCCESS;
                             }
                        //Now that that's done, place the auxiliary value on the binary2 string
                        binary2 += auxiliary;
                   }
                   
                   //For the immediate addressing mode/format
                   if(format == 'i')
                   {
                        //Register 1
                             //This loop advances the index to the first non-space character
                             while((line[i] == ' ') || (line[i] == '\t'))
                             {
                                  i++;
                             }
                             
                             //Checking to see if there's an 'r' in front of the register number
                             if(line[i] != 'r')
                             {
                                   errors(3, asm_line_count);
                                   system("PAUSE");
                                   return EXIT_SUCCESS;
                             }
                             
                             //If there is an 'r' there, advance the iterator and get the register number
                             i++;
                                                     
                             while((line[i] != ' ') && (line[i] != '\t') && (line[i] != '#') && (line[i] != '\n') && (line[i] != ','))
                             {
                                  register1 += line[i];
                                  i++;
                             }
                             
                             //Check to make sure the line doesn't end there
                             if((line[i] == '#') || (line[i] == '\n'))
                             {
                                  errors(1, asm_line_count);
                                  system("PAUSE");
                                  return EXIT_SUCCESS;
                             }
                             
                             //Check to see if there's a comma; if so, advance the iterator past it
                             if(line[i] == ',')
                                   i++;
                             
                             //Check to see if the register number is actually a number
                             for(j = 0; j < register1.length(); j++)
                             {
                                  if(!check_num(register1[j]))
                                  {
                                        errors(4, asm_line_count);
                                        system("PAUSE");
                                        return EXIT_SUCCESS;
                                  }
                             }
                             
                             //Now convert the register to binary and place it on the binary1 string
                             binary1 += dec2binary(atoi(register1.c_str()), 5);
                             
                             //To check for a register number that's too large, I'll check the length
                             //of the binary string. It should be 11 bits.
                             if(binary1.length() > 11)
                             {
                                  errors(5, asm_line_count);
                                  system("PAUSE");
                                  return EXIT_SUCCESS;
                             }
                             
                        //Register 2
                             //This loop advances the index to the first non-space character
                             while((line[i] == ' ') || (line[i] == '\t'))
                             {
                                  i++;
                             }
                             
                             //Checking to see if there's an 'r' in front of the register number
                             if(line[i] != 'r')
                             {
                                   errors(3, asm_line_count);
                                   system("PAUSE");
                                   return EXIT_SUCCESS;
                             }
                             
                             //If there is an 'r' there, advance the iterator and get the register number
                             i++;
                                                     
                             while((line[i] != ' ') && (line[i] != '\t') && (line[i] != '#') && (line[i] != '\n') && (line[i] != ','))
                             {
                                  register2 += line[i];
                                  i++;
                             }
                             
                             //Check to make sure the line doesn't end there
                             if((line[i] == '#') || (line[i] == '\n'))
                             {
                                  errors(1, asm_line_count);
                                  system("PAUSE");
                                  return EXIT_SUCCESS;
                             }
                             
                             //Check to see if there's a comma; if so, advance the iterator past it
                             if(line[i] == ',')
                                   i++;
                             
                             //Check to see if the register number is actually a number
                             for(j = 0; j < register2.length(); j++)
                             {
                                  if(!check_num(register2[j]))
                                  {
                                        errors(4, asm_line_count);
                                        system("PAUSE");
                                        return EXIT_SUCCESS;
                                  }
                             }
                             
                             j = 0;
                             
                             //Now convert the register to binary and place it on the binary1 string
                             binary1 += dec2binary(atoi(register2.c_str()), 5);
                             
                             //To check for a register number that's too large, I'll check the length
                             //of the binary string. It should be 16 bits.
                             if(binary1.length() > 16)
                             {
                                  errors(5, asm_line_count);
                                  system("PAUSE");
                                  return EXIT_SUCCESS;
                             }
                             
                        //The immediate value
                             //This loop advances the index to the first non-space character
                             while((line[i] == ' ') || (line[i] == '\t'))
                             {
                                  i++;
                             }
                              
                             //Get the immediate                       
                             while((line[i] != ' ') && (line[i] != '\t') && (line[i] != '#') && (line[i] != '\n') && (line[i] != ','))
                             {
                                  immediate += line[i];
                                  i++;
                             }
                             
                             //This loop checks the immediate against the list of labels that was gathered
                             //during the first pass
                             j = 0;
                             while(j < max_labels)
                             {
                                  if(label_names[j].compare(immediate) == 0)
                                       break;
                                  j++;
                             }
                             
                             //If the immediate value wasn't a label
                             if(j == max_labels)
                             {
                                  //Check to see if the immediate value is actually a number
                                  for(j = 0; j < immediate.length(); j++)
                                  {
                                       if(!check_num(immediate[j]))
                                       {
                                             errors(4, asm_line_count);
                                             system("PAUSE");
                                             return EXIT_SUCCESS;
                                       }
                                  }
                                  
                                  //Now convert the value to binary and place it on the binary2 string
                                  binary2.clear();
                                  binary2 += dec2binary(atoi(immediate.c_str()), 16);
                                  
                                  //To check for an immediate that's too large, I'll check the length
                                  //of the binary string. It should be 16 bits.
                                  if(binary2.length() > 16)
                                  {
                                       errors(5, asm_line_count);
                                       system("PAUSE");
                                       return EXIT_SUCCESS;
                                  }
                             }
                             //If it was a label, get its address and put it in the instruction
                             else
                             {
                                  //Get the address from the label address array
                                  //and put it on binary2
                                  temp_str = dec2binary(label_addr[j], 16);
                                  
                                  //Check for a number that's too large
                                  if(temp_str.length() > 16)
                                  {
                                       errors(5, asm_line_count);
                                       system("PAUSE");
                                       return EXIT_SUCCESS;
                                  }
                                  binary2 += temp_str;
                             }
                   }
                   
                   //For the displacement addressing mode/format
                   if(format == 'd')
                   {                       
                        //Now, because I'm including the ability to specifiy labels as well as hard
                        //registers and numbers as addresses in jump/branch instructions, I have to
                        //do something weird here. I'm going to check the label given against the list
                        //of labels. If it doesn't match any, I'll treat it like the last parts of
                        //an immediate instruction. Otherwise, register1 = 0, and the displacement is
                        //the address given by the label.
                        
                        //Get the label
                             temp_str.clear();
                             
                             //This loop advances the index to the first non-space character
                             while((line[i] == ' ') || (line[i] == '\t'))
                             {
                                  i++;
                             }
                             
                             k = i;
                             
                             //Get the label                                                     
                             while((line[i] != ' ') && (line[i] != '\t') && (line[i] != '#') && (line[i] != '\n') && (line[i] != ','))
                             {
                                  temp_str += line[i];
                                  i++;
                             }
                             
                             //This loop checks the label against the list of labels that was gathered
                             //during the first pass
                             while(j < max_labels)
                             {
                                  if(label_names[j].compare(temp_str) == 0)
                                       break;
                                  j++;
                             }
                             
                             //If the label wasn't in the list
                             if(j == max_labels)
                             {
                                  i = k;
                                  //Register 1
                                       //This loop advances the index to the first non-space character
                                       while((line[i] == ' ') || (line[i] == '\t'))
                                       {
                                            i++;
                                       }
                                       
                                       //Checking to see if there's an 'r' in front of the register number
                                       if(line[i] != 'r')
                                       {
                                             errors(3, asm_line_count);
                                             system("PAUSE");
                                             return EXIT_SUCCESS;
                                       }
                                       
                                       //If there is an 'r' there, advance the iterator and get the register number
                                       i++;
                                                               
                                       while((line[i] != ' ') && (line[i] != '\t') && (line[i] != '#') && (line[i] != '\n') && (line[i] != ','))
                                       {
                                            register1 += line[i];
                                            i++;
                                       }
                                       
                                       //Check to make sure the line doesn't end there
                                       if((line[i] == '#') || (line[i] == '\n'))
                                       {
                                            errors(1, asm_line_count);
                                            system("PAUSE");
                                            return EXIT_SUCCESS;
                                       }
                                       
                                       //Check to see if there's a comma; if so, advance the iterator past it
                                       if(line[i] == ',')
                                             i++;
                                       
                                       //Check to see if the register number is actually a number
                                       for(j = 0; j < register1.length(); j++)
                                       {
                                            if(!check_num(register1[j]))
                                            {
                                                  errors(4, asm_line_count);
                                                  system("PAUSE");
                                                  return EXIT_SUCCESS;
                                            }
                                       }
                                       
                                       //Now convert the register to binary and place it on the binary1 string
                                       binary1 += dec2binary(atoi(register1.c_str()), 5);
                                       
                                       //To check for a register number that's too large, I'll check the length
                                       //of the binary string. It should be 11 bits.
                                       if(binary1.length() > 11)
                                       {
                                            errors(5, asm_line_count);
                                            system("PAUSE");
                                            return EXIT_SUCCESS;
                                       }
                                  
                                  //The immediate value
                                       //This loop advances the index to the first non-space character
                                       while((line[i] == ' ') || (line[i] == '\t'))
                                       {
                                            i++;
                                       }
                                                               
                                       while((line[i] != ' ') && (line[i] != '\t') && (line[i] != '#') && (line[i] != '\n') && (line[i] != ','))
                                       {
                                            displacement += line[i];
                                            i++;
                                       }
                                       
                                       //Check to see if the i is immediate value is actually a number
                                       for(j = 0; j < displacement.length(); j++)
                                       {
                                            if(!check_num(displacement[j]))
                                            {
                                                  errors(4, asm_line_count);
                                                  system("PAUSE");
                                                  return EXIT_SUCCESS;
                                            }
                                       }
                                       
                                       
                                       temp_str.clear();
                                       
                                       //Now convert the value to binary and place it on the binary strings
                                       temp_str = dec2binary(atoi(displacement.c_str()), 21);
                                       
                                       //Check for a number that's too large
                                       if(temp_str.length()> 21)
                                       {
                                            errors(5, asm_line_count);
                                            system("PAUSE");
                                            return EXIT_SUCCESS;
                                       }
                                       
                                       binary1 += temp_str.substr(0, 5);
                                       binary2 += temp_str.substr(5, 21);                                  
                             }
                             //If the label was in the list
                             else
                             {
                                  //Put five zeros on binary1 for register1 = 0
                                  binary1 += "00000";
                                  
                                  //Get the address from the label address array
                                  //and put it on binary1 and binary2
                                  temp_str = dec2binary(label_addr[j], 21);
                                  
                                  //Check for a number that's too large
                                  if(temp_str.length()> 21)
                                  {
                                       errors(5, asm_line_count);
                                       system("PAUSE");
                                       return EXIT_SUCCESS;
                                  }
                                       
                                  binary1 += temp_str.substr(0, 5);
                                  binary2 += temp_str.substr(5, 21);
                             }    
                   }
                   
                   //For the compare format
                   if(format == 'c')
                   {
                         //Since there is no destination register, just put five
                         //zeros on binary1
                         binary1 += "00000";
                         
                         //Now, get registers 1 and 2 and place them on the binary
                         //strings
                         //Register 2
                             //This loop advances the index to the first non-space character
                             while((line[i] == ' ') || (line[i] == '\t'))
                             {
                                  i++;
                             }
                             
                             //Checking to see if there's an 'r' in front of the register number
                             if(line[i] != 'r')
                             {
                                   errors(3, asm_line_count);
                                   system("PAUSE");
                                   return EXIT_SUCCESS;
                             }
                             
                             //If there is an 'r' there, advance the iterator and get the register number
                             i++;
                                                     
                             while((line[i] != ' ') && (line[i] != '\t') && (line[i] != '#') && (line[i] != '\n') && (line[i] != ','))
                             {
                                  register2 += line[i];
                                  i++;
                             }
                             
                             //Check to make sure the line doesn't end there
                             if((line[i] == '#') || (line[i] == '\n'))
                             {
                                  errors(1, asm_line_count);
                                  system("PAUSE");
                                  return EXIT_SUCCESS;
                             }
                             
                             //Check to see if there's a comma; if so, advance the iterator past it
                             if(line[i] == ',')
                                   i++;
                             
                             //Check to see if the register number is actually a number
                             for(int j = 0; j < register2.length(); j++)
                             {
                                  if(!check_num(register2[j]))
                                  {
                                        errors(4, asm_line_count);
                                        system("PAUSE");
                                        return EXIT_SUCCESS;
                                  }
                             }
                             
                             //Now convert the register to binary and place it on the binary1 string
                             binary1 += dec2binary(atoi(register2.c_str()), 5);
                             
                             //To check for a register number that's too large, I'll check the length
                             //of the binary string. It should be 16 bits.
                             if(binary1.length() > 16)
                             {
                                  errors(5, asm_line_count);
                                  system("PAUSE");
                                  return EXIT_SUCCESS;
                             }
                             
                             if (binary1[4] == '1')
                             {
                                //Register 3
                                  //This loop advances the index to the first non-space character
                                  while((line[i] == ' ') || (line[i] == '\t'))
                                  {
                                       i++;
                                  }
                                  
                                  //Checking to see if there's an 'r' in front of the register number
                                  if(line[i] != 'r')
                                  {
                                        errors(3, asm_line_count);
                                        system("PAUSE");
                                        return EXIT_SUCCESS;
                                  }
                                  
                                  //If there is an 'r' there, advance the iterator and get the register number
                                  i++;
                                                          
                                  while((line[i] != ' ') && (line[i] != '\t') && (line[i] != '#') && (line[i] != '\n') && (line[i] != ','))
                                  {
                                       register3 += line[i];
                                       i++;
                                  }
                                  
                                  //Check to see if there's a comma; if so, advance the iterator past it
                                  if(line[i] == ',')
                                        i++;
                                  
                                  //Check to see if the register number is actually a number
                                  for(int j = 0; j < register3.length(); j++)
                                  {
                                       if(!check_num(register3[j]))
                                       {
                                             errors(4, asm_line_count);
                                             system("PAUSE");
                                             return EXIT_SUCCESS;
                                       }
                                  }
                                  
                                  //Now convert the register to binary and place it on the binary2 string
                                  binary2 += dec2binary(atoi(register3.c_str()), 5);
                                  
                                  //To check for a register number that's too large, I'll check the length
                                  //of the binary string. It should be 5 bits.
                                  if(binary2.length() > 5)
                                  {
                                       errors(5, asm_line_count);
                                       system("PAUSE");
                                       return EXIT_SUCCESS;
                                  }
                                  //Now that that's done, place the auxiliary value on the binary2 string
                                  binary2 += auxiliary;
                             }
                             else if (binary1[4] == '0')
                             {
                                  //The immediate value
                                  //This loop advances the index to the first non-space character
                                  while((line[i] == ' ') || (line[i] == '\t'))
                                  {
                                       i++;
                                  }
                                   
                                  //Get the immediate                       
                                  while((line[i] != ' ') && (line[i] != '\t') && (line[i] != '#') && (line[i] != '\n') && (line[i] != ','))
                                  {
                                       immediate += line[i];
                                       i++;
                                  }
                                  
                                  //Check to see if the immediate value is actually a number
                                  for(j = 0; j < immediate.length(); j++)
                                  {
                                       if(!check_num(immediate[j]))
                                       {
                                             errors(4, asm_line_count);
                                             system("PAUSE");
                                             return EXIT_SUCCESS;
                                       }
                                  }
                                  
                                  //Now convert the value to binary and place it on the binary2 string
                                  binary2.clear();
                                  binary2 += dec2binary(atoi(immediate.c_str()), 16);
                                  
                                  //To check for an immediate that's too large, I'll check the length
                                  //of the binary string. It should be 16 bits.
                                  if(binary2.length() > 16)
                                  {
                                       errors(5, asm_line_count);
                                       cout << "\nGARRRRR" << binary2.length();
                                       system("PAUSE");
                                       return EXIT_SUCCESS;
                                  }
                             }
                   }
                   
                   //For the pin format
                   if(format == 'p')
                   {
                        //Pin instructions are in immediate format, with the first
                        //two registers being r0, so place ten zeros on binary1
                        binary1 += "0000000000";
                        
                        //This loop advances the index to the first non-space character
                        while((line[i] == ' ') || (line[i] == '\t'))
                        {
                             i++;
                        }
                        
                        //Now, get the immediate value and put that on the binary2 string                  
                        while((line[i] != ' ') && (line[i] != '\t') && (line[i] != '#') && (line[i] != '\n') && (line[i] != ','))
                        {
                             immediate += line[i];
                             i++;
                        }
                        
                        binary2 += dec2binary(atoi(immediate.c_str()), 16);
                        
                        //Check for length
                        if(binary2.length() > 16)
                        {
                             errors(5, asm_line_count);
                             system("PAUSE");
                             return EXIT_SUCCESS;
                        }
                   }
                   
                   //For the port format
                   if(format == 'o')
                   {
                        //Get register1, the rest is just zeros
                             //This loop advances the index to the first non-space character
                             while((line[i] == ' ') || (line[i] == '\t'))
                             {
                                  i++;
                             }
                             
                             //Checking to see if there's an 'r' in front of the register number
                             if(line[i] != 'r')
                             {
                                   errors(3, asm_line_count);
                                   system("PAUSE");
                                   return EXIT_SUCCESS;
                             }
                             
                             //If there is an 'r' there, advance the iterator and get the register number
                             i++;
                                                     
                             while((line[i] != ' ') && (line[i] != '\t') && (line[i] != '#') && (line[i] != '\n') && (line[i] != ','))
                             {
                                  register1 += line[i];
                                  i++;
                             }
                             
                             //Check to see if the register number is actually a number
                             for(j = 0; j < register1.length(); j++)
                             {
                                  if(!check_num(register1[j]))
                                  {
                                        errors(4, asm_line_count);
                                        system("PAUSE");
                                        return EXIT_SUCCESS;
                                  }
                             }
                             
                             //For output port
                             if (!binary1.compare("010011"))
                             {
                                  //Now convert the register to binary and place it on the binary1 string
                                  binary1 += "00000";
                                  binary1 += dec2binary(atoi(register1.c_str()), 5);
                             }
                             
                             //For input port
                             if (!binary1.compare("010010"))
                             {
                                  //Now convert the register to binary and place it on the binary1 string
                                  binary1 += dec2binary(atoi(register1.c_str()), 5);
                                  binary1 += "00000";
                             }
                             
                             //To check for a register number that's too large, I'll check the length
                             //of the binary string. It should be 11 bits.
                             if(binary1.length() > 16)
                             {
                                  errors(5, asm_line_count);
                                  system("PAUSE");
                                  return EXIT_SUCCESS;
                             }
                        //Throw the zeros on binary2
                        binary2 += "0000000000000000";
                   }
                   if(format == 'n')
                   {
                        binary1 += "0000000000";
                        binary2 += "0000000000000000";
                   }
                   
                   
                   //Display all this fun stuff
                   cout << "Register 1: " << register1 << "\n";
                   cout << "Register 2: " << register2 << "\n";
                   cout << "Register 3: " << register3 << "\n";
                   cout << "Binary1: " << binary1 << "\n";
                   cout << "Binary2: " << binary2 << "\n\n";
                   
                   foutd << "Register 1: " << register1 << "\n";
                   foutd << "Register 2: " << register2 << "\n";
                   foutd << "Register 3: " << register3 << "\n";
                   foutd << "Binary1: " << binary1 << "\n";
                   foutd << "Binary2: " << binary2 << "\n\n";

				   fout << ", \n" << bin2hex(binary1.substr(0,4)) << bin2hex(binary1.substr(4,4)) << bin2hex(binary1.substr(8,4)) << bin2hex(binary1.substr(12,4));
				   fout << bin2hex(binary2.substr(0,4)) << bin2hex(binary2.substr(4,4)) << bin2hex(binary2.substr(8,4)) << bin2hex(binary2.substr(12,4));
                   
					/*
                   fout << bin2hex(binary1.substr(8, 4));
                   fout << bin2hex(binary1.substr(12, 4));
                   fout << bin2hex(binary1.substr(0, 4));
                   fout << bin2hex(binary1.substr(4, 4));
                   
                   fout << bin2hex(binary2.substr(8, 4));
                   fout << bin2hex(binary2.substr(12, 4));
                   fout << bin2hex(binary2.substr(0, 4));
                   fout << bin2hex(binary2.substr(4, 4));
					*/
                   
                   bin_line_count += 2;
              }
              else
                  foutd << "Label, skipping line\n";
         }
         
         cout << endl;
         
         //Reset everything
         getline(fin, line);
         line += '\n';
       
         asm_line_count++;
         temp_str.clear();
         mnemonic.clear();
         binary1.clear();
         binary2.clear();
         immediate.clear();
         register1.clear();
         register2.clear();
         register3.clear();
         auxiliary.clear();
         temp_char = 'a';
          
         i = 0;
         j = 0;  
    }
    
	fout << ";";

    fin.close();
    fout.close();
    
    cout << "Complete without errors!\n\n";
    cout << "WAIEY DRAINKING SAYUNTAYUNA CSHAYUMP CAWZ ITSOOOO CRAYISP (CRAIEOUSYP)\n";
    
    foutd << "Complete without errors!\n\n";
    foutd << "WAIEY DRAINKING SAYUNTAYUNA CSHAYUMP CAWZ ITSOOOO CRAYISP (CRAIEOUSYP)\n";
    
    system("PAUSE");
    return EXIT_SUCCESS;
}
