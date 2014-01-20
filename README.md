# Tropo Provisioning API Ruby Library
[![Build Status](https://drone.io/github.com/tropo/tropo-provisioning/status.png)](https://drone.io/github.com/tropo/tropo-provisioning/latest)

A Ruby library for interaction with the Tropo Provisioning API (http://tropo.com) using JSON.

## Tropo Provisioning API Overview

The Provisioning API provides a programmatic method to access the Tropo Provisioning Database, which is the centralized server that contains all of your applications, phone numbers, IM network information, tokens and so on.  Previously, in order to create/delete applications, add/remove addresses (phone and SMS numbers, IM Accounts and tokens), or view available exchanges (area codes and their associated regions) you would need to log into the Tropo website and make your changes through your web browser.  That poses a problem for an external program that needs access to your account and applications.  

As an example, say you're a phone system provider - someone who creates and hosts an IVR system for doctor's offices, school systems and so on.  If you wanted to provide your customers with a method to purchase additional phone numbers via a website or similar portal, you would need to provide your purchasing system with access to our Provisioning Server to create and publish the new phone number.  Without the Provisioning API, you would have to manually log into the Tropo website, add the phone number to the application, then provide the customer with the new number directly.   With the Provisioning API, you're able to send the request directly to the Provisioning Server through your portal, create the phone number, publish it and provide it back to your customer without any manual interaction whatsoever.

## How it works

The Provisioning API is a RESTful Web Service that utilizes HTTP and JSON to allow for communication back and forth between an application and the Provisioning Server.  

## Gem Overview

The Tropo Provisioning gem provides a library for convenient access to the Tropo Provisioning API.

## Requirements

* Unit tests passed on: Ruby MRI v1.8.6/1.8.7, Ruby 1.9.2 and JRuby 1.6.3

* RubyGems: Check tropo-provisioning.gemspec

## Installation

    $ gem install tropo-provisioning

## Usage

Any HTTP method can be accessed using the TropoProvisioning wrapper:
```ruby
  require 'rubygems'
  require 'tropo-provisioning'

  tp = TropoProvisioning.new('username', 'password')
```
### Examples

#### Add a New Application
```ruby
  app_id = tp.create_application({ :name => 'My Shiny New App',
                                :voiceUrl     => 'http://mydomain.com/voice_script.rb',
                                :partition    => 'staging',
                                :messagingUrl => 'http://mydomain.com/message_script.rb',
                                :platform     => 'scripting' })
```
#### Add a Address to an Application
```ruby
  address_data = tp.create_address(app_id, { :type => 'did', :prefix => '1415' })
```
#### Delete a Address to an Application
```ruby
  result = tp.delete_address(app_id, address_data['number'])
```
#### Delete an Application
```ruby
  tp.delete_application(app_id)  
```
## Documentation

#### API Documentation:

  http://voxeo.github.com/tropo-webapi-ruby

#### Tropo Provisioning API Documentation

    git clone https://github.com/tropo/tropo-provisioning
    cd tropo-provisioning
    bundle install
    rake rdoc
	
### Local & Generating Documentation

#### Developer

  $ gemserver

#### Project Developer

Install the Yard Doc (http://yardoc.org) gem:

  $ sudo gem install yardoc

From within the project:

  $ yardoc

## Copyright

Copyright (c) 2014 Tropo, Inc. See LICENSE for details.