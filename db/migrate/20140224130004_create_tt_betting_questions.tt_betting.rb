# This migration comes from tt_betting (originally 20140224120332)
class CreateTtBettingQuestions < ActiveRecord::Migration
  def change
    create_table :tt_betting_questions do |t|
      t.string :name, :null => false
      t.datetime :time_to_expire, :null => false
      t.decimal :score, :null => false
      t.belongs_to :choice
      t.boolean :is_active, :default => false, :null => false
      t.timestamps
    end
  end
end
