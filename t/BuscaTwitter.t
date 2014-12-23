use strict;
use Test::More;
use FindBin;
use lib "$FindBin::Bin/lib";
use BuscaTweet;

use_ok('BuscaTweet');
my $instance = BuscaTweet->new;
isa_ok $instance, 'BuscaTweet';
my $tweets = $instance->buscar_tweets('ganchan0929', 'retweet');
ok $tweets;

done_testing();
