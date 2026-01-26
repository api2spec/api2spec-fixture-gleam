import gleeunit
import gleeunit/should
import gleam/dynamic/decode
import gleam/http
import gleam/json
import wisp
import wisp/simulate
import api2spec_fixture_gleam

pub fn main() {
  gleeunit.main()
}

// Helper function to get response body as string
fn get_body_string(response: wisp.Response) -> String {
  case response.body {
    wisp.Text(text) -> text
    wisp.Bytes(_) -> ""
    wisp.File(_, _, _) -> ""
  }
}

// Health endpoints

pub fn health_returns_200_test() {
  let request = simulate.request(http.Get, "/health")
  let response = api2spec_fixture_gleam.handle_request(request)

  response.status
  |> should.equal(200)

  let body = get_body_string(response)
  let decoder = {
    use status <- decode.field("status", decode.string)
    use version <- decode.field("version", decode.string)
    decode.success(#(status, version))
  }
  let assert Ok(#(status, version)) = json.parse(body, decoder)
  status |> should.equal("ok")
  version |> should.equal("0.1.0")
}

pub fn health_ready_returns_200_test() {
  let request = simulate.request(http.Get, "/health/ready")
  let response = api2spec_fixture_gleam.handle_request(request)

  response.status
  |> should.equal(200)

  let body = get_body_string(response)
  let decoder = {
    use status <- decode.field("status", decode.string)
    use version <- decode.field("version", decode.string)
    decode.success(#(status, version))
  }
  let assert Ok(#(status, version)) = json.parse(body, decoder)
  status |> should.equal("ready")
  version |> should.equal("0.1.0")
}

// Users list and create

pub fn get_users_returns_200_test() {
  let request = simulate.request(http.Get, "/users")
  let response = api2spec_fixture_gleam.handle_request(request)

  response.status
  |> should.equal(200)

  let body = get_body_string(response)
  let user_decoder = {
    use id <- decode.field("id", decode.int)
    use name <- decode.field("name", decode.string)
    decode.success(#(id, name))
  }
  let assert Ok(users) = json.parse(body, decode.list(user_decoder))
  users |> should.not_equal([])
  // Check first user has expected fields
  let assert [#(id1, name1), ..] = users
  id1 |> should.equal(1)
  name1 |> should.equal("Alice")
}

pub fn create_user_returns_201_test() {
  let body = json.object([#("name", json.string("Test User"))])
  let request = simulate.request(http.Post, "/users")
    |> simulate.json_body(body)
  let response = api2spec_fixture_gleam.handle_request(request)

  response.status
  |> should.equal(201)

  let response_body = get_body_string(response)
  let decoder = {
    use id <- decode.field("id", decode.int)
    use name <- decode.field("name", decode.string)
    decode.success(#(id, name))
  }
  let assert Ok(#(id, name)) = json.parse(response_body, decoder)
  id |> should.equal(1)
  name |> should.equal("New User")
}

// Single user CRUD

pub fn get_user_returns_200_test() {
  let request = simulate.request(http.Get, "/users/1")
  let response = api2spec_fixture_gleam.handle_request(request)

  response.status
  |> should.equal(200)

  let body = get_body_string(response)
  let decoder = {
    use id <- decode.field("id", decode.int)
    use name <- decode.field("name", decode.string)
    decode.success(#(id, name))
  }
  let assert Ok(#(id, name)) = json.parse(body, decoder)
  id |> should.equal(1)
  name |> should.equal("User")
}

pub fn update_user_returns_200_test() {
  let body = json.object([#("name", json.string("Updated User"))])
  let request = simulate.request(http.Put, "/users/1")
    |> simulate.json_body(body)
  let response = api2spec_fixture_gleam.handle_request(request)

  response.status
  |> should.equal(200)

  let response_body = get_body_string(response)
  let decoder = {
    use id <- decode.field("id", decode.int)
    use name <- decode.field("name", decode.string)
    decode.success(#(id, name))
  }
  let assert Ok(#(id, name)) = json.parse(response_body, decoder)
  id |> should.equal(1)
  name |> should.equal("Updated")
}

pub fn delete_user_returns_204_test() {
  let request = simulate.request(http.Delete, "/users/1")
  let response = api2spec_fixture_gleam.handle_request(request)

  response.status
  |> should.equal(204)

  // DELETE returns empty body
  let body = get_body_string(response)
  body |> should.equal("")
}

// User posts

pub fn get_user_posts_returns_200_test() {
  let request = simulate.request(http.Get, "/users/1/posts")
  let response = api2spec_fixture_gleam.handle_request(request)

  response.status
  |> should.equal(200)

  let body = get_body_string(response)
  let post_decoder = {
    use id <- decode.field("id", decode.int)
    use user_id <- decode.field("user_id", decode.int)
    use title <- decode.field("title", decode.string)
    decode.success(#(id, user_id, title))
  }
  let assert Ok(posts) = json.parse(body, decode.list(post_decoder))
  posts |> should.not_equal([])
  let assert [#(id, user_id, title), ..] = posts
  id |> should.equal(1)
  user_id |> should.equal(1)
  title |> should.equal("Post")
}

// Posts list and create

pub fn get_posts_returns_200_test() {
  let request = simulate.request(http.Get, "/posts")
  let response = api2spec_fixture_gleam.handle_request(request)

  response.status
  |> should.equal(200)

  let body = get_body_string(response)
  let post_decoder = {
    use id <- decode.field("id", decode.int)
    use title <- decode.field("title", decode.string)
    decode.success(#(id, title))
  }
  let assert Ok(posts) = json.parse(body, decode.list(post_decoder))
  posts |> should.not_equal([])
  let assert [#(id, title), ..] = posts
  id |> should.equal(1)
  title |> should.equal("First Post")
}

pub fn create_post_returns_201_test() {
  let body = json.object([#("title", json.string("Test Post"))])
  let request = simulate.request(http.Post, "/posts")
    |> simulate.json_body(body)
  let response = api2spec_fixture_gleam.handle_request(request)

  response.status
  |> should.equal(201)

  let response_body = get_body_string(response)
  let decoder = {
    use id <- decode.field("id", decode.int)
    use title <- decode.field("title", decode.string)
    decode.success(#(id, title))
  }
  let assert Ok(#(id, title)) = json.parse(response_body, decoder)
  id |> should.equal(1)
  title |> should.equal("New Post")
}

pub fn get_post_returns_200_test() {
  let request = simulate.request(http.Get, "/posts/1")
  let response = api2spec_fixture_gleam.handle_request(request)

  response.status
  |> should.equal(200)

  let body = get_body_string(response)
  let decoder = {
    use id <- decode.field("id", decode.int)
    use title <- decode.field("title", decode.string)
    decode.success(#(id, title))
  }
  let assert Ok(#(id, title)) = json.parse(body, decoder)
  id |> should.equal(1)
  title |> should.equal("Post")
}

// Not found cases

pub fn unknown_route_returns_404_test() {
  let request = simulate.request(http.Get, "/unknown")
  let response = api2spec_fixture_gleam.handle_request(request)

  response.status
  |> should.equal(404)
}

pub fn deeply_nested_unknown_returns_404_test() {
  let request = simulate.request(http.Get, "/a/b/c/d/e")
  let response = api2spec_fixture_gleam.handle_request(request)

  response.status
  |> should.equal(404)
}

// Method not allowed cases

pub fn delete_on_users_list_returns_405_test() {
  let request = simulate.request(http.Delete, "/users")
  let response = api2spec_fixture_gleam.handle_request(request)

  response.status
  |> should.equal(405)
}

pub fn post_on_single_user_returns_405_test() {
  let body = json.object([])
  let request = simulate.request(http.Post, "/users/1")
    |> simulate.json_body(body)
  let response = api2spec_fixture_gleam.handle_request(request)

  response.status
  |> should.equal(405)
}

pub fn delete_on_posts_list_returns_405_test() {
  let request = simulate.request(http.Delete, "/posts")
  let response = api2spec_fixture_gleam.handle_request(request)

  response.status
  |> should.equal(405)
}
