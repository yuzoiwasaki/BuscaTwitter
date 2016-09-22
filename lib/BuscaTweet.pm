package BuscaTweet;

use strict;
use warnings;
use Net::Twitter::Lite::WithAPIv1_1;
use Config::Pit;
use HTML::Escape qw/escape_html/;

my $config = pit_get('BuscaTwitter', require => {
  'consumer_key' => 'Twitter API Key',
  'consumer_secret' => 'Twitter API Key Secret',
  'access_token_secret' => 'Twitter Access Token Secret',
  'access_token' => 'Twitter Access Token',
});

sub new {
  my $class = shift;
  my $self = bless {}, $class;
  return $self;
}

sub buscar_tweets {
  my ( $self, $twitter_id, $sort_type ) = @_;
  my $nt = Net::Twitter::Lite::WithAPIv1_1->new(
    consumer_key => $config->{consumer_key},
    consumer_secret => $config->{consumer_secret},
    access_token_secret => $config->{access_token_secret},
    access_token => $config->{access_token},
    ssl => 1,
  );
  my $tweets = $nt->user_timeline({screen_name => $twitter_id, count => 200});
  my $prepared_tweets = [];
  for my $tweet(@$tweets) {
    next if $tweet->{text} =~ /^@/ || $tweet->{text} =~ /^RT/;
    $tweet->{text} = escape_html($tweet->{text});
    $tweet->{text} =~ s/\b(https?\S+)/<a href="$1" target="_blank">$1<\/a>/g;
    push @$prepared_tweets, $tweet;
  }
  my @sorted_tweets = sort { $b->{$sort_type . "_count"} <=> $a->{$sort_type . "_count"} } @$prepared_tweets;
  my $ten_tweets = [];
  my $count = 1;
  for my $sorted_tweet(@sorted_tweets) {
    push @$ten_tweets, $sorted_tweet;
    last if $count >= 10;
    $count++;
  }
  return $ten_tweets;
}

1;
