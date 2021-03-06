/*
Title       : Experiment 1
Project     : Mtk 5th generation communication system
Author      : Ming Jie Yang
Date        : 23-March-14
Description : Non-orthogonal multiple access (NOMA) with successive
              interference cancellation (SIC) in Downlink scenario. The
              transmission is done by single BS, and the signals is multiplexed
              by power allocation ratio (alpha). Reception is done by two
              seperate device in same pathloss condition. Two stream is
              transmitted and ber is evaluated by BER for each stream.
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
  double Ec, Eb;
  double alpha;
  vec EbN0dB, EbN0, N0, noise_variance;                 //vec is a vector containing double
  vec bit_error_rate_1, bit_error_rate_2;
  vec transmission_power;
  bvec transmitted_bits_1, transmitted_bits_2;          //bvec is a vector containing bits
  bvec received_bits_1, received_bits_2;
  cvec transmitted_symbols_1, transmitted_symbols_2, transmitted_symbols; //cvec is a vector containing double_complex
  cvec received_symbols, feedback_symbols_1;

  //Declarations of classes:
  QPSK qpsk;                     //The QPSK modulator class
  AWGN_Channel awgn_channel;     //The AWGN channel class
  it_file ff;                    //For saving the results to file
  BERC berc;                     //Used to count the bit errors
  Real_Timer tt;                 //The timer used to measure the execution time

  //Reset and start the timer:
  tt.tic();

  //Init:
  Ec = 1.0;                      //The transmitted energy per QPSK symbol is 1.
  Eb = Ec / 2.0;                 //The transmitted energy per bit is 0.5.
  EbN0dB = linspace(0.0, 9.0, 10); //Simulate for 10 Eb/N0 values from 0 to 9 dB.
  EbN0 = inv_dB(EbN0dB);         //Calculate Eb/N0 in a linear scale instead of dB.
  N0 = Eb * pow(EbN0, -1.0);     //N0 is the variance of the (complex valued) noise.
  Number_of_bits = 1000000;       //One hundred thousand bits is transmitted for each Eb/N0 value
  alpha = 0.8;                   //Ratio of allocated power

  //Allocate storage space for the result vector.
  //The "false" argument means "Do not copy the old content of the vector to the new storage area."
  bit_error_rate_1.set_size(EbN0dB.length(), false);
  bit_error_rate_2.set_size(EbN0dB.length(), false);

  //Allocate storage for exact average power transmitted
  transmission_power.set_size(EbN0dB.length(), false);

  //Randomize the random number generators in it++:
  RNG_randomize();

  //Iterate over all EbN0dB values:
  for (i = 0; i < EbN0dB.length(); i++) {

    //Show how the simulation progresses:
    cout << "Now simulating Eb/N0 value number " << i + 1 << " of " << EbN0dB.length() << endl;

    //Generate a vector of random bits to transmit:
    transmitted_bits_1 = randb(Number_of_bits);
    transmitted_bits_2 = randb(Number_of_bits);

    //Modulate the bits to QPSK symbols:
    transmitted_symbols_1 = qpsk.modulate_bits(transmitted_bits_1);
    transmitted_symbols_2 = qpsk.modulate_bits(transmitted_bits_2);

    //Multiplex two signals
    transmitted_symbols = transmitted_symbols_1 * pow(alpha, 0.5) + transmitted_symbols_2 * pow(1 - alpha, 0.5);

    //Set the noise variance of the AWGN channel:
    awgn_channel.set_noise(N0(i));

    //Run the transmited symbols through the channel using the () operator:
    received_symbols = awgn_channel(transmitted_symbols);

    //Demodulate the received QPSK symbols into received bits: Layer 1
    received_bits_1 = qpsk.demodulate_bits(received_symbols);

    //Demodulate the received QPSK symbols into received bits: Layer 2
    feedback_symbols_1 = qpsk.modulate_bits(received_bits_1);
    received_bits_2 = qpsk.demodulate_bits(received_symbols - feedback_symbols_1);

    //Calculate the bit error rate:
    berc.clear();                               //Clear the bit error rate counter
    berc.count(transmitted_bits_1, received_bits_1); //Count the bit errors
    bit_error_rate_1(i) = berc.get_errorrate();   //Save the estimated BER in the result vector

    berc.clear();
    berc.count(transmitted_bits_2, received_bits_2);
    bit_error_rate_2(i) = berc.get_errorrate();

  }

  tt.toc();

  // Theoretical results for single access
  vec ber_theoretical_qpsk;
  ber_theoretical_qpsk.set_size(EbN0dB.length(), false);
  for (size_t i = 0; i < EbN0dB.length(); ++i) {
    ber_theoretical_qpsk(i) = 0.5*erfc(pow(EbN0(i), 0.5));
  }

  // Theoretical results for multiple access
  vec ber_access_1, ber_access_2;
  double SINR_symbol;
  ber_access_1.set_size(EbN0dB.length(), false);
  ber_access_2.set_size(EbN0dB.length(), false);

  for (size_t i = 0; i < EbN0dB.length(); ++i) {        //BER for access 1
    SINR_symbol = Eb*alpha / (N0(i) + Eb*(1 - alpha));
    ber_access_1(i) = 0.5*erfc(pow(SINR_symbol, 0.5));
  }
  for (size_t i = 0; i < EbN0dB.length(); ++i) {        //BER for access 2
    SINR_symbol = Eb*(1 - alpha) / N0(i);
    ber_access_2(i) = 0.5*erfc(pow(SINR_symbol, 0.5));
  }

  //Print the results:
  cout << endl;
  cout << "EbN0dB = " << EbN0dB << " [dB]" << endl;
  cout << "BER 1 = " << bit_error_rate_1 << endl;
  cout << "BER 2 = " << bit_error_rate_2 << endl;
  cout << "Theoretical BER   = " << ber_theoretical_qpsk << endl;
  cout << "Theoretical BER 1 = " << ber_access_1 << endl;
  cout << "Theoretical BER 2 = " << ber_access_2 << endl;
  cout << "Saving results to ./qpsk_result_file.it" << endl;
  cout << endl;

  //Save the results to file:
  ff.open("qpsk_result_file.it");
  ff << Name("EbN0dB") << EbN0dB;
  ff << Name("ber1") << bit_error_rate_1;
  ff << Name("ber2") << bit_error_rate_2;
  ff.close();

  //Exit program:
  return 0;

}

//Evaluate average power of given vector of symbols #M00
double eval_avg_power(const cvec& symbol_vec)
{
  //Overflow check is not implemented in this function
  bool verbose = true;
  double average_power;
  double acculmulate_power;
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





