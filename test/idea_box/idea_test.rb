require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

require './lib/idea_box/idea'

class IdeaTest < Minitest::Test

  def sample_idea
    {
      "title" => "money making idea",
      "description" => "make it rain from the comfort of your home",
      "rank" => 0,
      "id" => 45,
      "tags" => "idea, new, money",
      "created_at" => DateTime.now,
      "updated_at" => DateTime.now
    }
  end

  def sample_idea2
    {
      "title" => "shamwow",
      "description" => "we'll sell it for $19.99!!",
      "rank" => 0,
      "id" => 46,
      "tags" => "idea, new, money",
      "created_at" => DateTime.now,
      "updated_at" => DateTime.now
    }
  end

  def sample_idea3
    {
      "title" => "Freedom Rock",
      "description" => "we'll sell it for $19.99!!",
      "rank" => 0,
      "id" => 47,
      "tags" => "idea, freedom, money",
      "created_at" => DateTime.now,
      "updated_at" => DateTime.now
    }
  end

  def test_basic_idea
    idea = Idea.new(sample_idea)
    assert_equal "money making idea", idea.title
    assert_equal 45, idea.id
  end

  def test_ideas_can_be_liked
    idea = Idea.new(sample_idea)
    assert_equal 0, idea.rank # guard clause
    idea.like!
    assert_equal 1, idea.rank
    idea.like!
    assert_equal 2, idea.rank
  end

  def test_ideas_can_be_sorted_by_rank
    rain = Idea.new(sample_idea)
    shamwow = Idea.new(sample_idea2)
    freedom = Idea.new(sample_idea3)

    shamwow.like!
    shamwow.like!
    freedom.like!

    ideas = [rain, shamwow, freedom]

    assert_equal [shamwow, freedom, rain], ideas.sort
  end

  def test_it_can_convert_tag_string_to_array
    idea = Idea.new(sample_idea)
    assert_equal ["idea", "new", "money"], idea.tags_array
  end

  def test_it_can_convert_instance_variables_to_hash
    idea = Idea.new(sample_idea)
    test_hash = idea.to_h
    assert_equal test_hash["id"], idea.id
    assert_equal test_hash["title"], idea.title
  end

end
