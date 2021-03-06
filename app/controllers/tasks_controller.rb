class TasksController < ApplicationController
  before_action :login_required

  def index
    @tasks = current_user.tasks.order(created_at: :desc)
  end

  def show
    @task = current_user.tasks.find_by(id: params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.new(task_params)
    if @task.save
      redirect_to @task, notice: "タスク「 #{@task.name} 」を登録しました"
    else
      render :new
    end
  end

  def edit
    @task = current_user.tasks.find_by(id: params[:id])
  end

  def update
    @task = current_user.tasks.find_by(id: params[:id])
    if @task && @task.update(task_params)
      redirect_to tasks_url, notice: "タスク「 #{@task.name} 」を更新しました"
    else
      render :edit
    end
  end

  def destroy
    task = current_user.tasks.find_by(id: params[:id])
    if task.present?
      task.destroy
      redirect_to tasks_url, notice: "タスク「 #{task.name} 」を削除しました"
    end

  end

  private
    def task_params
      params.require(:task).permit(:name, :description)
    end

    def login_required
      redirect_to login_path unless current_user
    end

end
