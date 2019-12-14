#include <SPI.h>
#include <SD.h>

#define CS 53

File myFile;
char FileName[] = "Data.txt";

void Write3CVS(int i, int j, int k, char file[]) {
  myFile = SD.open(file, FILE_WRITE);
  if (myFile) {
    myFile.print(i);
    myFile.print(',');
    myFile.print(j);
    myFile.print(',');
    myFile.println(k);
    myFile.close();
  }
}

void Write3CVS(double i, double j, double k, char file[], int precI, int precJ, int precK) {
  myFile = SD.open(file, FILE_WRITE);
  if (myFile) {
    myFile.print(i, precI);
    myFile.print(',');
    myFile.print(j, precJ);
    myFile.print(',');
    myFile.println(k, precK);
    myFile.close();
  }
}

void setup() {
  // Open serial communications and wait for port to open:
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }


  Serial.print("Initializing SD card...");

  if (!SD.begin(CS)) {
    Serial.println("initialization failed!");
    while (1);
  }
  Serial.println("initialization done.");

  // open the file. note that only one file can be open at a time,
  // so you have to close this one before opening another.
  myFile = SD.open(FileName, FILE_WRITE);

  // if the file opened okay, write to it:
  if (myFile) {
    Serial.print("Writing to data.txt...");
    myFile.println("X,Y,Height");
    // close the file:
    myFile.close();
    Serial.println("done.");
  } else {
    // if the file didn't open, print an error:
    Serial.println("error opening test.txt");
  }

// Write loop... 
    for(int i = 0; i <= 9; i++){
      for(int j = 0; j <= 9; j++){
        myFile = SD.open("data.txt", FILE_WRITE);
        if(myFile){
          myFile.print(i);
          myFile.print(",");
          myFile.print(j);
          myFile.print(",");
          myFile.println(10*i+j);
          myFile.close();
          Serial.print(i);
          Serial.print(",");
          Serial.print(j);
          Serial.print(",");
          Serial.println(10*i+j);
          delay(10);
        }
        else{
          Serial.println("Error opening");
          delay(1000);
        }
      }
    }
}

void loop() {
  // nothing happens after setup
 
}
