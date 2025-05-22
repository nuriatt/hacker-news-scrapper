# frozen_string_literal: true

require 'debug'

class EntryParser
  def parse_entry(submission, metadata)
    id = submission.attribute('id').value
    rank = submission.css('span.rank').first.children.first.text.chomp('.').to_i
    title = submission.css('span.titleline').first.children.first.text

    score = metadata.css('span.score')
    score = score.empty? ? 0 : score.first.children.first.text.chomp(' points').to_i

    comments = metadata.css('a').at('a:contains("comments")')
    comments = comments.nil? ? 0 : comments.children.text.chomp(' comments').to_i

    Entry.new(id, rank, title, score, comments)
  end
end
