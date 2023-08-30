module LuckyHTMX
  class Response < Lucky::Response
    DEFAULT_STATUS = 200

    getter context

    getter triggers : Set(String)
    getter triggers_after_settle : Set(String)
    getter triggers_after_swap : Set(String)

    getter fragments : Array(String)

    def initialize(@context : HTTP::Server::Context, @headers : HTTP::Headers? = nil, @status : Int? = nil)
      super()
      @triggers = Set(String).new
      @triggers_after_settle = Set(String).new
      @triggers_after_swap = Set(String).new
      @fragments = Array(String).new
    end

    def print : Nil
      new_headers = headers if headers
      new_headers["HX-Trigger"] = triggers.join(" ") if triggers.any?
      new_headers["HX-Trigger-After-Settle"] = triggers_after_settle.join(" ") if triggers_after_settle.any?
      new_headers["HX-Trigger-After-Swap"] = triggers_after_swap.join(" ") if triggers_after_swap.any?
      context.response.headers = new_headers
      context.response.status_code = status
    rescue e : IO::Error
      Lucky::Log.error(exception: e) { "Broken Pipe: Maybe the client navigated away?" }
    end

    def status : Int
      @status || context.response.status_code || DEFAULT_STATUS
    end

    def headers : HTTP::Headers
      @headers || context.response.headers
    end

    def location(value : String)
      headers["HX-Location"] = value
    end

    def push_url(url : String)
      headers["HX-Push-Url"] = url
    end

    def replace_url(url : String)
      headers["HX-Replace-Url"] = url
    end

    def reswap(option : String)
      headers["HX-Reswap"] = option
    end

    def retarget(selector : String)
      headers["HX-Retarget"] = selector
    end

    def add_trigger(event : String)
      @triggers.add(event)
    end

    def add_trigger_after_settle(event : String)
      @triggers_after_settle.add(event)
    end

    def add_trigger_after_swap(event : String)
      @triggers_after_swap.add(event)
    end
  end
end
