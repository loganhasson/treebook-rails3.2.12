require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should have_many(:user_friendships)
  should have_many(:friends)

  test "a user should enter a first name" do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:first_name].empty?
  end

  test "a user should enter a last name" do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:last_name].empty?
  end

  test "a user should enter a profile name" do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:profile_name].empty?
  end

  test "a user should have a unique profile name" do
  	user = User.new
  	user.profile_name = users(:logan).profile_name

  	assert !user.save
  	assert !user.errors[:profile_name].empty?
  end

  test "a user should have a profile name without spaces" do
  	user = User.new(first_name: 'Logan', last_name: 'Hasson', email: 'logan.hasson1@gmail.com')
    user.password = user.password_confirmation = 'asdfasdf'
  	user.profile_name = "My Profile With Spaces"

  	assert !user.save
  	assert !user.errors[:profile_name].empty?
  	assert user.errors[:profile_name].include?("must be formatted correctly.")
  end

  test "a user can have a correctly formatted profile name" do
    user = User.new(first_name: 'Logan', last_name: 'Hasson', email: 'logan.hasson1@gmail.com')
    user.password = user.password_confirmation = 'asdfasdf'
    user.profile_name = 'loganhasson_1'
    assert user.valid?
  end

  test "that creating friendships on a user works" do
    users(:logan).pending_friends << users(:mike)
    users(:logan).pending_friends.reload
    assert users(:logan).pending_friends.include?(users(:mike))
  end

  test "that no error is raised when trying to access a user's friends" do
    assert_nothing_raised do
      users(:logan).friends
    end
  end

  test "that creating a friendship based on user id and friend id works" do
    UserFriendship.create user_id: users(:logan).id, friend_id: users(:mike).id
    assert users(:logan).pending_friends.include?(users(:mike))
  end

  test "that calling to_param on a user returns the profile name" do
    assert_equal 'loganhasson', users(:logan).to_param
  end

end