import gleeunit
import gleeunit/should
import gleam/http
import gleam/json
import wisp/simulate
import api2spec_fixture_gleam

pub fn main() {
  gleeunit.main()
}

// Health endpoints

pub fn health_returns_200_test() {
  let request = simulate.request(http.Get, "/health")
  let response = api2spec_fixture_gleam.handle_request(request)

  response.status
  |> should.equal(200)
}

pub fn health_ready_returns_200_test() {
  let request = simulate.request(http.Get, "/health/ready")
  let response = api2spec_fixture_gleam.handle_request(request)

  response.status
  |> should.equal(200)
}

// Users list and create

pub fn get_users_returns_200_test() {
  let request = simulate.request(http.Get, "/users")
  let response = api2spec_fixture_gleam.handle_request(request)

  response.status
  |> should.equal(200)
}

pub fn create_user_returns_201_test() {
  let body = json.object([#("name", json.string("Test User"))])
  let request = simulate.request(http.Post, "/users")
    |> simulate.json_body(body)
  let response = api2spec_fixture_gleam.handle_request(request)

  response.status
  |> should.equal(201)
}

// Single user CRUD

pub fn get_user_returns_200_test() {
  let request = simulate.request(http.Get, "/users/1")
  let response = api2spec_fixture_gleam.handle_request(request)

  response.status
  |> should.equal(200)
}

pub fn update_user_returns_200_test() {
  let body = json.object([#("name", json.string("Updated User"))])
  let request = simulate.request(http.Put, "/users/1")
    |> simulate.json_body(body)
  let response = api2spec_fixture_gleam.handle_request(request)

  response.status
  |> should.equal(200)
}

pub fn delete_user_returns_204_test() {
  let request = simulate.request(http.Delete, "/users/1")
  let response = api2spec_fixture_gleam.handle_request(request)

  response.status
  |> should.equal(204)
}

// User posts

pub fn get_user_posts_returns_200_test() {
  let request = simulate.request(http.Get, "/users/1/posts")
  let response = api2spec_fixture_gleam.handle_request(request)

  response.status
  |> should.equal(200)
}

// Posts list and create

pub fn get_posts_returns_200_test() {
  let request = simulate.request(http.Get, "/posts")
  let response = api2spec_fixture_gleam.handle_request(request)

  response.status
  |> should.equal(200)
}

pub fn create_post_returns_201_test() {
  let body = json.object([#("title", json.string("Test Post"))])
  let request = simulate.request(http.Post, "/posts")
    |> simulate.json_body(body)
  let response = api2spec_fixture_gleam.handle_request(request)

  response.status
  |> should.equal(201)
}

pub fn get_post_returns_200_test() {
  let request = simulate.request(http.Get, "/posts/1")
  let response = api2spec_fixture_gleam.handle_request(request)

  response.status
  |> should.equal(200)
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
