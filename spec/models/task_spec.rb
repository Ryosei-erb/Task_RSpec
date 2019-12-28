require 'rails_helper'

RSpec.describe Task, type: :model do
  it "タスクの名称と詳しい説明があること" do
    task = FactoryBot.build(:task)
    expect(task).to be_valid
  end

  it "タスクの名称がないなら無効であること" do
    task = FactoryBot.build(:task, name: nil)
    task.valid?
    expect(task.errors[:name]).to include("を入力してください")
  end

  it "ユーザー単位ではタスクの名称がユニークであること" do
    user = FactoryBot.create(:user)
    user.tasks.create(name: "散歩")
    task = user.tasks.build(name: "散歩")
    task.valid?
    expect(task.errors[:name]).to include("はすでに存在します")
  end

  it "別々のユーザーが同じ名称のタスクを作ることは許すこと" do
    user_a = FactoryBot.create(:user, name: "ユーザーA",email: "a@example.com")
    user_a.tasks.create(name: "散歩")
    user_b = FactoryBot.create(:user, name: "ユーザーB", email: "b@example.com")
    task = user_b.tasks.build(name: "散歩")
    expect(task).to be_valid
  end

  it "名称の字数が30字以内ならば、有効であること" do
    user = FactoryBot.create(:user)
    task = user.tasks.create(name: "a" * 30)
    expect(task).to be_valid

  end
  it "名称の字数が30字以上ならば、無効であること" do
    user = FactoryBot.create(:user)
    task = user.tasks.build(name: "a" * 31)
    task.valid?
    expect(task.errors[:name]).to include("は30文字以内で入力してください")
  end

  it "名称にカンマを入れると、無効であること" do
    user = FactoryBot.create(:user)
    task = user.tasks.build(name: "タスク,テスト")
    task.valid?
    expect(task.errors[:name]).to include("にカンマを含めることはできません")
  end

  it "詳しい説明が140字以内ならば、有効であること" do
    user = FactoryBot.create(:user)
    task = user.tasks.create(name: "散歩", description: "a" * 140)
    expect(task).to be_valid
  end
  it "詳しい説明が140字以上ならば、無効であること" do
    user = FactoryBot.create(:user)
    task = user.tasks.build(description: "a" * 141)
    task.valid?
    expect(task.errors[:description]).to include("は140文字以内で入力してください")
  end


end
