# frozen_string_literal: true

require 'minitest/autorun'
require 'nokogiri'
require_relative '../lib/entry_parser'
require_relative '../lib/entry'

class TestEntryParser < Minitest::Test
  def setup
    @parser = EntryParser.new
  end

  def build_html_entry(html)
    document = Nokogiri::HTML(html)
    submission = document.at_css('tr.athing.submission')
    metadata = submission.next_element
    [submission, metadata]
  end

  def test_parse_entry_with_score_and_comments
    html = <<~HTML
      <tr class="athing submission" id="44057841">
        <td align="right" valign="top" class="title"><span class="rank">18.</span></td>
        <td valign="top" class="votelinks"><center><a id="up_44057841" href="vote?id=44057841&amp;how=up&amp;goto=news"><div class="votearrow" title="upvote"></div></a></center></td>
        <td class="title"><span class="titleline"><a href="https://maxwellforbes.com/posts/how-to-get-a-paper-accepted/">Getting a paper accepted</a><span class="sitebit comhead"> (<a href="from?site=maxwellforbes.com"><span class="sitestr">maxwellforbes.com</span></a>)</span></span></td>
      </tr>
      <tr>
        <td colspan="2"></td>
        <td class="subtext"><span class="subline">
          <span class="score" id="score_44057841">147 points</span> by <a href="user?id=stefanpie" class="hnuser">stefanpie</a> <span class="age" title="2025-05-22T01:19:41 1747876781"><a href="item?id=44057841">11 hours ago</a></span> <span id="unv_44057841"></span> | <a href="hide?id=44057841&amp;goto=news">hide</a> | <a href="item?id=44057841">67&nbsp;comments</a>
        </span></td>
      </tr>
    HTML

    submission, metadata = build_html_entry(html)
    entry = @parser.parse_entry(submission, metadata)

    assert_equal '44057841', entry.id
    assert_equal 18, entry.rank
    assert_equal 'Getting a paper accepted', entry.title
    assert_equal 147, entry.score
    assert_equal 67, entry.comments
  end

  def test_parse_entry_with_no_score_or_comments
    html = <<~HTML
      <tr class="athing submission" id="44056280">
        <td align="right" valign="top" class="title"><span class="rank">30.</span></td>
        <td><img src="s.gif" height="1" width="14"></td>
        <td class="title"><span class="titleline"><a href="https://jobs.ashbyhq.com/sorcerer/6beb70de-9956-49b7-8e28-f48ea39efac6" rel="nofollow">Sorcerer (YC S24) Is Hiring a Lead Hardware Design Engineer</a><span class="sitebit comhead"> (<a href="from?site=ashbyhq.com"><span class="sitestr">ashbyhq.com</span></a>)</span></span></td>
      </tr>
      <tr>
        <td colspan="2"></td>
        <td class="subtext">
          <span class="age" title="2025-05-21T21:00:11 1747861211"><a href="item?id=44056280">15 hours ago</a></span> | <a href="hide?id=44056280&amp;goto=news">hide</a>
        </td>
      </tr>
    HTML

    submission, metadata = build_html_entry(html)
    entry = @parser.parse_entry(submission, metadata)

    assert_equal '44056280', entry.id
    assert_equal 30, entry.rank
    assert_equal 'Sorcerer (YC S24) Is Hiring a Lead Hardware Design Engineer', entry.title
    assert_equal 0, entry.score
    assert_equal 0, entry.comments
  end
end
