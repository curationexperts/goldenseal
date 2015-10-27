require 'rails_helper'

describe "Routes for the AdminSetController" do
  it "allows dots" do
    expect(get: "/admin_sets/12345.56.abcd").to route_to(
      controller: "admin_sets",
      action: 'show',
      id: '12345.56.abcd'
    )
  end
end
