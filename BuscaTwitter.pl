#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";
use BuscaTweet;
use Mojolicious::Lite;

get '/' => sub {
  my $self = shift;
  $self->render('index');
};

post '/result' => sub {
  my $self = shift;
  my $twitter_id = $self->param('name');
  my $sort_type = $self->param('sort');
  my $instance = BuscaTweet->new;
  my $tweets = $instance->buscar_tweets($twitter_id, $sort_type);
  $self->stash->{tweets} = $tweets;
  $self->render('result');
};

app->start;

__DATA__

@@ index.html.ep
% layout 'default';
<div id="form">
<form action="/result" method="post">
<label><input type="radio" name="sort" value="retweet" checked>Retweet&nbsp;</label>
<label><input type="radio" name="sort" value="favorite">Favorite</label><br><br>
Twitter ID: @<input type="text" name="name" placeholder="Enter here"><br><br>
<button type="submit" class="btn btn-default">Show Tweets</button>
</form>
</div>

@@ result.html.ep
% layout 'default';
<table class="tweets">
% for my $tweet(@$tweets) {
  <tr>
  <th> <img src="<%= $tweet->{user}{profile_image_url} %>"></th>
  <td><%= b($tweet->{text}) %></td>
  </tr>
% }
</table>

@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>BuscaTwitter</title>
<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
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
  width:400px;
  height:200px;
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
