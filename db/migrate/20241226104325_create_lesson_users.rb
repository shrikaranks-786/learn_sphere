class CreateLessonUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :lesson_users do |t|
      t.references :lesson, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :completed

      t.timestamps
    end
  end
end
