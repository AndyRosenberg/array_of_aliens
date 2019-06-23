require "./spec_helper"
require "../../src/models/user.cr"

describe User do
  Spec.before_each do
    User.clear
  end

  describe "#distance_from" do
    user_1 = User.create(city: "Chicago", state: "IL")
    user_2 = User.create(city: "Phoenix", state: "AZ")

    it "calculates distance" do
      user_1.current_distance_from?(user_2).should_not be_truthy

      user_1.distance_from(user_2).should eq(2821144)

      user_1.current_distance_from?(user_2).should be_truthy

      user_2.update(city: "Flagstaff")

      user_1.distance_from(user_2).should_not eq(2821144)
    end
  end
end
