class CreateTtBettingAnswers < ActiveRecord::Migration
  def change
    create_table :tt_betting_answers do |t|
      t.belongs_to :user, :null => false
      t.belongs_to :choice, :null => false
      t.belongs_to :question, :null => false
      t.timestamps
    end
  end
end
