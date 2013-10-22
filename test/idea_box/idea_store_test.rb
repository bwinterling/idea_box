gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/idea_box/idea'
require './lib/idea_box/idea_store'

class IdeaStoreTest < Minitest::Test

  # def teardown
  #   IdeaStore.delete_all
  # end

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

  def test_save_and_retrieve_an_idea
    skip
    idea = Idea.new(sample_idea)
    id = IdeaStore.save(idea)

    assert_equal 1, IdeaStore.count

    idea = IdeaStore.find(id)
    assert_equal "celebrate", idea.title
    assert_equal "with champagne", idea.description
  end

  def test_save_and_retrieve_one_of_many
    skip
    idea1 = Idea.new("relax", "in the sauna")
    idea2 = Idea.new("inspiration", "looking at the stars")
    idea3 = Idea.new("career", "translate for the UN")
    id1 = IdeaStore.save(idea1)
    id2 = IdeaStore.save(idea2)
    id3 = IdeaStore.save(idea3)

    assert_equal 3, IdeaStore.count

    idea = IdeaStore.find(id2)
    assert_equal "inspiration", idea.title
    assert_equal "looking at the stars", idea.description
  end

  def test_update_idea
    skip
    idea = Idea.new("drink", "tomato juice")
    id = IdeaStore.save(idea)

    idea = IdeaStore.find(id)
    idea.title = "cocktails"
    idea.description = "spicy tomato juice with vodka"

    IdeaStore.save(idea)

    assert_equal 1, IdeaStore.count

    idea = IdeaStore.find(id)
    assert_equal "cocktails", idea.title
    assert_equal "spicy tomato juice with vodka", idea.description
  end

end
