#include <iostream>

#include "controller.hh"
#include "timestamp.hh"
#include <math.h>

using namespace std;

bool slow_start = true;
double the_window_size = 10.0;
double menor_acked = 99999; //Menor tempo BBR.RTProp
double menor_rtt = 99999; //salva menor rtt para avoidance

/* Default constructor */
Controller::Controller( const bool debug )
  : debug_( debug )
{}

/* Get current window size, in datagrams */
unsigned int Controller::window_size()
{
  /* Default: fixed window size of 100 outstanding datagrams */
  //unsigned int the_window_size = 100;
 
  if ( debug_ ) {
    cerr << "At time " << timestamp_ms()
	 << " window size is " << the_window_size << endl;
  }
 
  return the_window_size;
}

/* A datagram was sent */
void Controller::datagram_was_sent( const uint64_t sequence_number,
				    /* of the sent datagram */
				    const uint64_t send_timestamp,
                                    /* in milliseconds */
				    const bool after_timeout
				    /* datagram was sent because of a timeout */ )
{
  /* Default: take no action */

  if ( debug_ ) {
    cerr << "At time " << send_timestamp
	 << " sent datagram " << sequence_number << " (timeout = " << after_timeout << ")\n";
  }
}

/* An ack was received */
void Controller::ack_received( const uint64_t sequence_number_acked,
			       /* what sequence number was acknowledged */
			       const uint64_t send_timestamp_acked,
			       /* when the acknowledged datagram was sent (sender's clock) */
			       const uint64_t recv_timestamp_acked,
			       /* when the acknowledged datagram was received (receiver's clock)*/
			       const uint64_t timestamp_ack_received )
                   /* when the ack was received (by sender) */
{

//Pega o valor rtt atual
uint64_t rtt_atual = timestamp_ack_received - send_timestamp_acked;
        
//Pega o tempo de recebimento acknowledged datagram 
int64_t tmp_atual_acked = recv_timestamp_acked - send_timestamp_acked;
    
    //salva o menor acknowledged datagram 
    if (tmp_atual_acked < menor_acked) menor_acked = tmp_atual_acked;        
    
    //salva o menor rtt
    if (rtt_atual < menor_rtt) menor_rtt = rtt_atual;

    //menor_acked_rtt = Calcula a menor One Way Delay do menor rtt
    double menor_acked_rtt = (menor_rtt/2);
    //Valor One Way time
    double valor_owt = (tmp_atual_acked - menor_acked) + menor_acked_rtt;

    if (valor_owt > 1.45 * menor_acked_rtt) the_window_size -= .25;
    else the_window_size += .25;

    if (the_window_size < 2) the_window_size = 2;
    else if (the_window_size > 100) the_window_size = 100;

  /* Default: take no action */
  if ( debug_ ) {
    cerr << "At time " << timestamp_ack_received
	 << " received ack for datagram " << sequence_number_acked
	 << " (send @ time " << send_timestamp_acked
	 << ", received @ time " << recv_timestamp_acked << " by receiver's clock)"
	 << endl;
  }
}

/* How long to wait (in milliseconds) if there are no acks
   before sending one more datagram */
unsigned int Controller::timeout_ms()
{
  return 50; /* timeout of one second */
}
