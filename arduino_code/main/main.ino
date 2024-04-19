#define INSTRUCTION_MEMORY_SIZE 256 // Define the size of the instruction memory
#define DATA

uint16_t instructionMemory[INSTRUCTION_MEMORY_SIZE]; // Allocate an instruction memory of uint16_t
void setup() {
  // put your setup code here, to run once:

  //change pin's when decided, these are garbage pins
  pinMode(0, OUTPUT); // Set pin 0 as output
  pinMode(1, OUTPUT); // Set pin 1 as output
  pinMode(2, OUTPUT); // Set pin 2 as output
  pinMode(3, OUTPUT); // Set pin 3 as output
  pinMode(4, OUTPUT); // Set pin 4 as output
  pinMode(5, OUTPUT); // Set pin 5 as output
  pinMode(6, OUTPUT); // Set pin 6 as output
  pinMode(7, OUTPUT); // Set pin 7 as output

  pinMode(8, INPUT);  //set pin 8 as input
  pinMode(9, INPUT);  //set pin 9 as input
  pinMode(10, INPUT);  //set pin 10 as input
  pinMode(11, INPUT);  //set pin 11 as input
  pinMode(12, INPUT);  //set pin 12 as input
  pinMode(13, INPUT);  //set pin 13 as input
  pinMode(14, INPUT);  //set pin 14 as input
  pinMode(15, INPUT);  //set pin 15 as input

  //signal pins

  pinMode(16, INPUT);
  pinMode(17, INPUT);

  Serial.begin(9600); // Start the serial communication

}

void loop() {

  int shift_done = digitalRead(16);
  int data_out_ready = digitalRead(17);
  int data_in_ready = analogRead(pin);
  int data

  
}
