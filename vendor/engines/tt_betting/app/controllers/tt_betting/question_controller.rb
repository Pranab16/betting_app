require_dependency "tt_betting/application_controller"

module TtBetting
  class QuestionController < ApplicationController
    before_filter :require_admin, :only => [:new, :create, :active, :inactive, :edit, :update]
    before_filter :require_normal_user , :only => [:answered, :unanswered]

    def new
      @question = Question.new
      @question.choices.build
    end

    def create
      @question = Question.new(params[:question])
      if @question.valid?
        @question.save
        flash[:notice] = t(:new_question)
        redirect_to question_active_path
      else
        flash.now[:alert] = t(:invalid_new_question)
        render :action => "new"
      end
    end

    def active
      @questions = Question.where("time_to_expire > ?", DateTime.now).where(is_active: true)
    end

    def inactive
      @questions = Question.where(is_active: false)
    end

    def expired
      questions = Question.where("time_to_expire < ? and tt_betting_questions.is_active = 1", DateTime.now)

      if current_user.is_superuser
        @answer_hash = Hash[questions.map{|question| [question.id, question.choice_id]}]
      else
        answers = Answer.find_all_by_user_id(current_user.id)
        @answer_hash = Hash[answers.map{|answer| [answer.question_id, answer.choice_id]}]
      end

      @expired_answered_questions = []
      @expired_missed_questions = []
      for question in questions
        if @answer_hash[question.id]
          @expired_answered_questions.append(question)
        else
          @expired_missed_questions.append(question)
        end
      end
    end

    def answered
      @questions = Question.joins(:answers).where("time_to_expire > ? and tt_betting_answers.user_id = #{current_user.id}", DateTime.now)
      answers = Answer.find_all_by_user_id(current_user.id)
      @answer_hash = Hash[answers.map{|answer| [answer.question_id, answer.choice_id]}]
    end

    def unanswered
      @questions = Question.joins(
          "LEFT OUTER JOIN tt_betting_answers ON tt_betting_answers.question_id = tt_betting_questions.id and tt_betting_answers.user_id = #{current_user.id}"
      ).where("time_to_expire > ? and tt_betting_answers.question_id is null and tt_betting_questions.is_active = 1", DateTime.now)
    end

    def answer
      if current_user.is_superuser
        question = Question.find_by_id(params[:question])
        question.choice_id = params[:choice]
        question.save!
      else
        answer = Answer.where(user_id: current_user.id, question_id: params[:question]).first_or_initialize
        answer.choice_id = params[:choice]
        answer.save!
      end
      render nothing: true
    end

    def show
      @question = Question.find(params[:id])
      unless current_user.is_superuser
        unless @question.is_active
          flash[:alert] = t(:show_inactive_question, question_id: params[:id])
          redirect_to :root
        end
        @answer = Answer.where(question_id: params[:id], user_id: current_user.id).first
      end
    end

    def edit
      @question = Question.find(params[:id])
      if @question.is_active
        flash[:alert] = t(:update_inactive_question)
        redirect_to question_inactive_path
      end
    end

    def update
      @question = Question.find(params[:id])
      if @question.update_attributes(params[:question])
        flash[:notice] = t(:updated_question)
        redirect_to question_inactive_path
      else
        render 'edit'
      end
    end
  end
end
