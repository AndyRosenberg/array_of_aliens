require "./spec_helper"
require "../../src/models/user.cr"

Mocks.create_mock User do
  mock map_distance_from(other)
end

describe User do
  Spec.before_each do
    User.clear
  end

  describe "#distance_from" do
    user_1 = User.create(city: "Chicago", state: "IL")
    user_2 = User.create(city: "Phoenix", state: "AZ")

    allow(user_1).to receive(maps_distance_from(user_2)).and_return(2821583)

    it "calculates distance" do
      user_1.current_distance_from?(user_2).should_not be_truthy

      user_1.distance_from(user_2).should eq(2821583)

      user_1.current_distance_from?(user_2).should be_truthy

      user_2.update(city: "Flagstaff")

      allow(user_1).to receive(maps_distance_from(user_2)).and_return(2820000)

      user_1.distance_from(user_2).should_not eq(2821583)
    end
  end
end
