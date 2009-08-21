# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_super_stack_test_session',
  :secret      => '608ec90e37b9a6ddc0738db6b0fea405818b4f5b35ece90193eb28845bc23f2d76a39ea1b319ede792e015e7c827c3ff0955b23ef392d649ecb72aff62aaaaee'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
