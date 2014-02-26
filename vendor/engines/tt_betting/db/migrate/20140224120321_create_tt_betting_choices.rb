class CreateTtBettingChoices < ActiveRecord::Migration
  def change
    create_table :tt_betting_choices do |t|
      t.string :name, :null => false
      t.belongs_to :question, :null => false
      t.timestamps
    end
  end
end
