# Lucky HTMX

[HTMX](https://htmx.org) integration for [Lucky](https://luckyframework.org).

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     lucky_htmx:
       github: watzon/lucky_htmx
   ```

2. Run `shards install`

3. Add the following to your `src/shards.cr`:

   ```crystal
   require "lucky_htmx"
   ```

## Usage

### Request

You can resolve an instance of the `HTMXRequest` class from the action which provides shortcuts
for reading the HTMX specific request headers.

```crystal
# src/actions/users/create.cr

class Users::Index < BrowserAction
  include LuckyHtmx::ActionHelpers

  get "/users" do
    # Always true if the request is performed via HTMX
    htmx_request?

    # Indicates that the request is via an element using `hx-boost`
    boosted_request?

    # The current URL of the browser
    htmx_current_url

    # True if the request is for history restoration after a miss in the local history cache
    history_restore_request?

    # The user's response to an `hx-prompt`
    htmx_prompt_response

    # The id of the target element if it exists
    htmx_target

    # The name of the triggered element if it exists
    htmx_trigger_name

    # The id of the triggered element if it exists
    htmx_trigger_id
  end
end
```

### Response

- `LuckyHTMX::RedirectResponse`

HTMX can trigger a redirect on the client side when it receives a response with a `HX-Redirect` header. The
`LuckyHTMX::RedirectResponse` class makes it easy to trigger such redirects.

```crystal
# src/actions/users/create.cr

class Users::Create < BrowserAction
  include LuckyHtmx::ActionHelpers

  post "/users" do
    # Create the user
    user = User.create(params)

    # Redirect to the user's show page
    htmx_redirect("/users/#{user.id}")
  end
end
```

- `LuckyHTMX::RefreshResponse`

HTMX will trigger a page reload when it receives a response with a `HX-Refresh` header. The `LuckyHTMX::RefreshResponse` allows you to send
such a response. It takes no arguments since HTMX ignores any content.

```crystal
# src/actions/users/create.cr

class Users::Create < BrowserAction
  include LuckyHtmx::ActionHelpers

  post "/users" do
    # Create the user
    user = User.create(params)

    # Refresh the page
    htmx_refresh
  end
end
```

- `LuckyHTMX::StopPollingResponse`

When using a [polling trigger](https://htmx.org/docs/#polling), HTMX will stop polling when encounters a response
with a special HTTP status code `286`. The `LuckyHTMX::StopPollingResponse` class is a custom response with
that status code.

```crystal
# src/actions/users/create.cr

class Users::Create < BrowserAction
  include LuckyHtmx::ActionHelpers

  post "/users" do
    # Create the user
    user = User.create(params)

    # Stop polling
    htmx_stop_polling
  end
end
```

- `LuckyHTMX::Response`

For all the available remaining headers you can use the `LuckyHTMX::Response` class.

```crystal
# src/actions/users/create.cr

class Users::Create < BrowserAction
  post "/users" do
    # Create the user
    user = User.create(params)

    # Send a custom response
    LuckyHTMX::Response.new(context)
      .set_location(some_location) # Allows you to do a client-side redirect that does not trigger a full page reload
      .push_url(some_url) # Allows you to push a new URL to the browser history
      .replace_url(some_url) # Allows you to replace the current URL in the browser history
      .reswap(options) # Allows you to specify how the response will be swapped
      .retarget(selector) # Sets the target element for the response to the given CSS selector
  end
end
```

Additionally you can trigger client-side events using the `add_trigger` methods.

```crystal
# src/actions/users/create.cr

class Users::Create < BrowserAction
  post "/users" do
    # Create the user
    user = User.create(params)

    # Send a custom response
    LuckyHTMX::Response.new
      .add_trigger(some_event)
      .add_trigger_after_settle(some_event)
      .add_trigger_after_swap(some_event)
  end
end
```

You can all those methods multiple times if you wish to trigger multiple events.

### Render Template Fragments

TODO

### OOB Swap support

TODO

## Contributing

1. Fork it (<https://github.com/watzon/lucky_htmx/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Chris Watson](https://github.com/watzon) - creator and maintainer
