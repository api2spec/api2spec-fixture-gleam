import gleam/erlang/process
import mist
import wisp
import wisp/wisp_mist

pub fn main() {
  wisp.configure_logger()
  let secret_key_base = wisp.random_string(64)

  let assert Ok(_) =
    wisp_mist.handler(handle_request, secret_key_base)
    |> mist.new
    |> mist.port(8080)
    |> mist.start_http

  process.sleep_forever()
}

fn handle_request(req: wisp.Request) -> wisp.Response {
  case wisp.path_segments(req) {
    ["health"] -> health_handler(req)
    ["health", "ready"] -> ready_handler(req)
    ["users"] -> users_handler(req)
    ["users", id] -> user_handler(req, id)
    ["users", user_id, "posts"] -> user_posts_handler(req, user_id)
    ["posts"] -> posts_handler(req)
    ["posts", id] -> post_handler(req, id)
    _ -> wisp.not_found()
  }
}

fn health_handler(_req: wisp.Request) -> wisp.Response {
  wisp.json_response("{\"status\":\"ok\",\"version\":\"0.1.0\"}", 200)
}

fn ready_handler(_req: wisp.Request) -> wisp.Response {
  wisp.json_response("{\"status\":\"ready\",\"version\":\"0.1.0\"}", 200)
}

fn users_handler(req: wisp.Request) -> wisp.Response {
  case req.method {
    wisp.Get -> wisp.json_response("[{\"id\":1,\"name\":\"Alice\"},{\"id\":2,\"name\":\"Bob\"}]", 200)
    wisp.Post -> wisp.json_response("{\"id\":1,\"name\":\"New User\"}", 201)
    _ -> wisp.method_not_allowed([wisp.Get, wisp.Post])
  }
}

fn user_handler(req: wisp.Request, id: String) -> wisp.Response {
  case req.method {
    wisp.Get -> wisp.json_response("{\"id\":" <> id <> ",\"name\":\"User\"}", 200)
    wisp.Put -> wisp.json_response("{\"id\":" <> id <> ",\"name\":\"Updated\"}", 200)
    wisp.Delete -> wisp.response(204)
    _ -> wisp.method_not_allowed([wisp.Get, wisp.Put, wisp.Delete])
  }
}

fn user_posts_handler(_req: wisp.Request, user_id: String) -> wisp.Response {
  wisp.json_response("[{\"id\":1,\"user_id\":" <> user_id <> ",\"title\":\"Post\"}]", 200)
}

fn posts_handler(req: wisp.Request) -> wisp.Response {
  case req.method {
    wisp.Get -> wisp.json_response("[{\"id\":1,\"title\":\"First Post\"}]", 200)
    wisp.Post -> wisp.json_response("{\"id\":1,\"title\":\"New Post\"}", 201)
    _ -> wisp.method_not_allowed([wisp.Get, wisp.Post])
  }
}

fn post_handler(_req: wisp.Request, id: String) -> wisp.Response {
  wisp.json_response("{\"id\":" <> id <> ",\"title\":\"Post\"}", 200)
}
