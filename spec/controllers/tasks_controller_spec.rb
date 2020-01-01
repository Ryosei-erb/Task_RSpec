require 'rails_helper'
include SessionsHelper

RSpec.describe TasksController, type: :controller do
  let(:user) { FactoryBot.create(:user)}
  let(:task) { FactoryBot.create(:task, user: user)}
  describe "GET #index" do

    context "認可されたユーザーとして" do
      it "200レスポンスを返す" do
        log_in user
        get :index
        expect(response.status).to eq 200
      end

    end
    context "認可されていないユーザーとして" do
      it "302レスポンスを返す" do
        get :index
        expect(response).to have_http_status "302"
      end
      it "ログインページへリダイレクトする" do
        get :index
        expect(response).to redirect_to "/login"
      end
    end
  end

  describe "GET #show" do
    context "認可されたユーザーとして" do

      it "200レスポンスを返す" do
        log_in user
        get :show, params: { id: task.id}
        expect(response).to have_http_status "200"
      end
    end
    context "認可されていないユーザーとして" do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @task = FactoryBot.create(:task, user: other_user)
      end

      it "ログインページへリダイレクトする" do
        log_in @user
        get :show, params: { id: @task.id}
        expect(response).to_not have_content "@task"
      end

    end
  end

  describe "POST #create" do
    context "認証されたユーザーとして" do

      context "有効な属性値の場合" do
        it "タスクを追加できる" do
          task_params = FactoryBot.attributes_for(:task)
          log_in user
          expect{
            post :create, params: { task: task_params}
          }.to change(user.tasks, :count).by(1)
        end
      end
      context "無効な属性値の場合" do
        it "タスクを追加出来ない" do
          task_params = FactoryBot.attributes_for(:task, :invalid)
          log_in user
          expect {
            post :create, params: { task: task_params}
          }.to_not change(user.tasks, :count)
        end
      end

    end
    context "認証されていないユーザーとして" do
      it "302レスポンスを返す" do
        task_params = FactoryBot.attributes_for(:task)
        post :create, params: { task: task_params}
        expect(response).to have_http_status "302"
      end
      it "ログイン画面へリダイレクトする" do
        task_params = FactoryBot.attributes_for(:task)
        post :create, params: { task: task_params}
        expect(response).to redirect_to "/login"
      end
    end
  end

  describe "PATCH #update" do
    context "認可されているユーザーとして"  do

      it "タスクを更新する" do
        task_params = FactoryBot.attributes_for(:task, name: "更新されたタスク")
        log_in user
        patch :update, params: { id: task.id, task: task_params}
        expect(task.reload.name).to eq "更新されたタスク"
      end
    end
    context "認可されていないユーザーとして" do
      before do
        @user_a = FactoryBot.create(:user)
        @user_b = FactoryBot.create(:user)
        @task = FactoryBot.create(:task, user: @user_b, name: "タスク")
      end

      it "タスクが更新できない" do
        task_params = FactoryBot.attributes_for(:task, name: "新しいタスク")
        log_in @user_a
        patch :update, params: { id: @task.id, task: task_params}
        expect(@task.reload.name).to eq "タスク"
      end

    end
    context "ゲストとして" do
      before do
        @task = FactoryBot.create(:task)
      end

      it "302レスポンスを返す" do
        task_params = FactoryBot.attributes_for(:task)
        patch :update, params: { id: @task.id , project: task_params}
        expect(response).to have_http_status "302"
      end

      it "ログインページへリダイレクトする" do
        task_params = FactoryBot.attributes_for(:task)
        patch :update, params: { id: @task.id, task: task_params}
        expect(response).to redirect_to "/login"
      end
    end
  end

  describe "DELETE #destroy" do
    context "認可されたユーザーとして" do
      before do
        @user = FactoryBot.create(:user)
        @task = FactoryBot.create(:task, user: @user)
      end

      it "タスクを削除する" do
        log_in @user
        expect {
          delete :destroy, params: { id: @task.id}
        }.to change(@user.tasks, :count).by(-1)
      end
    end
    context "認可されていないユーザーとして" do
      before do
        @user_a = FactoryBot.create(:user)
        user_b = FactoryBot.create(:user)
        @task = FactoryBot.create(:task, user: user_b)
      end
      it "タスクを削除できない" do
        log_in @user_a
        expect {
          delete :destroy, params: { id: @task.id}
        }.to change{Task.count}.by(0)
      end

    end
    context "ゲストとして" do
      before do
        @task = FactoryBot.create(:task)
      end
      it "302レスポンスを返す" do
        delete :destroy, params: { id: @task.id}
        expect(response).to have_http_status "302"
      end
      it "ログインページにリダイレクトする" do
        delete :destroy, params: { id: @task.id}
        expect(response).to redirect_to "/login"
      end
      it "タスクを削除できない" do
        expect{
          delete :destroy, params: { id: @task.id}
        }.to_not change(Task, :count)
      end
    end
  end
 end
