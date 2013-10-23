require 'pry'
require 'yaml/store'

class IdeaStore

  def self.database
    return @database if @database

    @database = YAML::Store.new('db/ideabox')
    @database.transaction do
      @database['ideas'] ||= []
    end
    @database
  end

  def self.groups
    @groups ||= ["Personal", "Work"]
  end

  def self.current_group
    @current_group ||= "Personal"
  end

  def self.current_group=(group)
    @current_group = group
  end

  def self.all
    ideas = []
    raw_ideas.each_with_index do |data, i|
      ideas << Idea.new(data.merge("id" => i))
    end
    ideas
  end

  def self.all_for_current_group
    ideas = []
    raw_ideas.each_with_index do |data, i|
      ideas << Idea.new(data.merge("id" => i))
    end
    ideas.find_all { |idea| idea.group == current_group }
  end

  def self.all_tags
    all_for_current_group.map { |idea| idea.tags_array }.flatten.uniq.sort
  end

  def self.view_by_tag(tag)
    if tag == "All"
      all
    else
      all.find_all { |idea| idea.tags_array.include?(tag) }
    end
  end

  def self.grouped_by_tags(tag)
    gbt = {}
    if tag == "All"
      all_tags.each do |key|
        gbt[key] = all_for_current_group.find_all {|idea| idea.tags_array.include?(key)}
      end
    else
      gbt[tag] = all_for_current_group.find_all {|idea| idea.tags_array.include?(tag)}
    end
    gbt
  end

  def self.grouped_by_dates(date)
    case date
    when "year" then grouped_by_year
    when "month" then grouped_by_month
    when "day" then grouped_by_day
    else
      all
    end
  end

  def self.grouped_by_year
    all_for_current_group.group_by { |idea| idea.created_at.strftime("%Y") }
  end

  def self.grouped_by_month
    all_for_current_group.group_by { |idea| idea.created_at.strftime("%b") }
  end

  def self.grouped_by_day
    all_for_current_group.group_by { |idea| idea.created_at.strftime("%A") }
  end

  def self.search_by(criteria)
    all.find_all { |idea| idea.searchable_text.upcase.include? criteria.upcase }.sort
  end

  def self.raw_ideas
    database.transaction do |db|
      db['ideas'] || []
    end
  end

  def self.delete(position)
    database.transaction do
      database['ideas'].delete_at(position)
    end
  end

  def self.find(id)
    raw_idea = find_raw_idea(id)
    Idea.new(raw_idea.merge("id" => id))
  end

  def self.find_raw_idea(id)
    database.transaction do
      database['ideas'].at(id)
    end
  end

  def self.update(id, params)
    return if params["title"].empty?
    idea = find(id.to_i)
    updated_params = idea.to_h.merge(params)
    updated_params["updated_at"] = DateTime.now
    database.transaction do
      database['ideas'][id] = updated_params
    end
  end

  def self.create(data)
    return if data["title"].empty?
    data["created_at"] = DateTime.now
    # data["group"] = current_group
    database.transaction do
      database['ideas'] << data
    end
  end

end
