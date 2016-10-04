# online_nic

A Ruby library for using the Online NIC API.

Example usage:

    # Set account information
    OnlineNic.username = 'username'
    OnlineNic.password = 'password'

    # Check a domain's availability
    response = OnlineNic.check_availability domain: 'example.com'
    response.available?

    # Check a domain's price
    response = OnlineNic.get_price domain: 'example.com'
    response.price

This library is still in early development.
