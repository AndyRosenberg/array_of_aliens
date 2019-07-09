require "./spec_helper"
require "../../src/models/user.cr"

describe User do
  Spec.before_each do
    User.clear
  end

  describe "#distance_from" do
    user_1 = User.create(name: "1", email: "1", password: "", city: "Chicago", state: "IL")
    user_2 = User.create(name: "2", email: "2", password: "", city: "Phoenix", state: "AZ")

    it "calculates distance" do
      user_1.current_distance_from?(user_2).should_not be_truthy

      user_1.distance_from(user_2).should eq(2821145)

      user_1.current_distance_from?(user_2).should be_truthy

      user_2.update(city: "Flagstaff")

      user_1.distance_from(user_2).should_not eq(2821145)
    end
  end
end
