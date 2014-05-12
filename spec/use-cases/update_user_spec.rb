require 'spec_helper'


describe "UpdateUser" do
  it "calls bullshit if user does not exist" do
    result = PL::UpdateUser.run({ user_id: 9999 })
    expect(result.success?).to eq(false)
    expect(result.error).to eq(:user_not_found)
  end

  it "creates a user" do
    user = PL::Database.db.create_user({ twitter: "Alice", password: "password2" })
    result = PL::UpdateUser.run({ user_id: user.id, twitter: "Bob" })
    expect(result.success?).to eq(true)
    expect(PL::Database.db.get_user(user.id).twitter).to eq("Bob")
  end
end

