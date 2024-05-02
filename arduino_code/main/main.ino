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

void setup() {
  // put your setup code here, to run once:
  

}

void loop() {
  // put your main code here, to run repeatedly:

}

void run_code() {
  rst = LOW;
  ard_receive_ready = LOW;
  ard_data_ready = LOW;
  memset(data_memory, 0, sizeof(data_memory));  // Assuming data_memory is an array
  pc = 0;
  in_bus = 0;
  delay(1);  // Simulate @(posedge clk)
  rst = HIGH;
  delay(1);  // Simulate @(posedge clk)
  rst = LOW;
  ard_receive_ready = HIGH;
  delay(3);  // Simulate @(posedge clk)

  while(halt == LOW) {
    Serial.print("PC: ");
    Serial.println(pc, HEX);
    if(bus_pc) {
      pc = (out_bus << 8) | (pc & 0xFF);
      delay(1);  // Simulate @(posedge clk)
      pc = (out_bus << 8) | (pc & 0xFF);
      delay(1);  // Simulate @(posedge clk)
      ard_receive_ready = LOW;
      ard_data_ready = HIGH;
      in_bus = instr_memory[pc] & 0xFF;
      delay(1);  // Simulate @(posedge clk)
      ard_data_ready = HIGH;
      in_bus = (instr_memory[pc] >> 8) & 0xFF;
      delay(1);  // Simulate @(posedge clk)
      if((instr_memory[pc] & 0xF) == I_TYPE || (instr_memory[pc] & 0xF) == M_TYPE) {
        ard_data_ready = HIGH;
        in_bus = instr_memory[pc+1] & 0xFF;
        delay(1);  // Simulate @(posedge clk)
        ard_data_ready = HIGH;
        in_bus = (instr_memory[pc+1] >> 8) & 0xFF;
        delay(1);  // Simulate @(posedge clk)
        ard_data_ready = LOW;
      } else {
        ard_data_ready = LOW;
      }
      ard_receive_ready = HIGH;
      delay(1);  // Simulate @(posedge clk)
    } else if(bus_mar) {
      address = (out_bus << 8) | (address & 0xFF);
      delay(1);  // Simulate @(posedge clk)
      address = (out_bus << 8) | (address & 0xFF);
      delay(1);  // Simulate @(posedge clk)
      if(bus_mdr == LOW) {
        ard_receive_ready = LOW;
        ard_data_ready = HIGH;
        in_bus = data_memory[address] & 0xFF;
        delay(1);  // Simulate @(posedge clk)
        ard_data_ready = HIGH;
        in_bus = (data_memory[address] >> 8) & 0xFF;
        delay(1);  // Simulate @(posedge clk)
        ard_data_ready = LOW;
        ard_receive_ready = HIGH;
        delay(1);  // Simulate @(posedge clk)
      } else {
        load_data = (out_bus << 8) | (load_data & 0xFF);
        delay(1);  // Simulate @(posedge clk)
        load_data = (out_bus << 8) | (load_data & 0xFF);
        delay(1);  // Simulate @(posedge clk)
        data_memory[address] = load_data;
        ard_receive_ready = HIGH;
        ard_data_ready = LOW;
        delay(1);  // Simulate @(posedge clk)
      }
    } else {
      delay(1);  // Simulate @(posedge clk)
    }
  }
}
