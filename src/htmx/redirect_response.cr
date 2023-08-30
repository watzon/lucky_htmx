require "./response"

module LuckyHTMX
  class RedirectRespose < Response
    def initialize(context : HTTP::Server::Context, to : String)
      super(
        context,
        headers: HTTP::Headers{ "HX-Redirect" => to }
      )
    end

    def initialize(context : HTTP::Server::Context, to : Lucky::RouteHelper | LuckyAction.class)
      super(
        context,
        headers: HTTP::Headers{ "HX-Redirect" => to.path }
      )
    end
  end
end
