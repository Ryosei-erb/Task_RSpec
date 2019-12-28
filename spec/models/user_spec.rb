require 'rails_helper'

RSpec.describe User, type: :model do
  it "名前、メールアドレス、パスワードがあること" do
    user = FactoryBot.create(:user)
    expect(user).to be_valid
  end
  it "名前がなければ無効であること" do
    user = FactoryBot.build(:user, name: nil)
    user.valid?
    expect(user.errors[:name]).to include("を入力してください")
  end
  it "メールアドレスがなければ無効であること" do
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("を入力してください")
  end
  it "重複したメールアドレスならば、無効であること" do
    FactoryBot.create(:user, email: "a@example.com")
    user_b = FactoryBot.build(:user, email: "a@example.com")
    user_b.valid?
    expect(user_b.errors[:email]).to include("はすでに存在します")
  end


end
