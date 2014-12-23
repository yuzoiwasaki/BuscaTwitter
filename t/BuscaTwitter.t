use strict;
use Test::More;
use FindBin;
use lib "$FindBin::Bin/lib";
use BuscaTweet;

use_ok 'BuscaTweet';
my $instance = BuscaTweet->new;
isa_ok $instance, 'BuscaTweet';
my $r_tweets = $instance->buscar_tweets('ganchan0929', 'retweet');
ok $r_tweets;
my $f_tweets = $instance->buscar_tweets('ganchan0929', 'favorite');
ok $f_tweets;

done_testing();
