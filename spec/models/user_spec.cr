require "./spec_helper"
require "../../src/models/user.cr"

describe User do
  Spec.before_each do
    User.clear
  end

  describe "#get_distance" do
    user_1 = User.create(city: "Chicago", state: "IL")
    user_2 = User.create(city: "Phoenix", state: "AZ")

    it "calculates distance" do
      (user_1.get_distance(user_2).to_s.to_i).should eq(2821144)

      user_2.update(city: "Flagstaff")

      (user_1.get_distance(user_2).to_s.to_i).should_not eq(2821144)
    end
  end
end
