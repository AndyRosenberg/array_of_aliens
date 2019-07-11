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

  describe "#preference_match?" do
    user_1 = User.create(name: "1", email: "1", password: "", preference: "man", gender: "woman")
    user_2 = User.create(name: "2", email: "2", password: "", preference: "woman", gender: "man")
    user_3 = User.create(name: "3", email: "3", password: "", preference: "man", gender: "man")
    user_4 = User.create(name: "4", email: "4", password: "", preference: "man,woman", gender: "woman")

    it "is a match" do
      user_1.preference_match?(user_2).should be_true
    end

    it "is not a match" do
      user_2.preference_match?(user_3).should be_false
    end

    it "is a bi matchup" do
      user_4.preference_match?(user_2).should be_true
      user_4.preference_match?(user_3).should be_false
    end
  end
end
