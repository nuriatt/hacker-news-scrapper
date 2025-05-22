# frozen_string_literal: true

class TitleFilter
  def initialize(entries)
    @entries = entries
  end

  def more_than_five_words
    filtered = @entries.select { |entry| word_count(entry.title) > 5 }
    filtered.sort_by(&:comments).reverse
  end

  def less_than_or_equal_to_five_words
    filtered = @entries.select { |entry| word_count(entry.title) <= 5 }
    filtered.sort_by(&:score).reverse
  end

  private

  def word_count(title)
    split_title = title.split(/\s+/)
    # I decided to count numbers as words, ie: ruby version '3.5' or years like '2020'
    split_title.count { |word| word.match?(/[a-zA-Z0-9]/) }
  end
end
