# AdsPubSub

This Gem should be a simple interface to PubSub or Messaging Systems. The idea is to have 2 public methods: `publish` and `subscribe` with which the apps will interact.

Currentl only GooglePubSub adapter exists.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ads_pub_sub', git: "amco/ads_pub_sub"
```

And then execute:

    $ bundle install

## Usage

Initialize a pubsub with:

```
AdsPubSub::Base.new(config_obj, adapter)
```

The adapter can be left out and will default to :google.
Currently only GooglePubSub adapter is implemented.

the config object will depend on the Adapter and is a hash with the values required by the Adapter to work.

On Google PubSub this values are:

**keyfile** Refers to the local path where the service account JSON auth file is stored.
**project_id** Is the project id with PubSub access.
**scope** Is the list of scopes required for auth access to the service account.
