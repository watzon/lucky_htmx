require "./response"

module LuckyHTMX
  class StopPollingResponse < Response
    HTMX_STOP_POLLING = 286

    def initialize(context : HTTP::Server::Context)
      super(
        context,
        status: HTMX_STOP_POLLING,
      )
    end
  end
end
