require 'test_helper'

describe ActiveStoreAccessor do
  it "should support common types" do
    profile = Profile.new

    assert_equal profile.age, nil
    assert_equal profile.score, 10
    assert_equal profile.rank, nil
    assert_equal profile.birthday, nil
    assert_equal profile.confirmed, nil
    assert_equal profile.photos, nil
    assert_equal profile.scores, nil

    profile.age = "20"
    profile.score = 100.32
    profile.rank = "3213.317"
    profile.birthday = Time.utc(2014, 5, 12)
    profile.confirmed = "1"
    profile.photos = 'my_doggy.png'
    profile.scores = { woo: 2 }

    assert_equal profile.age, 20
    assert_equal profile.score, 100
    assert_equal profile.rank, 3213.32
    assert_equal profile.birthday, Time.utc(2014, 5, 12)
    assert profile.confirmed
    assert_equal profile.photos, ['my_doggy.png']
    assert_equal profile.scores, { 'woo' => 2 }
  end

  it "should support model inheritance" do
    admin_profile = AdminProfile.new(age: 23, level: 5)

    assert_equal admin_profile.age, 23
    assert_equal admin_profile.level, 5
  end

  it "handles properly hstore" do
    profile = Profile.create(active: true, pi: 3.14)

    assert profile.active
    assert_equal profile.pi, 3.14
  end
end
