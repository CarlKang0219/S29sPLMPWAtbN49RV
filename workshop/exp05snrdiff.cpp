/*
Title       : Experiment 2
Project     : Mtk 5th generation communication system
Author      : Ming Jie Yang
Date        : 
Description : 
              
              
              
              
              
*/
#include <itpp/itcomm.h>

using namespace itpp;

//These lines are needed for use of cout and endl
using std::cout;
using std::endl;

//Function defined here
double eval_avg_power(const cvec& symbol_vec);

int main()
{
  //Declarations of scalars and vectors:
  int i, Number_of_bits;
  double Ps, N0, dist_1, dist_2, h1, h2, Eb;
  double EbN0;
  double rcvd_power_1, rcvd_power_2;

  vec alpha;                                            //vec is a vector containing double
  vec bit_error_rate_1, bit_error_rate_2;
  vec ber_theo_1, ber_theo_2;                           // Theoretical results for multiple access

  bvec transmitted_bits_1, transmitted_bits_2;          //bvec is a vector containing bits
  bvec received_bits_1, received_bits_2;

  cvec transmitted_symbols_1, transmitted_symbols_2, transmitted_symbols; //cvec is a vector containing double_complex
  cvec received_symbols_1, received_symbols_2, feedback_symbols_1;

  //Declarations of classes:
  QPSK qpsk;                     //The QPSK modulator class
  AWGN_Channel awgn_channel;     //The AWGN channel class
  it_file ff;                    //For saving the results to file
  BERC berc;                     //Used to count the bit errors
  Real_Timer tt;                 //The timer used to measure the execution time

  //Reset and start the timer:
  tt.tic();

  //Init:
  Ps = 5 * pow(10, -3);          //The transmitted energy per QPSK symbol is 1, 5e-3 W/MHz
  N0 = 4 * pow(10, -15);         //Thermal noise -144dBm/MHz
  dist_1 = 150;                   //Distance form transmitter to receiver 1 (meter)
  dist_2 = 220;                  //                   *                  2
  h1 = pow(dist_1, -4.5);        //Channel gain for receiver 1
  h2 = pow(dist_2, -4.5);        //
  cout << "h1 = " << h1 << " h2 = " << h2 << endl;
  alpha = linspace(1.0, 0.0, 21);//Simulate for different weight on power

//  Eb = Ec / 2.0;                 //The transmitted energy per bit is 0.5.
//  EbN0dB = linspace(0.0, 9.0, 10); //Simulate for 10 Eb/N0 values from 0 to 9 dB.
//  EbN0 = inv_dB(EbN0dB);         //Calculate Eb/N0 in a linear scale instead of dB.
//  N0 = Eb * pow(EbN0, -1.0);     //N0 is the variance of the (complex valued) noise.
  Number_of_bits = 1000000;       //One hundred thousand bits is transmitted for each Eb/N0 value
//  alpha = 0.8;                   //Ratio of allocated power

  //Allocate storage space for the result vector.
  //The "false" argument means "Do not copy the old content of the vector to the new storage area."
  bit_error_rate_1.set_size(alpha.length(), false);
  bit_error_rate_2.set_size(alpha.length(), false);

  //Storage for theoretical ber
  ber_theo_1.set_size(alpha.length(), false);
  ber_theo_2.set_size(alpha.length(), false);

  //Randomize the random number generators in it++:
  RNG_randomize();

  

  //Iterate over all EbN0dB values:
  for (i = 0; i < alpha.length(); i++) {

    //Show how the simulation progresses:
    cout << "Now simulating alpha value = " << alpha(i); 
    cout << " # " << i + 1 << "/" << alpha.length() << endl;

    //Generate a vector of random bits to transmit:
    transmitted_bits_1 = randb(Number_of_bits);
    transmitted_bits_2 = randb(Number_of_bits);

    ivec getValIndex = "05 11 12 07 03";
    cout << getValIndex << endl;
    cout << transmitted_bits_1(getValIndex) << endl;
    for (int j = 0; j < 5; j++) {
      cout << transmitted_bits_1(getValIndex(j)) << " ";
    }
    cout << endl;
    ivec sorted = sort_index(getValIndex);
    cout << sorted << endl;
    cout << getValIndex(sorted) << endl;
    cout << getValIndex(sorted) + 1 << endl;

    int blockSize = 10; // input size
    bvec encoder_input = randb(blockSize);
    int codedLen = 2 * (blockSize + (constraint_length - 1));
    int nBlocks = encoder_input.length() / blockSize;
    ivec window(blockSize);
    for (int j = 0; j < blockSize; j++) {
      window[j] = j;
    }
    bvec nsc_coded_bits(codedLen);
    //cout << codedLen << endl;
    bvec tr_coded_bits;
    //cout << window << endl;
    for (int j = 0; j < nBlocks; j++) {
      nsc.encode_tail(encoder_input(window), nsc_coded_bits);
      window = window + blockSize;
      tr_coded_bits = concat(tr_coded_bits, nsc_coded_bits);
    }
    //cout << tr_coded_bits.length() << endl;
    //cout << (Number_of_bits/256)*(512+4) << endl;
    /*for (int j = 0; j < Number_of_bits; j++) {
      transmitted_bits_2[j] = tr_coded_bits[j];
    }*/
    
    bvec decoder_input = tr_coded_bits;
    int nBlock_rcvd = decoder_input.length() / codedLen;
    //cout << "rcvd number of blocks : " << nBlock_rcvd << endl;
    vec codedBlock(codedLen);
    bvec bit_rcvd_tmp(blockSize);
    bvec bit_decoded;
    for (int j = 0; j < nBlock_rcvd; j++) {
      for (int k = 0; k < codedLen; k++) {
        codedBlock[k] = decoder_input[k + j*codedLen];
      }
      nsc.decode_tail(codedBlock, bit_rcvd_tmp);
      bit_decoded = concat(bit_decoded, bit_rcvd_tmp);
    }
    double nscErr = 0;
    for (int j = 0; j < bit_decoded.length(); j++) {
      if (bit_decoded[j] != encoder_input[j]) {
        nscErr++;
      }
    }    
    cout << nscErr / bit_decoded.length() << endl;
    return 0;

    //Modulate the bits to QPSK symbols:
    transmitted_symbols_1 = qpsk.modulate_bits(transmitted_bits_1);
    transmitted_symbols_2 = qpsk.modulate_bits(transmitted_bits_2);

    //Multiplex two signals
    transmitted_symbols = transmitted_symbols_1 * pow(alpha(i), 0.5) + transmitted_symbols_2 * pow(1 - alpha(i), 0.5);
    transmitted_symbols = transmitted_symbols * pow(Ps, 0.5);
    //eval_avg_power(transmitted_symbols);

    //Fading
    transmitted_symbols_1 = transmitted_symbols * pow(h1, 0.5);
    transmitted_symbols_2 = transmitted_symbols * pow(h2, 0.5);

    //Set the noise variance of the AWGN channel:
    awgn_channel.set_noise(N0);

    //Run the transmited symbols through the channel using the () operator:
    received_symbols_1 = awgn_channel(transmitted_symbols_1);
    received_symbols_2 = awgn_channel(transmitted_symbols_2);

    //Demodulate the received QPSK symbols into received bits: Layer 1
    received_bits_1 = qpsk.demodulate_bits(received_symbols_1);

    //Demodulate the received QPSK symbols into received bits: Layer 2
    received_bits_2 = qpsk.demodulate_bits(received_symbols_2);
    feedback_symbols_1 = pow(Ps * alpha(i) * h2, 0.5) * qpsk.modulate_bits(received_bits_2);
    received_bits_2 = qpsk.demodulate_bits(received_symbols_2 - feedback_symbols_1);

    //Calculate the bit error rate:
    berc.clear();                               //Clear the bit error rate counter
    berc.count(transmitted_bits_1, received_bits_1); //Count the bit errors
    bit_error_rate_1(i) = berc.get_errorrate();   //Save the estimated BER in the result vector

    berc.clear();
    berc.count(transmitted_bits_2, received_bits_2);
    bit_error_rate_2(i) = berc.get_errorrate();
  }
  tt.toc();

  // Theoretical results for multiple access
  for (size_t i = 0; i < alpha.length(); ++i) {        //BER for theo 1
    EbN0 = (Ps * h1 * alpha(i)) / (N0 + Ps * h1 * (1 - alpha(i)));
    ber_theo_1(i) = 0.5*erfc(pow(EbN0, 0.5));
  }
  for (size_t i = 0; i < alpha.length(); ++i) {        //BER for theo 2
    EbN0 = (Ps * h2 * (1-alpha(i))) / N0;
    ber_theo_2(i) = 0.5*erfc(pow(EbN0, 0.5));
  }

  //Print the results:
  cout << endl;
  cout << "alpha = " << alpha << " " << endl;
  cout << "BER 1 = " << bit_error_rate_1 << endl;
  cout << "BER 2 = " << bit_error_rate_2 << endl;
  cout << "Theoretical BER 1 = " << ber_theo_1 << endl;
  cout << "Theoretical BER 2 = " << ber_theo_2 << endl;
  cout << "Saving results to ./qpsk_result_file.it" << endl;
  cout << endl;

  //Save the results to file:
  std::ofstream oo;
  oo.open("exp05result.txt");
  for (size_t i = 1; i < alpha.length(); i++) {
    oo << alpha << " ";
    oo << bit_error_rate_1 << " ";
    oo << bit_error_rate_2 << endl;
  }
  oo.close();

  //Exit program:
  return 0;
}

//Evaluate average power of given vector of symbols #M00
double eval_avg_power(const cvec& symbol_vec)
{
  //Overflow check is not implemented in this function
  bool verbose = true;
  double average_power = 0.0;
  double acculmulate_power = 0.0;
  for (size_t i = 0; i < symbol_vec.length(); ++i) {
    acculmulate_power += pow(std::abs(symbol_vec(i)), 2.0);
  }
  average_power = acculmulate_power / symbol_vec.length();

  //Result [verbose]
  if (verbose) {
    cout << "[M00] " << "Average power = " << average_power << endl;
  }
  return average_power;
}





