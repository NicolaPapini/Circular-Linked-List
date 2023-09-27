# Circular Linked List

RISC-V Assembly project to manage a Circular Linked List. The program will also execute a series of commands that are provided as an input string by the user. 

## Project Details

Each node of the list is 5 bytes, divided as follows:
- DATA(Byte 0): contains the information which is an integer number that represents an ASCII character.
- POINTER(Byte 1-4): contains the pointer to the next element of the list or itself if it's the only element.


To sort the list the following order is applied (in a transitive way):
- An uppercase letter (65->90 inclusive) is always considered greater than a lowercase letter;
- A lowercase letter (97->122 inclusive) is always considered greater than a numeral.
- A numeral (48->57 inclusive) is always considered greater than any non-alphanumeric character.
- Non-alphanumeric characters with ASCII codes below 32 or above 125 are not supported.

The commands in the input string are separated by a Tilde character "~".

## Commands and execution

The program accepts the following commands:
+ ADD(x): Adds the character "x" to the list.
+ DEL(x): Deletes all the occurences of the character "x" from the list.
+ PRINT: Prints the current content of the list.
+ REV: Reverses the order of the elements of list.
+ SORT: Sorts the elements of the list following a certain criteria.
+ SDX: Shifts the elements of the list of one position to the right.
+ SSX: Shifts the elements of the list of one position to the left.

Commands are correctly formatted if written like previously listed. Whitespaces are accepted before and after the command.
The program will read the input string, whenever a correctly formatted command is found it will execute the corresponding function. This will continue until the string is finished.

## Examples


listInput = “ADD(1) ~ ADD(a) ~ ADD(a) ~ ADD(B) ~ ADD(;) ~ ADD(9) ~ SSX ~ SORT ~ DEL(b) ~DEL(B) ~ SDX ~ REV ~ PRINT”

| ADD(1) | ADD(a) | ADD(a) | ADD(B) | ADD(;) | ADD(9) |  SSX  |  SORT  | DEL(b) | DEL(B) |  SDX  |   REV | PRINT |
| ------ | ------ |------- | ------ |------- | ------ |-------| ------ | ------ | ------ | ----- | ----  | ----- |
|    1   |  1a    | 1aa    | 1aaB   | 1aaB;  | 1aaB;9 | aaB;91| ;19aaB | ;19aaB | ;19aa  | a;19a | a91;a | a91;a |



listInput = “ADD(3) ~ SSX ~ ADD(x) ~ add(B) ~ ADD(B) ~ ADD ~ ADD(9) ~ SORT(a) ~ DEL(BB) ~ DEL(B) ~ REV ~ SDX ~ PRINT”

| ADD(3) | SSX | ADD(x) | add(B) | ADD(B) | ADD | ADD(9) | SORT(a) | DEL(BB) | DEL(B) |  REV  |  SDX | PRINT |
| ------ | --- |------- | ------ |------- | --- |--------| ------- | ------- | ------ | ----- | ---- | ----- |
|    3   |  3  | 3x     | 1x     | 1xB    | 1xB | 1xB9   | 1xB9    | 1xB9    | 1x9    | 9x1   | 19x  | 19x |





