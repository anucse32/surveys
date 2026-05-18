class Survey < ApplicationRecord
  has_many :responses, dependent: :destroy

  validates :question, presence: true, length: { maximum: 500 }

  scope :with_response_stats, -> {
    left_joins(:responses)
      .group(:id)
      .select(
        "surveys.*",
        "COUNT(responses.id) AS responses_count",
        "COALESCE(SUM(CASE WHEN responses.answer = 1 THEN 1 ELSE 0 END), 0) AS yes_count"
      )
  }

  def responses_count
    self[:responses_count] || responses.count
  end

  def yes_count
    self[:yes_count] || responses.where(answer: true).count
  end

  def no_count
    responses_count - yes_count
  end

  def yes_percentage
    return 0 if responses_count.zero?
    (yes_count.to_f / responses_count * 100).round
  end

  def no_percentage
    return 0 if responses_count.zero?
    100 - yes_percentage
  end
end
