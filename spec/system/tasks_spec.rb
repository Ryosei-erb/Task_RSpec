require "rails_helper"

describe "タスク管理機能", type: :system do
  let(:user_a) { FactoryBot.create(:user, name: "ユーザーA", email: "a@example.com")}
  let(:user_b) { FactoryBot.create(:user, name: "ユーザーB", email: "b@example.com")}
  let!(:task_a) { FactoryBot.create(:task, name: "最初のタスク", user: user_a)}

  before do
    visit login_path
    fill_in "メールアドレス", with: login_user.email
    fill_in "パスワード", with: login_user.password
    click_button "ログインする"
  end

  shared_examples_for "ユーザーAが作成したタスクが表示される" do
    it { expect(page).to have_content "最初のタスク" }
  end
  describe "一覧表示機能" do
    context "ユーザーAがログインしている時" do
      let(:login_user) { user_a }
      it_behaves_like "ユーザーAが作成したタスクが表示される"
    end
    context "ユーザーBがログインしている時" do
      let(:login_user) { user_b }
      it "ユーザーAが作成したタスクが表示されない" do
        #ユーザーAが作成したタスクの名称が画面上に表示されていないことを確認
        expect(page).to_not have_content "最初のタスク"
      end
    end
  end

  describe "詳細表示機能" do
    context "ユーザーAがログインしている時" do
      let(:login_user) { user_a}
      before do
        visit task_path(task_a)
      end
      it_behaves_like "ユーザーAが作成したタスクが表示される"
    end
  end

  describe "新規作成機能" do
    let(:login_user) { user_a }

    before do
      visit new_task_path
      fill_in "名称", with: task_name
      click_button "登録する"
    end

    context "新規作成画面で名称を入力した時" do
      let(:task_name) { "新規作成のテストを書く"}

      it "作成のアラートが表示される" do
        expect(page).to have_selector ".alert-success", text: "を登録しました"
      end

      it "作成した名称が表示される" do
        expect(page).to have_content "新規作成のテストを書く"
      end

    end
    context "新規作成画面で名称を入力しなかった時" do
      let(:task_name) { ""}
      it "エラーとなる" do
        within "#error_explanation" do
          expect(page).to have_content "名称を入力してください"
        end
      end

    end
  end

  describe "編集機能" do
    let(:login_user) { user_a}
    #編集ページに飛ぶ
    before do
      visit edit_task_url(task_a)
      fill_in "名称", with: task_name
      fill_in "詳しい説明", with: task_description
      click_button "更新する"
    end
    #編集ページで名称を入力した場合
    context "編集画面で名称を入力した場合" do
      let (:task_name) { "タスクを編集した"}
      let (:task_description) { "spec/system"}
      it "編集成功のアラートが表示される" do
        expect(page).to have_selector ".alert-success", text: "を更新しました"
      end
      it "編集した名称が表示される" do
        expect(page).to have_content "タスクを編集した"
      end
    end
    #編集ページで名称を入力しなかった場合、
    context "編集画面で名称を入力しなかった場合" do
      let(:task_name) { ""}
      let(:task_description) { ""}
      it "エラーとなる" do
        within "#error_explanation" do
          expect(page).to have_content "名称を入力してください"
        end
      end
    end
  end

  describe "削除機能" do

    context "ユーザーAがログインした時" do
      let(:login_user) { user_a}
      before do
        click_link "削除"
        page.driver.browser.switch_to.alert.accept
      end
      it "削除したタスクが表示されない" do
        visit tasks_url(task_a)
        expect(page).to have_no_content "最初のタスク"
      end
    
    end
    context "ユーザーBがログインした時" do
      let(:login_user) { user_b }
      it "削除のリンクが表示されない" do
        expect(page).to_not have_css "削除"
      end

    end
  end
end
