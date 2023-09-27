# Circular Linked List

RISC-V Assembly project to manage a Circular Linked List. The program also execute a series of commands that are provided as an input string by the user. 

## Project Details

Each node of the list is 5 byte, divided as follows:
- DATA(Byte 0): contains the information which is an integer number that represents an ASCII character.
- POINTER(Byte 1-4): contains the pointer to the next element of the list or itself it's the only element in the list.


To sort the list the following order is applied (in a transitive way):
- An uppercase letter (65->90 inclusive) is always considered greater than a lowercase letter;
- A lowercase letter (97->122 inclusive) is always considered greater than a numeral.
- A numeral (48->57 inclusive) is always considered greater than any non-alphanumeric character.
- Non-alphanumeric characters with ASCII codes below 32 or above 125 are not considered acceptable.

The commands in the input string are separated by a Tilde character "~".

## Commands and execution

The program will accept the following commands:
+ ADD(x): Adds the character "x" to the list.
+ DEL(x): Deletes all the occurences of the character "x" from the list.
+ PRINT: Prints the current content of the list.
+ REV: Reverses the order of the elements of list.
+ SORT: Sorts the elements of the list following a certain criteria.
+ SDX: Shifts the elements of the list of one position to the right.
+ SSX: Shits the elements of the list of one position to the left.

Commands are correctly formatted if written like previously listed. Before and after the command whitespaces are accepted.
The program will read the input string, whenever a correctly formatted command is found it will execute the corresponding function. This will continue until the string is finished.

##Example Usage





