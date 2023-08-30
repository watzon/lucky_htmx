module LuckyHTMX::ActionHelpers
  def htmx_request? : Bool
    !!request.headers["HX-Request"]?
  end

  def boosted_request? : Bool
    !!request.headers["HX-Boosted"]?
  end

  def htmx_current_url : String
    request.headers["HX-Current-URL"]
  end

  def history_restore_request? : Bool
    !!request.headers["HX-History-Restore"]?
  end

  def htmx_prompt_response : String
    request.headers["HX-Prompt"]
  end

  def htmx_trigger_name : String
    request.headers["HX-Trigger"]
  end

  def htmx_trigger_id : String
    request.headers["HX-Trigger-Id"]
  end

  def htmx_redirect(to : String | Lucky::RouteHelper | Lucky::Action.class)
    RedirectResponse.new(context, to)
  end

  def htmx_refresh
    RefreshResponse.new(context)
  end

  def htmx_stop_polling
    StopPollingResponse.new(context)
  end
end
