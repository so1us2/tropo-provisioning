require 'spec_helper'

# These tests are all local unit tests
FakeWeb.allow_net_connect = false

describe "TropoProvisioning" do
  let(:applications) do
    [ { "region" => "I-US",
        "city"     => "iNum US",
        "number"   => "883510001812716",
        "href"     => "http://api.tropo.com/v1/applications/108000/addresses/number/883510001812716",
        "prefix"   => "008",
        "type"     => "number" },
      { "number"   => "9991436301",
        "href"     => "http://api.tropo.com/v1/applications/108000/addresses/pin/9991436300",
        "type"     => "pin" },
      { "href"     => "http://api.tropo.com/v1/applications/108000/addresses/jabber/xyz123",
        "nickname" => "",
        "username" => "xyz123",
        "type"     => "jabber" },
      { "href"     => "http://api.tropo.com/v1/applications/108000/addresses/jabber/xyz123",
        "nickname" => "",
        "username" => "9991436300",
        "type"     => "pin" },
      { "href"     => "http://api.tropo.com/v1/applications/108000/addresses/token/a1b2c3d4",
        "nickname" => "",
        "username" => "a1b2c3d4",
        "type"     => "token" } ]
  end

  before(:all) do
    @addresses = [ { "region" => "I-US",
                     "city"     => "iNum US",
                     "number"   => "883510001812716",
                     "href"     => "http://api.tropo.com/v1/applications/108000/addresses/number/883510001812716",
                     "prefix"   => "008",
                     "type"     => "number" },
                   { "number"   => "9991436301",
                     "href"     => "http://api.tropo.com/v1/applications/108000/addresses/pin/9991436300",
                     "type"     => "pin" },
                   { "href"     => "http://api.tropo.com/v1/applications/108000/addresses/jabber/xyz123",
                     "nickname" => "",
                     "username" => "xyz123",
                     "type"     => "jabber" },
                   { "href"     => "http://api.tropo.com/v1/applications/108000/addresses/jabber/xyz123",
                     "nickname" => "",
                     "username" => "9991436300",
                     "type"     => "pin" },
                   { "href"     => "http://api.tropo.com/v1/applications/108000/addresses/token/a1b2c3d4",
                     "nickname" => "",
                     "username" => "a1b2c3d4",
                     "type"     => "token" } ]


    @new_user      = { 'user_id' => "12345", 'href' => "http://api.tropo.com/v1/users/12345", 'confirmation_key' => '1234' }
    @new_user_json = ActiveSupport::JSON.encode({ 'user_id' => "12345", 'href' => "http://api.tropo.com/v1/users/12345", 'confirmationKey' => '1234' })
    @existing_user = { "city"         => "Orlando",
                       "address"      => "1234 Anywhere St",
                       "href"         => "https://api-smsified-eng.voxeo.net/v1/users/12345",
                       "lastName"     => "User",
                       "address2"     => "Unit 1337",
                       "joinDate"     => "2010-05-17T18:26:07.217+0000",
                       "country"      => "USA",
                       "username"     => "foo",
                       "phoneNumber"  => "4075551212",
                       "id"           => "12345",
                       "postalCode"   => "32801",
                       "jobTitle"     => "Technical Writer",
                       "firstName"    => "Tropo",
                       "organization" => "Voxeo",
                       "status"       => "active",
                       "email"        => "support@tropo.com"}


    @list_account = { 'account_id' => "12345", 'href' => "http://api-eng.voxeo.net:8080/v1/users/12345" }

    @payment_method = { "rechargeAmount"    => "0.00",
                        "paymentType"       => "https://api-smsified-eng.voxeo.net/v1/types/payment/1",
                        "accountNumber"     => "5555",
                        "paymentTypeName"   => "visa",
                        "rechargeThreshold" => "0.00",
                        "id"                => "1" }

    @payment_methods = [ { "name" => "visa",
                           "href" => "https://api-smsified-eng.voxeo.net/v1/types/payment/1",
                           "id"   => "1" },
                         { "name" => "mastercard",
                           "href" => "https://api-smsified-eng.voxeo.net/v1/types/payment/2",
                           "id"   => "2" },
                         { "name" => "amex",
                           "href" => "https://api-smsified-eng.voxeo.net/v1/types/payment/3",
                           "id"   => "3" }]

    @features = [ { "name"        => "International Outbound SMS",
                    "href"        => "https://api-smsified-eng.voxeo.net/v1/features/9",
                    "id"          => "9",
                    "description" => "International Outbound SMS" },
                  { "name"        => "Test Outbound SMS",
                    "href"        => "https://api-smsified-eng.voxeo.net/v1/features/7",
                    "id"          => "7",
                    "description" => "Test Outbound SMS" },
                  { "name"        => "Domestic Outbound SMS",
                    "href"        => "https://api-smsified-eng.voxeo.net/v1/features/8",
                    "id"          => "8",
                    "description" => "Domestic Outbound SMS" } ]

    @user_features = [ { "feature"     => "https://api-smsified-eng.voxeo.net/v1/features/7",
                         "href"        => "https://api-smsified-eng.voxeo.net/v1/users/12345/features/7",
                         "featureName" => "Test Outbound SMS" } ]

    @feature = { 'href' => 'http://api-smsified-eng.voxeo.net/v1/users/12345/features/8' }

    @feature_delete_message = { "message" => "disabled feature https://api-smsified-eng.voxeo.net/v1/features/8 for user https://api-smsified-eng.voxeo.net/v1/users/12345" }

    @payment_info_message = { "href" => "http://api-smsified-eng.voxeo.net/v1/users/12345/payment/method" }

    @bad_account_creds =  { "account-accesstoken-get-response" =>
                            { "accessToken"   => "",
                              "statusMessage" => "Invalid login.",
                              "statusCode"    => 403 } }

    @search_accounts = [ { "href"           => "http://api-smsified-eng.voxeo.net/v1/users/53209",
                           "marketingOptIn" => true,
                           "lastName"       => "Empty LastName",
                           "joinDate"       => "2010-11-15T21:13:23.837+0000",
                           "username"       => "foobar5331",
                           "id"             => "53209",
                           "phoneNumber"    => "Empty Phone",
                           "firstName"      => "Empty FirstName",
                           "status"         => "active",
                           "email"          => "jsgoecke@voxeo.com"},
                         { "href"           => "http://api-smsified-eng.voxeo.net/v1/users/53211",
                           "marketingOptIn" => true,
                           "lastName"       => "Empty LastName",
                           "joinDate"       => "2010-11-15T21:17:24.473+0000",
                           "username"       => "foobar1197",
                           "id"             => "53211",
                           "phoneNumber"    => "Empty Phone",
                           "firstName"      => "Empty FirstName",
                           "status"         => "active",
                           "email"          => "jsgoecke@voxeo.com" } ]

    @partitions = [{ "name" => "staging", "href" => "https://api-smsified-eng.voxeo.net/v1/partitions/staging" },
                   { "name" => "production", "href" => "https://api-smsified-eng.voxeo.net/v1/partitions/production" }]

    @platforms = [{ "name" => "sms", "href" => "https://api-smsified-eng.voxeo.net/v1/platforms/sms", "description" => "SMSified Interface" }]

    @balance = { "pendingUsageAmount" => "0.00", "pendingRechargeAmount" => "0.00", "balance" => "3.00" }

    @whitelist = [{ "href" => "https://api-smsified-eng.voxeo.net/v1/partitions/staging/platforms/sms/whitelist/14075551212", "value"=>"14075551212" }]

    @countries = [{ "name"=>"Zimbabwe", "href"=>"http://api-smsified-eng.voxeo.net/v1/countries/426", "code"=>"ZW", "id" => "426" },
                  { "name"=>"United States", "href"=>"http://api-smsified-eng.voxeo.net/v1/countries/36", "code"=>"US", "states"=>"http://api-smsified-eng.voxeo.net/v1/countries/36/states", "id" => "36" }]

    @states = [{ "name"=>"Wisconsin", "href"=>"http://api-smsified-eng.voxeo.net/v1/countries/36/states/49", "code"=>"WI", "id" => "49" },
               { "name"=>"Wyoming", "href"=>"http://api-smsified-eng.voxeo.net/v1/countries/36/states/50", "code"=>"WY", "id"=>"50" }]

    @recurrence = { 'rechargeAmount' => 13.50, 'rechargeThreshold' => 10.00 }
    @recurrence_updated = { 'href' => 'http://api-smsified-eng.voxeo.net/v1/users/1234/payment/recurrence' }

    # Register our resources

    # Applications with a bad uname/passwd
    FakeWeb.register_uri(:get,
                         %r|http://bad:password@api.tropo.com/v1/applications|,
                         :status => ["401", "Unauthorized"])

    # Alternate Base URI
    FakeWeb.register_uri(:get,
                         "http://foo:bar@testserver.com/rest/v1/users/foo",
                         :body => '{}',
                         :content_type => "application/json",
                         :status => ["200", "OK"])


    # A specific application
    FakeWeb.register_uri(:get,
                         "http://foo:bar@api.tropo.com/v1/applications/108000",
                         :body => ActiveSupport::JSON.encode(applications[0]),
                         :content_type => "application/json")

    # Applications
    FakeWeb.register_uri(:get,
                         %r|https://foo:bar@api.tropo.com/v1/applications|,
                         :body => ActiveSupport::JSON.encode(applications),
                         :content_type => "application/json")

    # Create an application
    FakeWeb.register_uri(:post,
                         %r|https://foo:bar@api.tropo.com/v1/applications|,
                         :body => ActiveSupport::JSON.encode({ "href" => "http://api.tropo.com/v1/applications/108016" }),
                         :status => ["200", "OK"])

    # Update a specific application
    FakeWeb.register_uri(:put,
                         %r|https://foo:bar@api.tropo.com/v1/applications/108000|,
                         :body => ActiveSupport::JSON.encode({ "href" => "http://api.tropo.com/v1/applications/108016" }),
                         :status => ["200", "OK"])

    # Addresses
    FakeWeb.register_uri(:get,
                         "http://foo:bar@api.tropo.com/v1/applications/108000/addresses",
                         :body => ActiveSupport::JSON.encode(@addresses),
                         :content_type => "application/json")

    # Get a specific address
    FakeWeb.register_uri(:get,
                         "https://foo:bar@api.tropo.com/v1/applications/108000/addresses/number/883510001812716",
                         :body => ActiveSupport::JSON.encode(@addresses[0]),
                         :content_type => "application/json")

    # Get a address that is an IM/username
    FakeWeb.register_uri(:get,
                         "https://foo:bar@api.tropo.com/v1/applications/108000/addresses/jabber/xyz123",
                         :body => ActiveSupport::JSON.encode(@addresses[2]),
                         :content_type => "application/json")

    # Get a address that is a token
    FakeWeb.register_uri(:get,
                         "https://foo:bar@api.tropo.com/v1/applications/108000/addresses/jabber/xyz123",
                         :body => ActiveSupport::JSON.encode(@addresses[2]),
                         :content_type => "application/json")

    # Get a address that is a Pin
    FakeWeb.register_uri(:post,
                         "http://foo:bar@api.tropo.com/v1/applications/108000/addresses",
                         :body => ActiveSupport::JSON.encode(@addresses[2]),
                         :content_type => "application/json")

    # Get a address that is a token
    FakeWeb.register_uri(:get,
                         "https://foo:bar@api.tropo.com/v1/applications/108000/addresses/token/a1b2c3d4",
                         :body => ActiveSupport::JSON.encode(@addresses[4]),
                         :content_type => "application/json")

    # Get a address that is a number
    FakeWeb.register_uri(:post,
                         "https://foo:bar@api.tropo.com/v1/applications/108000/addresses",
                         :body => ActiveSupport::JSON.encode({ "href" => "http://api.tropo.com/v1/applications/108000/addresses/number/7202551912" }),
                         :content_type => "application/json")

    # Create a address that is an IM account
    FakeWeb.register_uri(:post,
                         "https://foo:bar@api.tropo.com/v1/applications/108001/addresses",
                         :body => ActiveSupport::JSON.encode({ "href" => "http://api.tropo.com/v1/applications/108001/addresses/jabber/xyz123@bot.im" }),
                         :content_type => "application/json")

    # Create a address that is a Token
    FakeWeb.register_uri(:post,
                         "https://foo:bar@api.tropo.com/v1/applications/108002/addresses",
                         :body => ActiveSupport::JSON.encode({ "href" => "http://api.tropo.com/v1/applications/108002/addresses/token/12345679f90bac47a05b178c37d3c68aaf38d5bdbc5aba0c7abb12345d8a9fd13f1234c1234567dbe2c6f63b" }),
                         :content_type => "application/json")

    # Delete an application
    FakeWeb.register_uri(:delete,
                         "https://foo:bar@api.tropo.com/v1/applications/108000",
                         :body => ActiveSupport::JSON.encode({ 'message' => 'delete successful' }),
                         :content_type => "application/json",
                         :status => ["200", "OK"])

    # Exchanges
    FakeWeb.register_uri(:get,
                         "https://foo:bar@api.tropo.com/v1/exchanges",
                         :body => exchanges,
                         :status => ["200", "OK"],
                         :content_type => "application/json")

    # Delete a address
    FakeWeb.register_uri(:delete,
                         "https://foo:bar@api.tropo.com/v1/applications/108000/addresses/number/883510001812716",
                         :body => ActiveSupport::JSON.encode({ 'message' => 'delete successful' }),
                         :content_type => "application/json",
                         :status => ["200", "OK"])

    # Add a specific address
    FakeWeb.register_uri(:post,
                         "https://foo:bar@api.tropo.com/v1/applications/108002/addresses/number/883510001812716",
                         :body => ActiveSupport::JSON.encode({ 'message' => 'delete successful' }),
                         :content_type => "application/json",
                         :status => ["200", "OK"])

    # Create a new user
    FakeWeb.register_uri(:post,
                         "https://foo:bar@api.tropo.com/v1/users",
                         :body => @new_user_json,
                         :content_type => "application/json",
                         :status => ["200", "OK"])

    # Get a specific user by user_id
    FakeWeb.register_uri(:get,
                         "https://foo:bar@api.tropo.com/v1/users/12345",
                         :body => ActiveSupport::JSON.encode(@existing_user),
                         :content_type => "application/json",
                         :status => ["200", "OK"])

    # Get a specific user by user_id
    FakeWeb.register_uri(:get,
                         "https://foo:bar@api.tropo.com/v1/users/98765",
                         :body => nil,
                         :content_type => "application/json",
                         :status => ["404", "Got an error here!"])

    # Get a specific user by username
    FakeWeb.register_uri(:get,
                         "https://foo:bar@api.tropo.com/v1/users/foo",
                         :body => ActiveSupport::JSON.encode(@existing_user),
                         :content_type => "application/json",
                         :status => ["200", "OK"])

    # Get a specific user by username with HTTPS/SSL
    FakeWeb.register_uri(:get,
                         "https://foo:bar@api.tropo.com/v1/users/foo",
                         :body => ActiveSupport::JSON.encode(@existing_user),
                         :content_type => "application/json",
                         :status => ["200", "OK"])

    # Invalid credentials
    FakeWeb.register_uri(:get,
                         "https://bad:password@api.tropo.com/v1/users/bad",
                         :content_type => "application/json",
                         :status => ["401", "Unauthorized"])

    # Confirm an account account
    FakeWeb.register_uri(:post,
                         "https://foo:bar@api.tropo.com/v1/users/12345/confirmations",
                         :body => ActiveSupport::JSON.encode({"message" => "successfully confirmed user 12345" }),
                         :content_type => "application/json",
                         :status => ["200", "OK"])

    # Return the payment method configured for a user
    FakeWeb.register_uri(:get,
                         "https://foo:bar@api.tropo.com/v1/users/12345/payment/method",
                         :body => ActiveSupport::JSON.encode(@payment_method),
                         :content_type => "application/json",
                         :status => ["200", "OK"])

    # Return payment types
    FakeWeb.register_uri(:get,
                         "https://foo:bar@api.tropo.com/v1/types/payment",
                         :body => ActiveSupport::JSON.encode(@payment_methods),
                         :content_type => "application/json",
                         :status => ["200", "OK"])

    # Return features
    FakeWeb.register_uri(:get,
                         "https://foo:bar@api.tropo.com/v1/features",
                         :body => ActiveSupport::JSON.encode(@features),
                         :content_type => "application/json",
                         :status => ["200", "OK"])

    # Return features for a user
    FakeWeb.register_uri(:get,
                         "https://foo:bar@api.tropo.com/v1/users/12345/features",
                         :body => ActiveSupport::JSON.encode(@user_features),
                         :content_type => "application/json",
                         :status => ["200", "OK"])

    # Add a feature to a user
    FakeWeb.register_uri(:post,
                         "https://foo:bar@api.tropo.com/v1/users/12345/features",
                         :body => ActiveSupport::JSON.encode(@feature),
                         :content_type => "application/json",
                         :status => ["200", "OK"])

    # Add a feature to a user
    FakeWeb.register_uri(:delete,
                         "https://foo:bar@api.tropo.com/v1/users/12345/features/8",
                         :body => ActiveSupport::JSON.encode(@feature_delete_message),
                         :content_type => "application/json",
                         :status => ["200", "OK"])

    # Add payment info to a user
    FakeWeb.register_uri(:put,
                         "https://foo:bar@api.tropo.com/v1/users/12345/payment/method",
                         :body => ActiveSupport::JSON.encode(@payment_info_message),
                         :content_type => "application/json",
                         :status => ["200", "OK"])


    # List an account, with bad credentials
    FakeWeb.register_uri(:get,
                         "https://evolution.voxeo.com/api/account/accesstoken/get.jsp?username=foobar7474&password=fooeyfooey",
                         :body => ActiveSupport::JSON.encode(@bad_account_creds),
                         :content_type => "application/json",
                         :status => ["403", "Invalid Login."])

    # Get our search terms
    FakeWeb.register_uri(:get,
                         "https://foo:bar@api.tropo.com/v1/users/?username=foobar",
                         :body => ActiveSupport::JSON.encode(@search_accounts),
                         :content_type => "application/json",
                         :status => ["200", "OK"])

    # Payment resource
    FakeWeb.register_uri(:post,
                         "https://foo:bar@api.tropo.com/v1/users/1234/payments",
                         :body => ActiveSupport::JSON.encode({ :message => "successfully posted payment for the amount 1.000000" }),
                         :content_type => "application/json",
                         :status => ["200", "OK"])

    # Modify a user
    FakeWeb.register_uri(:put,
                         "https://foo:bar@api.tropo.com/v1/users/12345",
                         :body => ActiveSupport::JSON.encode({ :href => "http://api-smsified-eng.voxeo.net/v1/users/12345" }),
                         :content_type => "application/json",
                         :status => ["200", "OK"])

    # List available partitions
    FakeWeb.register_uri(:get,
                         "https://foo:bar@api.tropo.com/v1/partitions",
                         :body => ActiveSupport::JSON.encode(@partitions),
                         :content_type => "application/json",
                         :status => ["200", "OK"])

    # List available platforms
    FakeWeb.register_uri(:get,
                         "https://foo:bar@api.tropo.com/v1/partitions/staging/platforms",
                         :body => ActiveSupport::JSON.encode(@platforms),
                         :content_type => "application/json",
                         :status => ["200", "OK"])

    # List balance
    FakeWeb.register_uri(:get,
                         "https://foo:bar@api.tropo.com/v1/users/12345/usage",
                         :body => ActiveSupport::JSON.encode(@balance),
                         :content_type => "application/json",
                         :status => ["200", "OK"])

    # Whitelist
    FakeWeb.register_uri(:get,
                         "https://foo:bar@api.tropo.com/v1/users/12345/partitions/production/platforms/sms/whitelist",
                         :body => ActiveSupport::JSON.encode(@whitelist),
                         :content_type => "application/json",
                         :status => ["200", "OK"])
    # Whitelist
    FakeWeb.register_uri(:get,
                         "https://foo:bar@api.tropo.com/v1/users/partitions/production/platforms/sms/whitelist",
                         :body => ActiveSupport::JSON.encode(@whitelist),
                         :content_type => "application/json",
                         :status => ["200", "OK"])

    # Whitelist create
    FakeWeb.register_uri(:post,
                         "https://foo:bar@api.tropo.com/v1/users/12345/partitions/production/platforms/sms/whitelist",
                         :body => ActiveSupport::JSON.encode(@whitelist),
                         :content_type => "application/json",
                         :status => ["200", "OK"])
    # Whitelist delete
    FakeWeb.register_uri(:delete,
                         "https://foo:bar@api.tropo.com/v1/users/12345/partitions/production/platforms/sms/whitelist/14155551212",
                         :body => ActiveSupport::JSON.encode(@whitelist),
                         :content_type => "application/json",
                         :status => ["200", "OK"])

    # Countries
    FakeWeb.register_uri(:get,
                         "https://foo:bar@api.tropo.com/v1/countries",
                         :body => ActiveSupport::JSON.encode(@countries),
                         :content_type => "application/json",
                         :status => ["200", "OK"])

    # States
    FakeWeb.register_uri(:get,
                         "https://foo:bar@api.tropo.com/v1/countries/36/states",
                         :body => ActiveSupport::JSON.encode(@states),
                         :content_type => "application/json",
                         :status => ["200", "OK"])

    # Recurrency get
    FakeWeb.register_uri(:get,
                         "https://foo:bar@api.tropo.com/v1/users/1234/payment/recurrence",
                         :body => ActiveSupport::JSON.encode(@recurrence),
                         :content_type => "application/json",
                         :status => ["200", "OK"])

    # Recurrency update
    FakeWeb.register_uri(:put,
                         "https://foo:bar@api.tropo.com/v1/users/1234/payment/recurrence",
                         :body => ActiveSupport::JSON.encode(@recurrence_updated),
                         :content_type => "application/json",
                         :status => ["200", "OK"])

    @invitation_created = { 'href' => "http://api-smsified-eng.voxeo.net/v1/invitations/ABC457" }
    @deleted_invitation = { 'message' => "deleted invitation at uri http://api-smsified-eng.voxeo.net/v1/invitations/ABC457" }
    @invitations = [ { 'code' => "ABC456", 'count' => 100, 'credit' => "10.00", 'href' => "http://api-smsified-eng.voxeo.net/v1/invitations/ABC456" },
                     { 'code' => "ABC457", 'count' => 100, 'credit' => "10.00", 'href' => "http://api-smsified-eng.voxeo.net/v1/invitations/ABC457" }]

    # List invitations
    FakeWeb.register_uri(:get,
                         "https://foo:bar@api.tropo.com/v1/invitations",
                         :body => ActiveSupport::JSON.encode(@invitations),
                         :content_type => "application/json",
                         :status => ["200", "OK"])

    # Get an invitation
    FakeWeb.register_uri(:get,
                         "https://foo:bar@api.tropo.com/v1/invitations/ABC457",
                         :body => ActiveSupport::JSON.encode(@invitations[1]),
                         :content_type => "application/json",
                         :status => ["200", "OK"])

    # Update an invitation
    FakeWeb.register_uri(:put,
                         "https://foo:bar@api.tropo.com/v1/invitations/ABC457",
                         :body => ActiveSupport::JSON.encode(@invitation_created),
                         :content_type => "application/json",
                         :status => ["200", "OK"])

    # Update an invitation
    FakeWeb.register_uri(:put,
                         "https://foo:bar@api.tropo.com/v1/users/15909/invitations/ABC457",
                         :body => ActiveSupport::JSON.encode(@invitation_created),
                         :content_type => "application/json",
                         :status => ["200", "OK"])

    # Delete an invitation
    FakeWeb.register_uri(:delete,
                         "https://foo:bar@api.tropo.com/v1/invitations/ABC457",
                         :body => ActiveSupport::JSON.encode(@deleted_invitation),
                         :content_type => "application/json",
                         :status => ["200", "OK"])

    # Delete an invitation
    FakeWeb.register_uri(:delete,
                         "https://foo:bar@api.tropo.com/v1/users/15909/invitations/ABC457",
                         :body => ActiveSupport::JSON.encode(@deleted_invitation),
                         :content_type => "application/json",
                         :status => ["200", "OK"])

    # Create invitation
    FakeWeb.register_uri(:post,
                         "https://foo:bar@api.tropo.com/v1/invitations",
                         :body => ActiveSupport::JSON.encode(@invitation_created),
                         :content_type => "application/json",
                         :status => ["200", "OK"])

    # Create invitation
    FakeWeb.register_uri(:post,
                         "https://foo:bar@api.tropo.com/v1/users/15909/invitations",
                         :body => ActiveSupport::JSON.encode(@invitation_created),
                         :content_type => "application/json",
                         :status => ["200", "OK"])

    # List invitation for a user
    FakeWeb.register_uri(:get,
                         "https://foo:bar@api.tropo.com/v1/users/15909/invitations",
                         :body => ActiveSupport::JSON.encode([@invitation_created]),
                         :content_type => "application/json",
                         :status => ["200", "OK"])

    # List invitation for a user via SSL
    FakeWeb.register_uri(:get,
                         "https://foo:bar@api.tropo.com/v1/invitations",
                         :body => ActiveSupport::JSON.encode(@invitations),
                         :content_type => "application/json",
                         :status => ["200", "OK"])

    # List invitation for a user
    FakeWeb.register_uri(:get,
                         "https://foo:bar@api.tropo.com/v1/users/15909/invitations/ABC457",
                         :body => ActiveSupport::JSON.encode(@invitations[1]),
                         :content_type => "application/json",
                         :status => ["200", "OK"])

    @username_check = { 'available' => false, 'href' => "http://api.smsified.com/v1/usernames/jsgoecke", 'valid' => true }
    # List invitation for a user
    FakeWeb.register_uri(:get,
                         "https://foo:bar@api.tropo.com/v1/usernames/12345",
                         :body => ActiveSupport::JSON.encode(@username_check),
                         :content_type => "application/json",
                         :status => ["200", "OK"])
  end

  let(:tropo_provisioning) do
    TropoProvisioning.new('foo', 'bar')
  end

  let(:exchanges) do
    '[
       {
          "prefix":"1407",
          "city":"Orlando",
          "state":"FL",
          "country":    "United States"
       },
       {
          "prefix":"1312",
          "city":"Chicago",
          "state":"IL",
              "country":"United States"
       },
       {
          "prefix":"1303",
          "city":"Denver",
              "state":"CO",
          "country":"United States"
       },
       {
          "prefix":"1310",
          "city":    "Los Angeles",
          "state":"CA",
          "country":"United States"
       },
       {
          "prefix":    "1412",
          "city":"Pittsburgh",
          "state":"PA",
          "country":    "United States"
       },
       {
          "prefix":"1415",
          "city":"San Francisco",
          "state":    "CA",
          "country":"United States"
       },
       {
          "prefix":"1206",
          "city":    "Seattle",
          "state":"WA",
          "country":"United States"
       },
       {
          "prefix":    "1301",
          "city":"Washington",
          "state":"DC",
          "country":    "United States"
       }
    ]'
  end

  it "should create a TropoProvisioning object" do
    tropo_provisioning.instance_of?(TropoProvisioning).should == true
  end

  it "should validate SSL by default" do
    tropo_provisioning.verify_certificate.should == true
  end


  it "should not validate SSL when told to" do
    tp = TropoProvisioning.new('foo', 'bar', {:verify_certificate => false })
    tp.verify_certificate.should == false
  end



  describe 'authentication' do
    it "should get an unathorized back if there is an invalid username or password" do
      begin
        bad_credentials = TropoProvisioning.new('bad', 'password')
      rescue => e
        e.to_s.should == '401: Unauthorized - '
      end
    end

    it 'should have the user data on the object if a successful login' do
      provisioning = TropoProvisioning.new('foo', 'bar')
      provisioning.user_data['username'].should == 'foo'
    end

    it 'should take a base_url' do
      provisioning = TropoProvisioning.new('foo', 'bar', :base_uri => "http://testserver.com/rest/v1")
      provisioning.base_uri.should == "http://testserver.com/rest/v1/"
    end

    it 'should sanatize a dirty base_url' do
      provisioning = TropoProvisioning.new('foo', 'bar', :base_uri => "http://testserver.com/rest/v1//////")
      provisioning.base_uri.should == "http://testserver.com/rest/v1/"
    end

    it "should not provide a token for an existing account if wrong credentials" do
      pending('Need to work on tests for the new account')
      begin
        result = tropo_provisioning.account("foobar7474", 'fooeyfooey')
      rescue => e
        e.to_s.should == "403 - Invalid Login."
      end
    end

    it "should provide a token for an existing account" do
      pending('Need to work on tests for the new account')
      result = tropo_provisioning.account("foobar7474", 'fooey')
      result.should == @list_account
    end
  end

  describe 'applications' do
    it "should get a list of applications" do
      _applications = []
      applications.each { |app| _applications << app.merge({ 'application_id' => app['href'].split('/').last }) }

      tropo_provisioning.applications.should == _applications
    end

    it "should get a specific application" do
      response = tropo_provisioning.application '108000'
      response['href'].should == applications[0]['href']
    end

    it "should raise ArgumentErrors if appropriate arguments are not specified" do
      begin
        tropo_provisioning.create_application({ :foo => 'bar' })
      rescue => e
        e.to_s.should == ':name is a required parameter'
      end
    end

    it "should raise ArgumentErrors if appropriate values are not passed" do
      begin
        tropo_provisioning.create_application({ :name         => 'foobar',
                                                :partition    => 'foobar',
                                                :platform     => 'foobar',
                                                :messagingUrl => 'http://foobar' })
      rescue => e
        e.to_s.should == ":platform must be 'scripting' or 'webapi'"
      end

      begin
        tropo_provisioning.create_application({ :name         => 'foobar',
                                                :partition    => 'foobar',
                                                :platform     => 'scripting',
                                                :messagingUrl => 'http://foobar' })
      rescue => e
        e.to_s.should == ":partition must be 'staging' or 'production'"
      end
    end

    it "should receive an href back when we create a new application receiving an href back" do
      # With camelCase
      result = tropo_provisioning.create_application({ :name         => 'foobar',
                                                       :partition    => 'production',
                                                       :platform     => 'scripting',
                                                       :messagingUrl => 'http://foobar' })
      result.href.should == "http://api.tropo.com/v1/applications/108016"
      result.application_id.should == '108016'

      # With underscores
      result = tropo_provisioning.create_application({ :name          => 'foobar',
                                                       :partition     => 'production',
                                                       :platform      => 'scripting',
                                                       :messaging_url => 'http://foobar' })
      result.href.should == "http://api.tropo.com/v1/applications/108016"
      result.application_id.should == '108016'
    end

    it "should receive an href back when we update an application receiving an href back" do
      # With camelCase
      result = tropo_provisioning.update_application('108000', { :name         => 'foobar',
                                                                 :partition    => 'production',
                                                                 :platform     => 'scripting',
                                                                 :messagingUrl => 'http://foobar' })
      result.href.should == "http://api.tropo.com/v1/applications/108016"

      # With underscore
      result = tropo_provisioning.update_application('108000', { :name          => 'foobar',
                                                                 :partition     => 'production',
                                                                 :platform      => 'scripting',
                                                                 :messaging_url => 'http://foobar' })
      result.href.should == "http://api.tropo.com/v1/applications/108016"
    end

    it "should delete an application" do
      result = tropo_provisioning.delete_application('108000')
      result.message.should == 'delete successful'
    end
  end

  describe 'addresses' do
    it "should list all of the addresses available for an application" do
      result = tropo_provisioning.addresses('108000')
      result.should == @addresses
    end

    it "should list a single address when requested with a number for numbers" do
      result = tropo_provisioning.address('108000', '883510001812716')
      result.should == @addresses[0]
    end

    it "should list a single address of the appropriate type when requested" do
      # First a number
      result = tropo_provisioning.address('108000', '883510001812716')
      result.should == @addresses[0]

      # Then an IM username
      result = tropo_provisioning.address('108000', 'xyz123')
      result.should == @addresses[2]

      # Then a pin
      result = tropo_provisioning.address('108000', '9991436300')
      result.should == @addresses[3]

      # Then a token
      result = tropo_provisioning.address('108000', 'a1b2c3d4')
      result.should == @addresses[4]
    end

    it "should generate an error of the addition of the address does not have a required field" do
      # Add a address without a type
      begin
        tropo_provisioning.create_address('108000')
      rescue => e
        e.to_s.should == ":type is a required parameter"
      end

      # Add a number without a prefix
      begin
        tropo_provisioning.create_address('108000', { :type => 'number' })
      rescue => e
        e.to_s.should == ":prefix required to add a number address"
      end

      # Add a jabber without a username
      begin
        tropo_provisioning.create_address('108000', { :type => 'jabber' })
      rescue => e
        e.to_s.should == ":username is a required parameter"
      end

      # Add an aim without a password
      begin
        tropo_provisioning.create_address('108000', { :type => 'aim', :username => 'joeblow@aim.com' })
      rescue => e
        e.to_s.should == ":password is a required parameter"
      end

      # Add a token without a channel
      begin
        tropo_provisioning.create_address('108000', { :type => 'token' })
      rescue => e
        e.to_s.should == ":channel is a required parameter"
      end

      # Add a token with an invalid channel type
      begin
        tropo_provisioning.create_address('108000', { :type => 'token', :channel => 'BBC' })
      rescue => e
        e.to_s.should == ":channel must be voice or messaging"
      end
    end

    it "should add appropriate number address" do
      # Add a address based on a prefix
      result = tropo_provisioning.create_address('108000', { :type => 'number', :prefix => '1303' })
      result[:href].should == "http://api.tropo.com/v1/applications/108000/addresses/number/7202551912"
      result[:address].should == '7202551912'
    end

    it "should add appropriate jabber address" do
      # Add a jabber account
      result = tropo_provisioning.create_address('108001', { :type => 'jabber', :username => 'xyz123@bot.im' })
      result[:href].should == "http://api.tropo.com/v1/applications/108001/addresses/jabber/xyz123@bot.im"
      result[:address].should == 'xyz123@bot.im'
    end

    it "should add appropriate token address" do
      # Add a token
      result = tropo_provisioning.create_address('108002', { :type => 'token', :channel => 'voice' })
      result[:href].should == "http://api.tropo.com/v1/applications/108002/addresses/token/12345679f90bac47a05b178c37d3c68aaf38d5bdbc5aba0c7abb12345d8a9fd13f1234c1234567dbe2c6f63b"
      result[:address].should == '12345679f90bac47a05b178c37d3c68aaf38d5bdbc5aba0c7abb12345d8a9fd13f1234c1234567dbe2c6f63b'
    end

    it "should delete a address" do
      result = tropo_provisioning.delete_address('108000', '883510001812716')
      result[:message].should == "delete successful"
    end

    it "should raise an ArgumentError if the right params are not passed to move_address" do
      begin
        tropo_provisioning.move_address({ :to => '108002', :address => '883510001812716'})
      rescue => e
        e.to_s.should == ':from is a required parameter'
      end

      begin
        tropo_provisioning.move_address({ :from => '108002', :address => '883510001812716'})
      rescue => e
        e.to_s.should == ':to is a required parameter'
      end

      begin
        tropo_provisioning.move_address({ :from => '108002', :to => '883510001812716'})
      rescue => e
        e.to_s.should == ':address is a required parameter'
      end
    end

    it "should move a address" do
      results = tropo_provisioning.move_address({ :from => '108000', :to => '108002', :address => '883510001812716'})
      results.should == { 'message' => 'delete successful' }
    end

    it "should return accounts with associated addresses" do
      pending()
      result = tropo_provisioning.account_with_addresses('108000')
      result.should == nil

      result = tropo_provisioning.accounts_with_addresses
      result.should == nil
    end
  end

  describe 'exchanges' do
    it "should obtain a list of available exchanges" do
      results = tropo_provisioning.exchanges
      results.should == ActiveSupport::JSON.decode(exchanges)
    end
  end

  describe 'user' do
    it "should raise argument errors on create_user if required params not passed" do
      begin
        tropo_provisioning.create_user
      rescue => e
        e.to_s.should == ':username is a required parameter'
      end

      begin
        tropo_provisioning.create_user({ :username => "foobar7474" })
      rescue => e
        e.to_s.should == ':password is a required parameter'
      end

      begin
        tropo_provisioning.create_user({ :username => "foobar7474", :password => 'fooey', :first_name=> "blah",:last_name=>"blah" })
      rescue => e
        e.to_s.should == ':email is a required parameter'
      end
    end

    it "should create a new user" do
      result = tropo_provisioning.create_user({ :username => "foobar7474", :password => 'fooey', :email => 'jsgoecke@voxeo.com',:first_name=> "jason", :last_name=> "blah" })
      result.should == @new_user
    end

    it "should confirm a user" do
      result = tropo_provisioning.confirm_user('12345', '1234', '127.0.0.1')
      result.message.should == "successfully confirmed user 12345"
    end

    it "should obtain details about a user" do
      result = tropo_provisioning.user('12345')
      result.should == @existing_user
    end

    it 'should return a list of search terms that we search for' do
      result = tropo_provisioning.search_users('username=foobar')
      result.should == @search_accounts
    end

    it 'should return a list of search terms that we search for using a Hash parameter' do
      result = tropo_provisioning.search_users({:username => "foobar"})
      result.should == @search_accounts
    end

    it 'should modify a user' do
      result = tropo_provisioning.modify_user('12345', { :password => 'foobar' })
      result.href.should == 'http://api-smsified-eng.voxeo.net/v1/users/12345'
      tropo_provisioning.user_data['password'].should == 'foobar'
    end

    it 'should see if a username is available' do
      tropo_provisioning.username_exists?('12345').should == @username_check
    end
  end

  describe 'features' do
    it "should return a list of available features" do
      result = tropo_provisioning.features
      result.should == @features
    end

    it "should return a list of features configured for a user" do
      result = tropo_provisioning.user_features('12345')
      result.should == @user_features
    end

    it "should add a feature to a user" do
      result = tropo_provisioning.user_enable_feature('12345', 'http://api-smsified-eng.voxeo.net/v1/features/8')
      result.should == @feature
    end

    it "should disable a feature for a user" do
      result = tropo_provisioning.user_disable_feature('12345', '8')
      result.should == @feature_delete_message
    end
  end

  describe 'platforms and partitions' do
    it 'should list the available partitions' do
      result = tropo_provisioning.partitions
      result[0]['name'].should == 'staging'
    end

    it 'should return a list of available platforms under a partition' do
      result = tropo_provisioning.platforms('staging')
      result[0].name.should == 'sms'
    end
  end

  describe 'payments' do
    it "should add a payment method to a user" do
      result = tropo_provisioning.add_payment_info('12345', { :account_number     => '1234567890',
                                                              :payment_type       => 'https://api-smsified-eng.voxeo.net/v1/types/payment/1',
                                                              :address            => '123 Smith Avenue',
                                                              :city               => 'San Carlos',
                                                              :state              => 'CA',
                                                              :postal_code        => '94070',
                                                              :country            => 'USA',
                                                              :name_on_account    => 'Tropo User',
                                                              :expiration_date    => '2011-12-10',
                                                              :security_code      => '123',
                                                              :recharge_amount    => 10.50,
                                                              :recharge_threshold => 5.00,
                                                              :email              => 'j@doe.com',
                                                              :phone_number       => '4155551212' })
      result.should == @payment_info_message
    end

    it "should add a payment method to a user in camelCase" do
      result = tropo_provisioning.add_payment_info('12345', { :accountNumber     => '1234567890',
                                                              :paymentType       => 'https://api-smsified-eng.voxeo.net/v1/types/payment/1',
                                                              :address           => '123 Smith Avenue',
                                                              :city              => 'San Carlos',
                                                              :state             => 'CA',
                                                              :postalCode        => '94070',
                                                              :country           => 'USA',
                                                              :nameOnAccount     => 'Tropo User',
                                                              :expirationDate    => '2011-12-10',
                                                              :securityCode      => '123',
                                                              :rechargeAmount    => 10.50,
                                                              :rechargeThreshold => 5.00,
                                                              :email             => 'j@doe.com',
                                                              :phoneNumber       => '4155551212' })

      result.should == @payment_info_message
    end

    it 'should add a payment method to a user keys as strings' do
      result = tropo_provisioning.add_payment_info('12345', { 'account_number'     => '1234567890',
                                                              'payment_type'       => 'https://api-smsified-eng.voxeo.net/v1/types/payment/1',
                                                              'address'            => '123 Smith Avenue',
                                                              'city'               => 'San Carlos',
                                                              'state'              => 'CA',
                                                              'postal_code'        => '94070',
                                                              'country'            => 'USA',
                                                              'name_on_account'    => 'Tropo User',
                                                              'expiration_date'    => '2011-12-10',
                                                              'security_code'      => '123',
                                                              'recharge_amount'    => 10.50,
                                                              'recharge_threshold' => 5.00,
                                                              'email'              => 'j@doe.com',
                                                              'phone_number'       => '4155551212' })


      result.should == @payment_info_message
    end

    it 'should add a payment method to a user in camelCase and keys as strings' do
      result = tropo_provisioning.add_payment_info('12345', { 'accountNumber'     => '1234567890',
                                                              'paymentType'       => 'https://api-smsified-eng.voxeo.net/v1/types/payment/1',
                                                              'address'           => '123 Smith Avenue',
                                                              'city'              => 'San Carlos',
                                                              'state'             => 'CA',
                                                              'postalCode'        => '94070',
                                                              'country'           => 'USA',
                                                              'nameOnAccount'     => 'Tropo User',
                                                              'expirationDate'    => '2011-12-10',
                                                              'securityCode'      => '123',
                                                              'rechargeAmount'    => 10.50,
                                                              'rechargeThreshold' => 5.00,
                                                              'email'             => 'j@doe.com',
                                                              'phone_number'      => '4155551212' })

      result.should == @payment_info_message
    end

    it 'should return the balance' do
      result = tropo_provisioning.balance('12345')
      result['balance'].should == "3.00"
    end

    it 'should make a payment' do
      result = tropo_provisioning.make_payment('1234', 1.0)
      result.message.should == "successfully posted payment for the amount 1.000000"
    end

    it "should get the payment method for a user" do
      result = tropo_provisioning.user_payment_method('12345')
      result.should == @payment_method
    end

    it "should return a list of available payment types" do
      result = tropo_provisioning.available_payment_types
      result.should == @payment_methods
    end

    it 'should raise an error if a float is not passed in amount for make_payment' do
      begin
        tropo_provisioning.make_payment('1234', { :foo => 'bar' })
      rescue => e
        e.to_s.should == "amount must be of type Float"
      end
    end

    it 'should update the recurring payment details' do
      result = tropo_provisioning.update_recurrence('1234', { :recharge_amount => 13.50, :threshold_percentage => 10 })
      result.should == @recurrence_updated
    end

    it 'should get the existing recurrent payment details' do
      tropo_provisioning.get_recurrence('1234').should == @recurrence
    end
  end

  describe 'whitelists' do
    it 'should get the whitelist for a user account' do
      result = tropo_provisioning.whitelist('12345')
      result.should == @whitelist

      result = tropo_provisioning.whitelist
      result.should == @whitelist
    end

    it 'should add to a whitelist' do
      result = tropo_provisioning.add_whitelist({ :user_id => '12345', :value => '14155551212' })
      result.should == @whitelist
    end

    it 'should remove from a whitelist' do
      result = tropo_provisioning.delete_whitelist({ :user_id => '12345', :value => '14155551212' })
      result.should == @whitelist
    end
  end

  describe 'custome error' do
    it 'should raise a custom error with an http_status code on the error object' do
      begin
        tropo_provisioning.user('98765')
      rescue => e
        e.http_status.should == "404"
        e.message.should == '404: Got an error here! - '
      end
    end
  end

  describe 'geography' do
    it 'should return a list of countries' do
      tropo_provisioning.countries.should == @countries
    end

    it 'should have the id added for the country' do
      result = tropo_provisioning.countries[1][:id].should == '36'
    end

    it 'should return a list of states' do
      tropo_provisioning.states('36').should == @states
    end

    it 'should have the id added for the state' do
      tropo_provisioning.states('36')[1]['id'].should == '50'
    end
  end

  describe 'invitations' do
    it 'should return a list of inivitations' do
      tropo_provisioning.invitations.should == @invitations
    end

    it 'should return an invitation' do
      tropo_provisioning.invitation('ABC457').should == @invitations[1]
    end

    it 'should create an invitation' do
      tropo_provisioning.create_invitation({ :code   => 'ABC457',
                                             :count  => 100,
                                             :credit => 10 }).should == @invitation_created
    end

    it 'should create an invitationfor a specific user' do
      tropo_provisioning.create_invitation('15909',
                                           { :code   => 'ABC457',
                                             :count  => 100,
                                             :credit => 10 }).should == @invitation_created
    end

    it 'should update an invitation' do
      tropo_provisioning.update_invitation('ABC457', :count  => 200).should == @invitation_created
    end

    it 'should update an invitation for a specific user' do
      tropo_provisioning.update_invitation('ABC457', '15909', :count  => 200).should == @invitation_created
    end

    it 'should delete an invitation' do
      tropo_provisioning.delete_invitation('ABC457').should == @deleted_invitation
    end

    it 'should delete a specific user invitation' do
      tropo_provisioning.delete_invitation('ABC457', '15909').should == @deleted_invitation
    end

    it 'should fetch the invitations for a user' do
      tropo_provisioning.user_invitations('15909').should == [@invitation_created]
    end

    it 'should list a specific invitation for a user' do
      tropo_provisioning.invitation('ABC457', '15909').should == @invitations[1]
    end
  end

  describe "HTTPS/SSL support" do
    it 'should fetch invitations via HTTPS/SSL' do
      tropo_provisioning.invitations.should == @invitations
    end
  end
end
