require "rails_helper"

RSpec.describe "Deck routes", type: :routing do
  it "routes GET /decks to decks#index" do
    expect(get: "/decks").to route_to(
      controller: "decks",
      action: "index"
    )
  end

  it "routes GET /decks/new to decks#new" do
    expect(get: "/decks/new").to route_to(
      controller: "decks",
      action: "new"
    )
  end

  it "routes POST /decks to decks#create" do
    expect(post: "/decks").to route_to(
      controller: "decks",
      action: "create"
    )
  end

  it "routes GET /decks/:id to decks#show" do
    expect(get: "/decks/1").to route_to(
      controller: "decks",
      action: "show",
      id: "1"
    )
  end

  it "routes GET /decks/:id/edit to decks#edit" do
    expect(get: "/decks/1/edit").to route_to(
      controller: "decks",
      action: "edit",
      id: "1"
    )
  end

  it "routes PATCH /decks/:id to decks#update" do
    expect(patch: "/decks/1").to route_to(
      controller: "decks",
      action: "update",
      id: "1"
    )
  end

  it "routes DELETE /decks/:id to decks#destroy" do
    expect(delete: "/decks/1").to route_to(
      controller: "decks",
      action: "destroy",
      id: "1"
    )
  end
end