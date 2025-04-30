# README

## Overview

Tea Subscription provides a backend and 'admin view' frontend to maintain a database of customers and teas.  Customers can subscribe to specific teas, as well as cancel said subscriptions.  

This is the backend (BE) implementation, which provides a Rails API for the FE.  It runs by default at the usual `localhost:3000`.  

Please see below for details regarding consumable / accessible endpoints.

## Configuration and testing

Configuration can be completed with the usual `bundle install`; there are no particularly atypical gems or configuration aspects.  Please see `Gemfile.rb` for a complete listing.

Tests can be run using RSpec via `bundle exec rspec spec/`.  Most tests are housed within `requests/`, though a few (mostly association checks) are in `models/`.  Test coverage is presently at 100% coverage.

## Database structure

There are three tables in the database; there are two standalone tables to track tea information (`teas`) and customer information (`customers`), respectively.  They are associated by a many-to-many relation, which is managed by a joins table (`subscriptions`).  In general, the user should not directly interface with the database, but instead use the endpoints.  Here are additional notes:
- Most database variables are validated (especially ones for which erroneous values / structures could cause BE or FE issues)
- `temperature` is in degrees Celsius (Kelvin would also be reasonable, but I realize not many people use that scale...and Fahrenheit is just silly)
- `brew_time` is in seconds
- `frequency` is is deliveries / month (if not an integer, it's due to being every certain number of days)

## Endpoints

All consumable endpoints are below.  At present, all endpoints exist within the `SubscriptionsController` (seeds are used to pre-populate teas and customers).

- Get all subscriptions: as the name implies, this returns basic information about all subscriptions (by all customers) in the database.
    - Request: GET `/api/v1/subscriptions`.  There is no body, nor query parameters.
    - Response statuses:
        - 200: successful response
        - (No other designed responses other than 500-level)
    - Response body structure (JSON):
    ```
        {
            data: {
                subscriptions: [
                    {
                        title: subscription.title,
                        id: subscription.id,
                        status: subscription.status
                    },
                    ...
                ],
                total_subscriptions: <integer>
            }
        }
    ```

- Get single subscription: this provides detailed information about a specified subscription, such as its status (e.g. if a customer has cancelled it) and the associated tea and customer.
    - Request: GET `/api/v1/subscriptions/:id`.  There is no body, nor query params, but `:id` must be specified (the subscription ID)
    - Response statuses:
        - 200: successful response
        - 404: ID invalid / not found
    - Response body strcuture (JSON):
    ```
        {
            data: {
                id: subscription.id,
                title: subscription.title,
                status: subscription.status,
                price: subscription.price,
                frequency: subscription.frequency,
                customer: {
                    id: subscription.customer.id,
                    first_name: subscription.customer.first_name,
                    last_name: subscription.customer.last_name,
                    email: subscription.customer.email,
                    address: subscription.customer.address
                },
                tea: {
                    id: subscription.tea.id,
                    title: subscription.tea.title,
                    description: subscription.tea.description,
                    temperature: subscription.tea.temperature,
                    brew_time: subscription.tea.brew_time
                }
            }
        }
    ```
    - Note: This JSON response is lengthy, but necessary to provide all details.  An alternate approach would be to expose `CustomersController#show` and `TeasController#show` endpoints to allow lookups.  However, for the FE, this would be 3 API calls instead of 1, hence this structure at present.
- Change / cancel subscription: this provides a way to change the status of a specific subscription.
    - Request: PATCH `/api/v1/subscriptions/:id`.  Subscription ID `:id` must be specified.  Additionally, the JSON body must follow this structure:
    ```
        {
            new_status: <string> (must be "active" or "cancelled")
        }
    ```
    - Response statuses:
        - 200: Successful status update to the subscription
        - 404: Subscription ID is invalid / not found
        - 422: Error with body (`status` is not specified correctly)
    - Response body structure (JSON):
    ```
        {
            data: {
                subscription_id: <integer>>
                old_status: "active" or "cancelled"
                new_status: "active" or "cancelled"
            }
        }
    ```
    - Notes:
        - The JSON response structure allows for easy verification that the status was indeed set as intended.  At present, there is no error generated if old_status == new_status (since it is technically legal, and to allow for flexible FE handling).
        - If there is an error, the usual JSON error message format will be sent, e.g.:
        ```
        {
            status: <http status code as integer>,
            message: <string> (with exception class present typically, and relevant message)
        }
        ``` 

## Future directions / not implemented

Although MVP has been completed for the BE, there is always more that can be implemented.  Here are a few reach goals / potential next steps:
- Set multiple teas into tea bundles that can be subscribed to as groups (this would affect pricing and frequency for said bundles as well).
- External API calls to pull relevant real teas / tea images for populating the database.
