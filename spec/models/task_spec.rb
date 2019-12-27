require 'rails_helper'

RSpec.describe Task, type: :model do
  it "タスクの名前と詳しい説明があること" do
    task = FactoryBot.build(:task)
    expect(task).to be_valid
  end

  it "タスクの名前がないなら無効であること" do
    task = FactoryBot.build(:task, name: nil)
    task.valid?
    expect(task.errors[:name]).to include("を入力してください")
  end

  it "タスクの詳しい説明がないなら無効であること" do
    task = FactoryBot.build(:task, description: nil)
    task.valid?
    expect(task.errors[:description]).to include("を入力してください")
  end

  it "タスクの名前が被っていないこと" do
    FactoryBot.create(:task, name: "掃除")
    task = FactoryBot.build(:task, name: "掃除")
    task.valid?
    expect(task.errors[:name]).to include("はすでに存在します")
  end

end
