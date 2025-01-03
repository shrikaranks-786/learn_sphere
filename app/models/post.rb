class Post < ApplicationRecord
  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 100, 100 ]
  end
  has_many :lessons
  has_many :post_users
  has_and_belongs_to_many :categories
  has_many :users, through: :post_users

  has_rich_text :description
  has_rich_text :premium_description

  def first_lesson
    self.lessons.order(:position).first
  end

  def next_lesson(current_user)
    if current_user.blank?
      return self.lessons.order(:position).first
    end

    completed_lessons = current_user.lesson_user.includes(:lesson).where(completed: true).where(lessons: { post_id: self.id })
    started_lessons = current_user.lesson_user.includes(:lesson).where(completed: false).where(lesson: { post_id: self.id }).order(:position)

    if started_lessons.any?
      return started_lessons.first.lesson
    end

    lessons = self.lessons.where.not(id: completed_lessons.pluck(:lesson_id)).order(:position)
    if lessons.any?
      lessons.first
    else
      self.lessons.order(:position).first
    end
  end
end
