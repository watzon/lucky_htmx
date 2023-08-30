require "./response"

module LuckyHTMX
  class RefreshRespose < Response
    def initialize(context : HTTP::Server::Context)
      super(
        context,
        headers: HTTP::Headers{ "HX-Refresh" => "true" }
      )
    end
  end
end
