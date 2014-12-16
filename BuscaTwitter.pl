#!/usr/bin/env perl

package Busca::Model;

use strict;
use warnings;
use Net::Twitter::Lite::WithAPIv1_1;

# Please rewrite to your own key
my $consumer_key = 'wwwwwwww';
my $consumer_secret = 'xxxxxxxx';
my $access_token_secret = 'yyyyyyyy';
my $access_token = 'zzzzzzzz';

sub new {
  my $class = shift;
  my $self = bless {}, $class;
  return $self;
}

sub buscar_tweets {
  my ( $self, $twitter_id ) = @_;
  my $nt = Net::Twitter::Lite::WithAPIv1_1->new(
    consumer_key => $consumer_key,
    consumer_secret => $consumer_secret,
    access_token_secret => $access_token_secret,
    access_token => $access_token,
    ssl => 1,
  );
  my $tweets = $nt->user_timeline({screen_name => $twitter_id, count => 200});
  return $tweets;
}

package main;
use Mojolicious::Lite;

app->helper(
  model => sub {
    Busca::Model->new;
  }
);

get '/' => sub {
  my $self = shift;
  $self->render('index');
};

post '/result' => sub {
  my $self = shift;
  my $twitter_id = $self->param('name');
  my $sort_type = $self->param('sort');
  my $tweets = $self->app->model->buscar_tweets($twitter_id);
  my @sorted_tweets = sort { $b->{$sort_type . "_count"} <=> $a->{$sort_type . "_count"} } @$tweets;
  $self->stash->{tweets} = \@sorted_tweets;
  $self->render('result');
};

app->start;

__DATA__

@@ index.html.ep
% layout 'default';
<div id="form">
<form action="/result" method="post">
<input type="radio" name="sort" value="retweet" checked>Retweet
<input type="radio" name="sort" value="favorite">Favorite<br><br>
Twitter ID: @<input type="text" name="name" placeholder="Enter here"><br><br>
<input type="submit" value="Show Tweets">
</form>
</div>

@@ result.html.ep
% layout 'default';
<table class="tweets">
% my $count = 1;
% for my $tweet(@$tweets) {
  % next if $tweet->{text} =~ /^@/ || $tweet->{text} =~ /^RT/;
  % $tweet->{text} =~ s/(http.+)$/<a href="$1" target="_blank">$1<\/a>/g;
  <tr>
  <th> <img src="<%= $tweet->{user}{profile_image_url} %>"></th>
  <td><%= b($tweet->{text}) %></td>
  </tr>
  % $count++;
  % last if $count > 10;
% }
</table>

@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>BuscaTwitter</title>
<style>
div#header h1 {
  font-family:"Comic Sans MS";
  padding: 10px;
}
div#header h1 a {
  color:#008000;
  text-decoration:none;
}
div#form {
  font-size:20px;
  background-color:#CCCCD0;
  border:1px solid #999999;
  padding:10px;
  border-radius:8px;
  width:300px;
  height:150px;
}
table.tweets {
  width:980px;
  border-collapse:collapse;
}
table.tweets th {
  width:50px;
  padding:10px;
  text-align:center;
  background-color:#CCCCEE;
  border-bottom:dotted #666666 1px;
}
table.tweets td {
  padding:10px;
  background-color:#EEEEFF;
  border-bottom:dotted #666666 1px;
}
</style>
</head>
<body>
<div id="header">
  <h1><a href="/">BuscaTwitter</a></h1>
</div>
<%= content %>
</body>
</html>
