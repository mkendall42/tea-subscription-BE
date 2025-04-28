# README

## Overview

Tea Subscription provides a backend and 'admin view' frontend to maintain a database of customers and teas.  Customers can subscribe to specific teas, as well as cancel said subscriptions.  
Post-MVP: set multiple teas into tea bundles that can be subscribed to as groups (might even change prices based on specials)

This is the backend (BE) implementation, which provides a Rails API for the FE.  It runs by default at the usual `localhost:3000`.  

Please see below for details regarding consumable / accessible endpoints.

## Configuration and testing

Mention a few gems?  Mention tests (how to run them / check separately), bundle install and db setup, etc.

## Endpoints

For each endpoint, (request type, path, params, incoming body, response body, JSON structure, response statuses, other notes)

- Get all subscriptions: as the name implies, this returns basic information about all subscriptions (by all customers) in the database.
    - Request: GET `/api/v1/subscriptions`.  There is no body, nor query parameters.
    - Response statuses:
        - 200: successful response
        - \[What else would there be here?\]
    - Response body structure (JSON):
    ```
        {
            data: {
                subscription_titles: [
                    <title name 1>, <title name 2>, ...
                ],
                total_subscriptions: <integer>
            }
        }
    ```

- Get single subscription: this provides detailed information about a specified subscription, including its status (e.g. if a customer has cancelled it).
    - Request: GET `/api/v1/subscriptions/:id`.  There is no body, nor query params, but `:id` must be specified (the subscription ID)
    - Response statuses:
        - 200: successful response
        - 404: ID invalid / not found
        - \[Others?\]
    - Response body strcuture (JSON):
    ```
        {
            data: {
                title: <string>,
                customer: {
                    first_name: <string>,
                    last_name: <string>,
                    id: <integer> (based on DB table)
                }
                tea: {
                    title: <string>,
                    id: <integer> (based on DB table)
                }
                status: <string>, (valid values are "active", "cancelled", and "dormant")
                price: <float>,
                frequency: <float> (number of times per month) 
            }
        }
    ```
- Change / cancel subscription: this provides a way to change the status of a specific subscription.
    - Request: PATCH `/api/v1/subscriptions/:id`.  Subscription ID `:id` must be specified.  Additionally, the JSON body must follow this structure:
    ```
        {
            new_status: <string> (must be "active", "cancelled", or "dormant")
        }
    ```
    - Response statuses:
        - 200: Successful status update to the subscription
        - 404: Subscription ID is invalid / not found
        - 422: Error with body (`status` is not specified correctly)
        - \[Others?  What about e.g. if the status wasn't changed because it's already set to that value?\]
    - Response body structure (JSON):
    ```
        {
            message: "Status successfully changed from <old status> to <new status>."
        }
    ```

Other notes:
- Will need to implement consistent error handling (and associated JSON responses).
- Add validation as appropriate for certain fields.
