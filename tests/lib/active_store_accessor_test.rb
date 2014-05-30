require 'test_helper'

describe ActiveStoreAccessor do
  it "should support common types" do
    profile = Profile.new

    assert_equal profile.age, nil
    assert_equal profile.score, 10
    assert_equal profile.rank, nil
    assert_equal profile.birthday, nil
    assert_equal profile.confirmed, nil

    profile.age = "20"
    profile.score = 100.32
    profile.rank = "3213.312"
    profile.birthday = Time.utc(2014, 5, 12)
    profile.confirmed = "1"

    assert_equal profile.age, 20
    assert_equal profile.score, 100
    assert_equal profile.rank, 3213.312
    assert_equal profile.birthday, Time.utc(2014, 5, 12)
    assert_equal profile.confirmed, true
  end
end
