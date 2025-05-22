# frozen_string_literal: true

class Entry
  attr_reader :id, :rank, :title, :score, :comments

  def initialize(id, rank, title, score, comments)
    @id = id
    @rank = rank
    @title = title
    @score = score
    @comments = comments
  end
end
