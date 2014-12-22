BuscaTwitter
============
BuscaTwitter is an application to extract quickly valuable tweets, like more retweeted or favorited.  
Before you launch the application, **please generate YAML file using Config::Pit::set**. 

Example

`perl -MConfig::Pit -e'Config::Pit::set("BuscaTwitter", data=>{ consumer_key => "Twitter API Key", consumer_secret => "Twitter API Key Secret", access_token_secret => "Twitter Access Token Secret", access_token => "Twitter Access Token" })'`

