require_dependency "tt_betting/application_controller"

module TtBetting
  class HomeController < ApplicationController

    def index
      if current_user.is_superuser
        @users_score = Question.joins(
            "INNER JOIN tt_betting_answers ON tt_betting_answers.choice_id = tt_betting_questions.choice_id JOIN users on tt_betting_answers.user_id = users.id"
        ).select(
            "users.name, sum(tt_betting_questions.score) as user_score").group("tt_betting_answers.user_id").order("user_score DESC").limit(3)

      else
        users_score = Question.joins(
            "INNER JOIN tt_betting_answers ON tt_betting_answers.choice_id = tt_betting_questions.choice_id"
        ).select(
            "tt_betting_answers.user_id, sum(tt_betting_questions.score) as user_score").group("tt_betting_answers.user_id").order("user_score DESC")

        @score = 0
        @rank = 0
        count = 1
        users_score.each do |user|
          if user.user_id == current_user.id
            @rank = count
            @score = user.user_score
            break
          end
          count += 1
        end

        if @rank == 0
          @rank = count
        end

      end

    end

    def leader_board
      @users = User.where(is_superuser: false)

      @questions = Question.where(is_active: true)

      users_question_score = Question.joins(
          "INNER JOIN tt_betting_answers ON tt_betting_answers.choice_id = tt_betting_questions.choice_id"
      ).select(
          "tt_betting_answers.user_id, tt_betting_answers.question_id, tt_betting_questions.score").where("tt_betting_answers.user_id is not null")

      @user_score_hash = Hash[users_question_score.map{|user| ["#{user.user_id}_#{user.question_id}" , user.score]}]

      users_total_score = Question.joins(
          "INNER JOIN tt_betting_answers ON tt_betting_answers.choice_id = tt_betting_questions.choice_id"
      ).select(
          "tt_betting_answers.user_id, sum(tt_betting_questions.score) as user_score").group("tt_betting_answers.user_id")

      @user_total_score_hash = Hash[users_total_score.map{|user| [user.user_id, user.user_score]}]
    end
  end
end
